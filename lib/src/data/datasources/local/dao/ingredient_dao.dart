import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';

part 'ingredient_dao.g.dart';

@DriftAccessor(tables: [Ingredients, Stocks, StockMovements])
class IngredientDao extends DatabaseAccessor<AppDatabase> with _$IngredientDaoMixin {
  IngredientDao(super.db);

  // Basic CRUD operations
  Future<List<Ingredient>> getAllIngredients() => select(ingredients).get();

  Future<Ingredient?> getIngredientById(int id) =>
      (select(ingredients)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<Ingredient?> getIngredientByUuid(String uuid) =>
      (select(ingredients)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

  Future<List<Ingredient>> getActiveIngredients() =>
      (select(ingredients)..where((tbl) => tbl.isActive.equals(true))).get();

  Future<List<Ingredient>> getLowStockIngredients() {
    return (select(ingredients)
          ..where((tbl) => tbl.isActive.equals(true))
          ..where((tbl) => tbl.stockQuantity.isSmallerThan(tbl.minStockLevel)))
        .get();
  }

  Future<int> createIngredient(IngredientsCompanion ingredient) =>
      into(ingredients).insert(ingredient);

  Future<bool> updateIngredient(Ingredient ingredient) =>
      update(ingredients).replace(ingredient);

  Future<int> deleteIngredient(int id) =>
      (delete(ingredients)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> deleteIngredientByUuid(String uuid) =>
      (delete(ingredients)..where((tbl) => tbl.uuid.equals(uuid))).go();

  // Stock operations for ingredients
  Future<Stock?> getStockById(int id) =>
      (select(stocks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<Stock?> getStockByUuid(String uuid) =>
      (select(stocks)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

  Future<Stock?> getStockByIngredient(int ingredientId) =>
      (select(stocks)..where((tbl) => tbl.ingredientId.equals(ingredientId))).getSingleOrNull();

  Future<Stock?> getStockByIngredientUuid(String ingredientUuid) {
    final query = select(stocks).join([
      innerJoin(ingredients, ingredients.id.equalsExp(stocks.ingredientId)),
    ]);
    query.where(ingredients.uuid.equals(ingredientUuid));
    return query.getSingleOrNull().then((result) => result?.readTable(stocks));
  }

  Future<int> createStock(StocksCompanion stock) => into(stocks).insert(stock);

  Future<bool> updateStock(Stock stock) => update(stocks).replace(stock);

  // Stock movement operations for ingredients
  Future<List<StockMovement>> getStockMovementsByIngredient(int ingredientId) =>
      (select(stockMovements)..where((tbl) => tbl.ingredientId.equals(ingredientId))).get();

  Future<List<StockMovement>> getStockMovementsByIngredientUuid(String ingredientUuid) {
    final query = select(stockMovements).join([
      innerJoin(ingredients, ingredients.id.equalsExp(stockMovements.ingredientId)),
    ]);
    query.where(ingredients.uuid.equals(ingredientUuid));
    return query.get().then((results) => results.map((result) => result.readTable(stockMovements)).toList());
  }

  Future<List<StockMovement>> getStockMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(stockMovements)
          ..where((tbl) => tbl.createdAt.isBetweenValues(startDate, endDate))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<StockMovement>> getStockMovementsByType(String movementType) =>
      (select(stockMovements)..where((tbl) => tbl.movementType.equals(movementType))).get();

  Future<int> createStockMovement(StockMovementsCompanion movement) =>
      into(stockMovements).insert(movement);

  // Batch operations
  Future<void> createBulkStockMovements(List<StockMovementsCompanion> movements) =>
      batch((batch) => batch.insertAll(stockMovements, movements));

  // Stock adjustment operations
  Future<void> adjustStock(
    int stockId,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  ) async {
    final currentStock = await getStockById(stockId);
    if (currentStock == null) return;

    final previousQuantity = currentStock.quantity;
    
    // Create stock movement record
    await createStockMovement(
      StockMovementsCompanion.insert(
        uuid: const Uuid().v4(),
        productId: 0,
        variantId: const Value.absent(),
        ingredientId: Value(currentStock.ingredientId),
        movementType: 'adjustment',
        quantity: newQuantity - previousQuantity,
        previousQuantity: previousQuantity,
        newQuantity: newQuantity,
        reason: Value(reason),
        referenceId: Value(referenceId),
        referenceType: Value(referenceType),
      ),
    );

    // Update stock quantity
    await updateStock(
      currentStock.copyWith(
        quantity: newQuantity,
        availableQuantity: newQuantity - currentStock.reservedQuantity,
        lastUpdated: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Stock opname operations
  Future<List<Stock>> getStocksForOpname() {
    final query = select(stocks).join([
      leftOuterJoin(ingredients, ingredients.id.equalsExp(stocks.ingredientId)),
    ]);
    query.where(stocks.ingredientId.isNotNull());
    return query.get().then((results) => results.map((result) => result.readTable(stocks)).toList());
  }

  Future<void> processStockOpname(
    List<Map<String, dynamic>> opnameData,
    String reason,
  ) async {
    await transaction(() async {
      for (final data in opnameData) {
        final stockId = data['stockId'] as int;
        final countedQuantity = data['countedQuantity'] as int;
        
        await adjustStock(
          stockId,
          countedQuantity,
          reason,
          null,
          'opname',
        );
      }
    });
  }

  // Stock alert operations
  Future<List<Map<String, dynamic>>> getStockAlerts() async {
    final query = select(ingredients).join([
      leftOuterJoin(stocks, stocks.ingredientId.equalsExp(ingredients.id)),
    ]);
    query.where(ingredients.isActive.equals(true));
    query.where(ingredients.stockQuantity.isSmallerThan(ingredients.minStockLevel));
    
    final results = await query.get();
    return results.map((result) {
      final ingredient = result.readTable(ingredients);
      final stock = result.readTableOrNull(stocks);
      return {
        'id': ingredient.id,
        'uuid': ingredient.uuid,
        'name': ingredient.name,
        'currentStock': ingredient.stockQuantity,
        'minStockLevel': ingredient.minStockLevel,
        'stockId': stock?.id,
        'alertLevel': ingredient.minStockLevel - ingredient.stockQuantity,
      };
    }).toList();
  }

  Future<bool> checkLowStockAlerts() async {
    final lowStockCount = await (selectOnly(ingredients)
          ..addColumns([ingredients.id])
          ..where(ingredients.isActive.equals(true))
          ..where(ingredients.stockQuantity.isSmallerThan(ingredients.minStockLevel)))
        .get()
        .then((results) => results.length);
    
    return lowStockCount > 0;
  }

  // Stock reconciliation operations
  Future<Map<String, dynamic>> getStockReconciliation(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = select(stockMovements).join([
      leftOuterJoin(ingredients, ingredients.id.equalsExp(stockMovements.ingredientId)),
    ]);
    query.where(stockMovements.ingredientId.isNotNull());
    query.where(stockMovements.createdAt.isBetweenValues(startDate, endDate));
    
    final results = await query.get();
    
    int totalIn = 0;
    int totalOut = 0;
    int totalAdjustment = 0;
    
    for (final result in results) {
      final movement = result.readTable(stockMovements);
      final quantity = movement.quantity.abs();
      
      switch (movement.movementType) {
        case 'in':
        case 'purchase':
          totalIn += quantity;
          break;
        case 'out':
        case 'sale':
          totalOut += quantity;
          break;
        case 'adjustment':
          totalAdjustment += quantity;
          break;
      }
    }
    
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalIn': totalIn,
      'totalOut': totalOut,
      'totalAdjustment': totalAdjustment,
      'netChange': totalIn - totalOut + totalAdjustment,
      'movementCount': results.length,
    };
  }

  Future<List<Map<String, dynamic>>> getStockDiscrepancies(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = select(stockMovements).join([
      leftOuterJoin(ingredients, ingredients.id.equalsExp(stockMovements.ingredientId)),
      leftOuterJoin(stocks, stocks.ingredientId.equalsExp(ingredients.id)),
    ]);
    query.where(stockMovements.ingredientId.isNotNull());
    query.where(stockMovements.movementType.equals('adjustment'));
    query.where(stockMovements.createdAt.isBetweenValues(startDate, endDate));
    query.where(stockMovements.quantity.equals(0).not());
    
    final results = await query.get();
    
    return results.map((result) {
      final movement = result.readTable(stockMovements);
      final ingredient = result.readTable(ingredients);
      final stock = result.readTableOrNull(stocks);
      
      return {
        'id': movement.id,
        'uuid': movement.uuid,
        'ingredientId': ingredient.id,
        'ingredientUuid': ingredient.uuid,
        'ingredientName': ingredient.name,
        'previousQuantity': movement.previousQuantity,
        'newQuantity': movement.newQuantity,
        'discrepancy': movement.newQuantity - movement.previousQuantity,
        'reason': movement.reason,
        'createdAt': movement.createdAt.toIso8601String(),
        'currentStock': stock?.quantity,
      };
    }).toList();
  }
}