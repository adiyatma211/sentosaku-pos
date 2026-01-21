import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_database.dart';

class DatabaseProvider {
  late AppDatabase _database;
  final Completer<AppDatabase> _dbCompleter = Completer<AppDatabase>();

  Future<AppDatabase> get database async {
    if (!_dbCompleter.isCompleted) {
      _database = AppDatabase();
      _dbCompleter.complete(_database);
    }
    return _dbCompleter.future;
  }

  // Ingredient operations
  Future<List<Ingredient>> getAllIngredients() async {
    final db = await database;
    return (db.select(db.ingredients)).get();
  }

  Future<Ingredient?> getIngredientById(int id) async {
    final db = await database;
    return (db.select(db.ingredients)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<Ingredient?> getIngredientByUuid(String uuid) async {
    final db = await database;
    return (db.select(db.ingredients)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<List<Ingredient>> getActiveIngredients() async {
    final db = await database;
    return (db.select(db.ingredients)..where((tbl) => tbl.isActive.equals(true))).get();
  }

  Future<List<Ingredient>> getLowStockIngredients() async {
    final db = await database;
    return (db.select(db.ingredients)
          ..where((tbl) => tbl.isActive.equals(true))
          ..where((tbl) => tbl.stockQuantity.isSmallerThan(tbl.minStockLevel)))
        .get();
  }

  Future<int> createIngredient(Ingredient ingredient) async {
    final db = await database;
    return db.into(db.ingredients).insert(IngredientsCompanion.insert(
      uuid: ingredient.uuid,
      name: ingredient.name,
      description: ingredient.description != null ? Value(ingredient.description!) : const Value.absent(),
      unit: ingredient.unit != null ? Value(ingredient.unit!) : const Value.absent(),
      stockQuantity: Value(ingredient.stockQuantity),
      minStockLevel: Value(ingredient.minStockLevel),
      maxStockLevel: ingredient.maxStockLevel != null ? Value(ingredient.maxStockLevel!) : const Value.absent(),
      cost: ingredient.cost,
      isActive: Value(ingredient.isActive),
      createdAt: Value(ingredient.createdAt),
      updatedAt: Value(ingredient.updatedAt),
    ));
  }

  Future<bool> updateIngredient(Ingredient ingredient) async {
    final db = await database;
    await db.update(db.ingredients).replace(IngredientsCompanion(
      id: Value(ingredient.id),
      uuid: Value(ingredient.uuid),
      name: Value(ingredient.name),
      description: ingredient.description != null ? Value(ingredient.description!) : const Value.absent(),
      unit: ingredient.unit != null ? Value(ingredient.unit!) : const Value.absent(),
      stockQuantity: Value(ingredient.stockQuantity),
      minStockLevel: Value(ingredient.minStockLevel),
      maxStockLevel: ingredient.maxStockLevel != null ? Value(ingredient.maxStockLevel!) : const Value.absent(),
      cost: Value(ingredient.cost),
      isActive: Value(ingredient.isActive),
      createdAt: Value(ingredient.createdAt),
      updatedAt: Value(ingredient.updatedAt),
    ));
    return true;
  }

  Future<void> deleteIngredient(int id) async {
    final db = await database;
    await (db.delete(db.ingredients)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteIngredientByUuid(String uuid) async {
    final db = await database;
    await (db.delete(db.ingredients)..where((tbl) => tbl.uuid.equals(uuid))).go();
  }

  // Product operations with inventory
  Future<List<Product>> getAllProductsWithInventory() async {
    final db = await database;
    return (db.select(db.products)).get();
  }

  Future<Product?> getProductWithInventory(int id) async {
    final db = await database;
    return (db.select(db.products)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<Product?> getProductWithInventoryByUuid(String uuid) async {
    final db = await database;
    return (db.select(db.products)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<List<Product>> getLowStockProducts() async {
    final db = await database;
    return (db.select(db.products)
          ..where((tbl) => tbl.isTrackStock.equals(true))
          ..where((tbl) => tbl.stockQuantity.isSmallerThan(tbl.minStockLevel)))
        .get();
  }

  Future<Product?> updateProductInventory(int productId, int quantity) async {
    final db = await database;
    final product = await (db.select(db.products)..where((tbl) => tbl.id.equals(productId))).getSingleOrNull();
    if (product != null) {
      final updatedProduct = product.copyWith(stockQuantity: quantity);
      await db.update(db.products).replace(updatedProduct);
      return updatedProduct;
    }
    return null;
  }

  Future<Product?> updateProductInventoryByUuid(String productUuid, int quantity) async {
    final db = await database;
    final product = await (db.select(db.products)..where((tbl) => tbl.uuid.equals(productUuid))).getSingleOrNull();
    if (product != null) {
      final updatedProduct = product.copyWith(stockQuantity: quantity);
      await db.update(db.products).replace(updatedProduct);
      return updatedProduct;
    }
    return null;
  }

  // Stock operations
  Future<List<Stock>> getAllStocks() async {
    final db = await database;
    return (db.select(db.stocks)).get();
  }

  Future<Stock?> getStockById(int id) async {
    final db = await database;
    return (db.select(db.stocks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<Stock?> getStockByUuid(String uuid) async {
    final db = await database;
    return (db.select(db.stocks)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<Stock?> getStockByProduct(int productId) async {
    final db = await database;
    return (db.select(db.stocks)..where((tbl) => tbl.productId.equals(productId))).getSingleOrNull();
  }

  Future<Stock?> getStockByProductUuid(String productUuid) async {
    final db = await database;
    final query = db.select(db.stocks).join([
      innerJoin(db.products, db.products.id.equalsExp(db.stocks.productId)),
    ]);
    query.where(db.products.uuid.equals(productUuid));
    final result = await query.getSingleOrNull();
    return result?.readTable(db.stocks);
  }

  Future<Stock?> getStockByVariant(int variantId) async {
    final db = await database;
    return (db.select(db.stocks)..where((tbl) => tbl.variantId.equals(variantId))).getSingleOrNull();
  }

  Future<Stock?> getStockByIngredient(int ingredientId) async {
    final db = await database;
    return (db.select(db.stocks)..where((tbl) => tbl.ingredientId.equals(ingredientId))).getSingleOrNull();
  }

  Future<Stock?> getStockByIngredientUuid(String ingredientUuid) async {
    final db = await database;
    final query = db.select(db.stocks).join([
      innerJoin(db.ingredients, db.ingredients.id.equalsExp(db.stocks.ingredientId)),
    ]);
    query.where(db.ingredients.uuid.equals(ingredientUuid));
    final result = await query.getSingleOrNull();
    return result?.readTable(db.stocks);
  }

  Future<int> createStock(Stock stock) async {
    final db = await database;
    return db.into(db.stocks).insert(StocksCompanion(
      uuid: Value(stock.uuid),
      productId: Value(stock.productId),
      variantId: Value(stock.variantId),
      ingredientId: Value(stock.ingredientId),
      quantity: Value(stock.quantity),
      reservedQuantity: Value(stock.reservedQuantity),
      availableQuantity: Value(stock.availableQuantity),
      lastUpdated: Value(stock.lastUpdated),
      createdAt: Value(stock.createdAt),
      updatedAt: Value(stock.updatedAt),
    ));
  }

  Future<bool> updateStock(Stock stock) async {
    final db = await database;
    await db.update(db.stocks).replace(StocksCompanion(
      id: Value(stock.id),
      uuid: Value(stock.uuid),
      productId: Value(stock.productId),
      variantId: Value(stock.variantId),
      ingredientId: Value(stock.ingredientId),
      quantity: Value(stock.quantity),
      reservedQuantity: Value(stock.reservedQuantity),
      availableQuantity: Value(stock.availableQuantity),
      lastUpdated: Value(stock.lastUpdated),
      createdAt: Value(stock.createdAt),
      updatedAt: Value(stock.updatedAt),
    ));
    return true;
  }

  Future<void> deleteStock(int id) async {
    final db = await database;
    await (db.delete(db.stocks)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteStockByUuid(String uuid) async {
    final db = await database;
    await (db.delete(db.stocks)..where((tbl) => tbl.uuid.equals(uuid))).go();
  }

  // Stock movement operations
  Future<List<StockMovement>> getAllStockMovements() async {
    final db = await database;
    return (db.select(db.stockMovements)).get();
  }

  Future<List<StockMovement>> getStockMovementsByProduct(int productId) async {
    final db = await database;
    return (db.select(db.stockMovements)..where((tbl) => tbl.productId.equals(productId))).get();
  }

  Future<List<StockMovement>> getStockMovementsByIngredient(int ingredientId) async {
    final db = await database;
    return (db.select(db.stockMovements)..where((tbl) => tbl.ingredientId.equals(ingredientId))).get();
  }

  Future<List<StockMovement>> getStockMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    return (db.select(db.stockMovements)
          ..where((tbl) => tbl.createdAt.isBetweenValues(startDate, endDate))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<StockMovement>> getStockMovementsByType(String movementType) async {
    final db = await database;
    return (db.select(db.stockMovements)..where((tbl) => tbl.movementType.equals(movementType))).get();
  }

  Future<int> createStockMovement(StockMovement movement) async {
    final db = await database;
    return db.into(db.stockMovements).insert(StockMovementsCompanion(
      uuid: Value(movement.uuid),
      productId: Value(movement.productId),
      variantId: Value(movement.variantId),
      ingredientId: Value(movement.ingredientId),
      movementType: Value(movement.movementType),
      quantity: Value(movement.quantity),
      previousQuantity: Value(movement.previousQuantity),
      newQuantity: Value(movement.newQuantity),
      reason: Value(movement.reason),
      referenceId: Value(movement.referenceId),
      referenceType: Value(movement.referenceType),
      createdAt: Value(movement.createdAt),
      updatedAt: Value(movement.updatedAt),
    ));
  }

  Future<void> createBulkStockMovements(List<StockMovement> movements) async {
    final db = await database;
    await db.batch((batch) {
      for (final movement in movements) {
        batch.insert(db.stockMovements, StockMovementsCompanion(
          uuid: Value(movement.uuid),
          productId: Value(movement.productId),
          variantId: Value(movement.variantId),
          ingredientId: Value(movement.ingredientId),
          movementType: Value(movement.movementType),
          quantity: Value(movement.quantity),
          previousQuantity: Value(movement.previousQuantity),
          newQuantity: Value(movement.newQuantity),
          reason: Value(movement.reason),
          referenceId: Value(movement.referenceId),
          referenceType: Value(movement.referenceType),
          createdAt: Value(movement.createdAt),
          updatedAt: Value(movement.updatedAt),
        ));
      }
    });
  }

  // Recipe operations
  Future<List<Recipe>> getAllRecipes() async {
    final db = await database;
    return (db.select(db.recipes)).get();
  }

  Future<Recipe?> getRecipeById(int id) async {
    final db = await database;
    return (db.select(db.recipes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<Recipe?> getRecipeByUuid(String uuid) async {
    final db = await database;
    return (db.select(db.recipes)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<List<Recipe>> getRecipesByProduct(int productId) async {
    final db = await database;
    return (db.select(db.recipes)..where((tbl) => tbl.productId.equals(productId))).get();
  }

  Future<List<Recipe>> getRecipesByProductUuid(String productUuid) async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.products, db.products.id.equalsExp(db.recipes.productId)),
    ]);
    query.where(db.products.uuid.equals(productUuid));
    final results = await query.get();
    return results.map((result) => result.readTable(db.recipes)).toList();
  }

  Future<List<Recipe>> getRecipesByIngredient(int ingredientId) async {
    final db = await database;
    return (db.select(db.recipes)..where((tbl) => tbl.ingredientId.equals(ingredientId))).get();
  }

  Future<List<Recipe>> getRecipesByIngredientUuid(String ingredientUuid) async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.ingredients, db.ingredients.id.equalsExp(db.recipes.ingredientId)),
    ]);
    query.where(db.ingredients.uuid.equals(ingredientUuid));
    final results = await query.get();
    return results.map((result) => result.readTable(db.recipes)).toList();
  }

  Future<int> createRecipe(Recipe recipe) async {
    final db = await database;
    return db.into(db.recipes).insert(RecipesCompanion.insert(
      uuid: recipe.uuid,
      productId: recipe.productId,
      ingredientId: recipe.ingredientId,
      quantity: recipe.quantity,
      unit: recipe.unit,
      createdAt: Value(recipe.createdAt),
      updatedAt: Value(recipe.updatedAt),
    ));
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    final db = await database;
    await db.update(db.recipes).replace(RecipesCompanion(
      id: Value(recipe.id),
      uuid: Value(recipe.uuid),
      productId: Value(recipe.productId),
      ingredientId: Value(recipe.ingredientId),
      quantity: Value(recipe.quantity),
      unit: Value(recipe.unit),
      createdAt: Value(recipe.createdAt),
      updatedAt: Value(recipe.updatedAt),
    ));
    return true;
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    await (db.delete(db.recipes)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteRecipeByUuid(String uuid) async {
    final db = await database;
    await (db.delete(db.recipes)..where((tbl) => tbl.uuid.equals(uuid))).go();
  }

  Future<void> deleteRecipesByProduct(int productId) async {
    final db = await database;
    await (db.delete(db.recipes)..where((tbl) => tbl.productId.equals(productId))).go();
  }

  Future<void> deleteRecipesByProductUuid(String productUuid) async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.products, db.products.id.equalsExp(db.recipes.productId)),
    ]);
    query.where(db.products.uuid.equals(productUuid));
    final results = await query.get();
    
    await db.transaction(() async {
      for (final result in results) {
        final recipe = result.readTable(db.recipes);
        await (db.delete(db.recipes)..where((tbl) => tbl.id.equals(recipe.id))).go();
      }
    });
  }

  Future<List<Recipe>> getRecipeVariants(int productId) async {
    final db = await database;
    return (db.select(db.recipes)..where((tbl) => tbl.productId.equals(productId))).get();
  }

  Future<List<Recipe>> getRecipeVariantsByUuid(String productUuid) async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.products, db.products.id.equalsExp(db.recipes.productId)),
    ]);
    query.where(db.products.uuid.equals(productUuid));
    final results = await query.get();
    return results.map((result) => result.readTable(db.recipes)).toList();
  }

  Future<List<Map<String, dynamic>>> getRecipesWithIngredientDetails() async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.ingredients, db.ingredients.id.equalsExp(db.recipes.ingredientId)),
    ]);
    final results = await query.get();
    return results.map((result) {
      final recipe = result.readTable(db.recipes);
      final ingredient = result.readTable(db.ingredients);
      return {
        'recipe': recipe,
        'ingredient': ingredient,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getRecipesByProductWithIngredientDetails(int productId) async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.products, db.products.id.equalsExp(db.recipes.productId)),
      innerJoin(db.ingredients, db.ingredients.id.equalsExp(db.recipes.ingredientId)),
    ]);
    query.where(db.recipes.productId.equals(productId));
    final results = await query.get();
    return results.map((result) {
      final recipe = result.readTable(db.recipes);
      final ingredient = result.readTable(db.ingredients);
      return {
        'recipe': recipe,
        'ingredient': ingredient,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getRecipesByProductWithIngredientDetailsByUuid(String productUuid) async {
    final db = await database;
    final query = db.select(db.recipes).join([
      innerJoin(db.products, db.products.id.equalsExp(db.recipes.productId)),
      innerJoin(db.ingredients, db.ingredients.id.equalsExp(db.recipes.ingredientId)),
    ]);
    query.where(db.products.uuid.equals(productUuid));
    final results = await query.get();
    return results.map((result) {
      final recipe = result.readTable(db.recipes);
      final ingredient = result.readTable(db.ingredients);
      return {
        'recipe': recipe,
        'ingredient': ingredient,
      };
    }).toList();
  }

  Future<List<int>> createBulkRecipes(List<Recipe> recipes) async {
    final db = await database;
    final ids = <int>[];
    await db.batch((batch) {
      for (final recipe in recipes) {
        batch.insert(db.recipes, RecipesCompanion.insert(
          uuid: recipe.uuid,
          productId: recipe.productId,
          ingredientId: recipe.ingredientId,
          quantity: recipe.quantity,
          unit: recipe.unit,
          createdAt: Value(recipe.createdAt),
          updatedAt: Value(recipe.updatedAt),
        ));
      }
    });
    // Query the inserted recipes to get their IDs
    final insertedRecipes = await (db.select(db.recipes)
          ..where((tbl) => tbl.uuid.isIn(recipes.map((r) => r.uuid).toList())))
        .get();
    return insertedRecipes.map((r) => r.id).toList();
  }

  Future<bool> updateBulkRecipes(List<Recipe> recipes) async {
    final db = await database;
    await db.batch((batch) {
      for (final recipe in recipes) {
        batch.update(db.recipes, RecipesCompanion(
          id: Value(recipe.id),
          uuid: Value(recipe.uuid),
          productId: Value(recipe.productId),
          ingredientId: Value(recipe.ingredientId),
          quantity: Value(recipe.quantity),
          unit: Value(recipe.unit),
          createdAt: Value(recipe.createdAt),
          updatedAt: Value(recipe.updatedAt),
        ));
      }
    });
    return true;
  }

  Future<void> deleteBulkRecipes(List<int> recipeIds) async {
    final db = await database;
    await db.transaction(() async {
      for (final id in recipeIds) {
        await (db.delete(db.recipes)..where((tbl) => tbl.id.equals(id))).go();
      }
    });
  }

  Future<void> deleteBulkRecipesByUuid(List<String> recipeUuids) async {
    final db = await database;
    await db.transaction(() async {
      for (final uuid in recipeUuids) {
        await (db.delete(db.recipes)..where((tbl) => tbl.uuid.equals(uuid))).go();
      }
    });
  }

  // Stock adjustment operations
  Future<Stock?> adjustStock(
    int stockId,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  ) async {
    final db = await database;
    final currentStock = await (db.select(db.stocks)..where((tbl) => tbl.id.equals(stockId))).getSingleOrNull();
    if (currentStock == null) return null;

    final previousQuantity = currentStock.quantity;
    
    // Create stock movement record
    await db.into(db.stockMovements).insert(StockMovementsCompanion.insert(
      uuid: const Uuid().v4(),
      productId: currentStock.productId,
      variantId: currentStock.variantId != null ? Value(currentStock.variantId!) : const Value.absent(),
      ingredientId: currentStock.ingredientId != null ? Value(currentStock.ingredientId!) : const Value.absent(),
      movementType: 'adjustment',
      quantity: newQuantity - previousQuantity,
      previousQuantity: previousQuantity,
      newQuantity: newQuantity,
      reason: reason != null ? Value(reason) : const Value.absent(),
      referenceId: Value(referenceId),
      referenceType: Value(referenceType),
    ));

    // Update stock quantity
    final updatedStock = currentStock.copyWith(
      quantity: newQuantity,
      availableQuantity: newQuantity - currentStock.reservedQuantity,
      lastUpdated: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await db.update(db.stocks).replace(updatedStock);
    
    return updatedStock;
  }

  Future<Stock?> adjustStockByUuid(
    String stockUuid,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  ) async {
    final db = await database;
    final currentStock = await (db.select(db.stocks)..where((tbl) => tbl.uuid.equals(stockUuid))).getSingleOrNull();
    if (currentStock == null) return null;

    final previousQuantity = currentStock.quantity;
    
    // Create stock movement record
    await db.into(db.stockMovements).insert(StockMovementsCompanion.insert(
      uuid: const Uuid().v4(),
      productId: currentStock.productId,
      variantId: currentStock.variantId != null ? Value(currentStock.variantId!) : const Value.absent(),
      ingredientId: currentStock.ingredientId != null ? Value(currentStock.ingredientId!) : const Value.absent(),
      movementType: 'adjustment',
      quantity: newQuantity - previousQuantity,
      previousQuantity: previousQuantity,
      newQuantity: newQuantity,
      reason: reason != null ? Value(reason) : const Value.absent(),
      referenceId: Value(referenceId),
      referenceType: Value(referenceType),
    ));

    // Update stock quantity
    final updatedStock = currentStock.copyWith(
      quantity: newQuantity,
      availableQuantity: newQuantity - currentStock.reservedQuantity,
      lastUpdated: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await db.update(db.stocks).replace(updatedStock);
    
    return updatedStock;
  }

  // Stock opname operations
  Future<List<Stock>> getStocksForOpname() async {
    final db = await database;
    final query = db.select(db.stocks).join([
      leftOuterJoin(db.ingredients, db.ingredients.id.equalsExp(db.stocks.ingredientId)),
    ]);
    query.where(db.stocks.ingredientId.isNotNull());
    final results = await query.get();
    return results.map((result) => result.readTable(db.stocks)).toList();
  }

  Future<void> processStockOpname(
    List<Map<String, dynamic>> opnameData,
    String reason,
  ) async {
    final db = await database;
    await db.transaction(() async {
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
    final db = await database;
    final query = db.select(db.ingredients).join([
      leftOuterJoin(db.stocks, db.stocks.ingredientId.equalsExp(db.ingredients.id)),
    ]);
    query.where(db.ingredients.isActive.equals(true));
    query.where(db.ingredients.stockQuantity.isSmallerThan(db.ingredients.minStockLevel));
    
    final results = await query.get();
    return results.map((result) {
      final ingredient = result.readTable(db.ingredients);
      final stock = result.readTableOrNull(db.stocks);
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
    final db = await database;
    final lowStockCount = await (db.selectOnly(db.ingredients)
          ..addColumns([db.ingredients.id])
          ..where(db.ingredients.isActive.equals(true))
          ..where(db.ingredients.stockQuantity.isSmallerThan(db.ingredients.minStockLevel)))
        .get()
        .then((results) => results.length);
    
    return lowStockCount > 0;
  }

  Future<void> updateMinStockLevel(
    int itemId,
    int minLevel, {
    bool isIngredient = false,
  }) async {
    final db = await database;
    if (isIngredient) {
      await (db.update(db.ingredients)..where((tbl) => tbl.id.equals(itemId)))
          .write(IngredientsCompanion(minStockLevel: Value(minLevel)));
    } else {
      await (db.update(db.products)..where((tbl) => tbl.id.equals(itemId)))
          .write(ProductsCompanion(minStockLevel: Value(minLevel)));
    }
  }

  // Stock reconciliation operations
  Future<Map<String, dynamic>> getStockReconciliation(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final query = db.select(db.stockMovements).join([
      leftOuterJoin(db.ingredients, db.ingredients.id.equalsExp(db.stockMovements.ingredientId)),
    ]);
    query.where(db.stockMovements.ingredientId.isNotNull());
    query.where(db.stockMovements.createdAt.isBetweenValues(startDate, endDate));
    
    final results = await query.get();
    
    int totalIn = 0;
    int totalOut = 0;
    int totalAdjustment = 0;
    
    for (final result in results) {
      final movement = result.readTable(db.stockMovements);
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
    final db = await database;
    final query = db.select(db.stockMovements).join([
      leftOuterJoin(db.ingredients, db.ingredients.id.equalsExp(db.stockMovements.ingredientId)),
      leftOuterJoin(db.stocks, db.stocks.ingredientId.equalsExp(db.ingredients.id)),
    ]);
    query.where(db.stockMovements.ingredientId.isNotNull());
    query.where(db.stockMovements.movementType.equals('adjustment'));
    query.where(db.stockMovements.createdAt.isBetweenValues(startDate, endDate));
    query.where(db.stockMovements.quantity.equals(0).not());
    
    final results = await query.get();
    
    return results.map((result) {
      final movement = result.readTable(db.stockMovements);
      final ingredient = result.readTable(db.ingredients);
      final stock = result.readTableOrNull(db.stocks);
      
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
