import 'package:dartz/dartz.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/failure.dart';
import '../../domain/repositories/inventory_repository_interface.dart';
import '../datasources/local/database_provider.dart';
import '../mappers/entity_mapper.dart';

class InventoryRepository implements InventoryRepositoryInterface {
  final DatabaseProvider _databaseProvider;

  InventoryRepository(this._databaseProvider);

  @override
  Future<Either<Failure, List<Ingredient>>> getAllIngredients() async {
    try {
      final dbIngredients = await _databaseProvider.getAllIngredients();
      final ingredients = dbIngredients.map((dbIng) => toDomainIngredient(dbIng)).toList();
      return Right(ingredients);
    } catch (e) {
      return Left(Failure(message: 'Failed to get ingredients: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingredient>> getIngredientById(int id) async {
    try {
      final dbIngredient = await _databaseProvider.getIngredientById(id);
      if (dbIngredient == null) {
        return Left(Failure(message: 'Ingredient not found'));
      }
      return Right(toDomainIngredient(dbIngredient));
    } catch (e) {
      return Left(Failure(message: 'Failed to get ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingredient>> getIngredientByUuid(String uuid) async {
    try {
      final dbIngredient = await _databaseProvider.getIngredientByUuid(uuid);
      if (dbIngredient == null) {
        return Left(Failure(message: 'Ingredient not found'));
      }
      return Right(toDomainIngredient(dbIngredient));
    } catch (e) {
      return Left(Failure(message: 'Failed to get ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> getActiveIngredients() async {
    try {
      final dbIngredients = await _databaseProvider.getActiveIngredients();
      final ingredients = dbIngredients.map((dbIng) => toDomainIngredient(dbIng)).toList();
      return Right(ingredients);
    } catch (e) {
      return Left(Failure(message: 'Failed to get active ingredients: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> getLowStockIngredients() async {
    try {
      final dbIngredients = await _databaseProvider.getLowStockIngredients();
      final ingredients = dbIngredients.map((dbIng) => toDomainIngredient(dbIng)).toList();
      return Right(ingredients);
    } catch (e) {
      return Left(Failure(message: 'Failed to get low stock ingredients: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingredient>> createIngredient(Ingredient ingredient) async {
    try {
      final dbIngredient = toDbIngredient(ingredient);
      final id = await _databaseProvider.createIngredient(dbIngredient);
      final createdIngredient = ingredient.copyWith(id: id);
      return Right(createdIngredient);
    } catch (e) {
      return Left(Failure(message: 'Failed to create ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingredient>> updateIngredient(Ingredient ingredient) async {
    try {
      final dbIngredient = toDbIngredient(ingredient);
      final success = await _databaseProvider.updateIngredient(dbIngredient);
      if (!success) {
        return Left(Failure(message: 'Failed to update ingredient'));
      }
      return Right(ingredient);
    } catch (e) {
      return Left(Failure(message: 'Failed to update ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIngredient(int id) async {
    try {
      await _databaseProvider.deleteIngredient(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIngredientByUuid(String uuid) async {
    try {
      await _databaseProvider.deleteIngredientByUuid(uuid);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete ingredient: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProductsWithInventory() async {
    try {
      final dbProducts = await _databaseProvider.getAllProductsWithInventory();
      final products = dbProducts.map((dbProd) => toDomainProduct(dbProd)).toList();
      return Right(products);
    } catch (e) {
      return Left(Failure(message: 'Failed to get products with inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductWithInventory(int id) async {
    try {
      final dbProduct = await _databaseProvider.getProductWithInventory(id);
      if (dbProduct == null) {
        return Left(Failure(message: 'Product not found'));
      }
      return Right(toDomainProduct(dbProduct));
    } catch (e) {
      return Left(Failure(message: 'Failed to get product with inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductWithInventoryByUuid(String uuid) async {
    try {
      final dbProduct = await _databaseProvider.getProductWithInventoryByUuid(uuid);
      if (dbProduct == null) {
        return Left(Failure(message: 'Product not found'));
      }
      return Right(toDomainProduct(dbProduct));
    } catch (e) {
      return Left(Failure(message: 'Failed to get product with inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts() async {
    try {
      final dbProducts = await _databaseProvider.getLowStockProducts();
      final products = dbProducts.map((dbProd) => toDomainProduct(dbProd)).toList();
      return Right(products);
    } catch (e) {
      return Left(Failure(message: 'Failed to get low stock products: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProductInventory(int productId, int quantity) async {
    try {
      final dbProduct = await _databaseProvider.updateProductInventory(productId, quantity);
      if (dbProduct == null) {
        return Left(Failure(message: 'Product not found'));
      }
      return Right(toDomainProduct(dbProduct));
    } catch (e) {
      return Left(Failure(message: 'Failed to update product inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProductInventoryByUuid(String productUuid, int quantity) async {
    try {
      final dbProduct = await _databaseProvider.updateProductInventoryByUuid(productUuid, quantity);
      if (dbProduct == null) {
        return Left(Failure(message: 'Product not found'));
      }
      return Right(toDomainProduct(dbProduct));
    } catch (e) {
      return Left(Failure(message: 'Failed to update product inventory: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Stock>>> getAllStocks() async {
    try {
      final dbStocks = await _databaseProvider.getAllStocks();
      final stocks = dbStocks.map((dbStock) => toDomainStock(dbStock)).toList();
      return Right(stocks);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stocks: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockById(int id) async {
    try {
      final dbStock = await _databaseProvider.getStockById(id);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByUuid(String uuid) async {
    try {
      final dbStock = await _databaseProvider.getStockByUuid(uuid);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByProduct(int productId) async {
    try {
      final dbStock = await _databaseProvider.getStockByProduct(productId);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByProductUuid(String productUuid) async {
    try {
      final dbStock = await _databaseProvider.getStockByProductUuid(productUuid);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByVariant(int variantId) async {
    try {
      final dbStock = await _databaseProvider.getStockByVariant(variantId);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByIngredient(int ingredientId) async {
    try {
      final dbStock = await _databaseProvider.getStockByIngredient(ingredientId);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> getStockByIngredientUuid(String ingredientUuid) async {
    try {
      final dbStock = await _databaseProvider.getStockByIngredientUuid(ingredientUuid);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> createStock(Stock stock) async {
    try {
      final dbStock = toDbStock(stock);
      final id = await _databaseProvider.createStock(dbStock);
      final createdStock = stock.copyWith(id: id);
      return Right(createdStock);
    } catch (e) {
      return Left(Failure(message: 'Failed to create stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> updateStock(Stock stock) async {
    try {
      final dbStock = toDbStock(stock);
      final success = await _databaseProvider.updateStock(dbStock);
      if (!success) {
        return Left(Failure(message: 'Failed to update stock'));
      }
      return Right(stock);
    } catch (e) {
      return Left(Failure(message: 'Failed to update stock: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStock(int id) async {
    try {
      await _databaseProvider.deleteStock(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete stock: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStockByUuid(String uuid) async {
    try {
      await _databaseProvider.deleteStockByUuid(uuid);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete stock: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getAllStockMovements() async {
    try {
      final dbMovements = await _databaseProvider.getAllStockMovements();
      final movements = dbMovements.map((dbMov) => toDomainStockMovement(dbMov)).toList();
      return Right(movements);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock movements: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByProduct(int productId) async {
    try {
      final dbMovements = await _databaseProvider.getStockMovementsByProduct(productId);
      final movements = dbMovements.map((dbMov) => toDomainStockMovement(dbMov)).toList();
      return Right(movements);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock movements: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByIngredient(int ingredientId) async {
    try {
      final dbMovements = await _databaseProvider.getStockMovementsByIngredient(ingredientId);
      final movements = dbMovements.map((dbMov) => toDomainStockMovement(dbMov)).toList();
      return Right(movements);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock movements: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final dbMovements = await _databaseProvider.getStockMovementsByDateRange(startDate, endDate);
      final movements = dbMovements.map((dbMov) => toDomainStockMovement(dbMov)).toList();
      return Right(movements);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock movements: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByType(String movementType) async {
    try {
      final dbMovements = await _databaseProvider.getStockMovementsByType(movementType);
      final movements = dbMovements.map((dbMov) => toDomainStockMovement(dbMov)).toList();
      return Right(movements);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock movements: $e'));
    }
  }

  @override
  Future<Either<Failure, StockMovement>> createStockMovement(StockMovement movement) async {
    try {
      final dbMovement = toDbStockMovement(movement);
      final id = await _databaseProvider.createStockMovement(dbMovement);
      final createdMovement = movement.copyWith(id: id);
      return Right(createdMovement);
    } catch (e) {
      return Left(Failure(message: 'Failed to create stock movement: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createBulkStockMovements(List<StockMovement> movements) async {
    try {
      final dbMovements = movements.map((mov) => toDbStockMovement(mov)).toList();
      await _databaseProvider.createBulkStockMovements(dbMovements);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to create bulk stock movements: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> adjustStock(
    int stockId,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  ) async {
    try {
      final dbStock = await _databaseProvider.adjustStock(stockId, newQuantity, reason, referenceId, referenceType);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to adjust stock: $e'));
    }
  }

  @override
  Future<Either<Failure, Stock>> adjustStockByUuid(
    String stockUuid,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  ) async {
    try {
      final dbStock = await _databaseProvider.adjustStockByUuid(stockUuid, newQuantity, reason, referenceId, referenceType);
      if (dbStock == null) {
        return Left(Failure(message: 'Stock not found'));
      }
      return Right(toDomainStock(dbStock));
    } catch (e) {
      return Left(Failure(message: 'Failed to adjust stock: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Stock>>> getStocksForOpname() async {
    try {
      final dbStocks = await _databaseProvider.getStocksForOpname();
      final stocks = dbStocks.map((dbStock) => toDomainStock(dbStock)).toList();
      return Right(stocks);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stocks for opname: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> processStockOpname(
    List<Map<String, dynamic>> opnameData,
    String reason,
  ) async {
    try {
      await _databaseProvider.processStockOpname(opnameData, reason);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to process stock opname: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockAlerts() async {
    try {
      final alerts = await _databaseProvider.getStockAlerts();
      return Right(alerts);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock alerts: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLowStockAlerts() async {
    try {
      final hasAlerts = await _databaseProvider.checkLowStockAlerts();
      return Right(hasAlerts);
    } catch (e) {
      return Left(Failure(message: 'Failed to check low stock alerts: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMinStockLevel(
    int itemId,
    int minLevel, {
    bool isIngredient = false,
  }) async {
    try {
      await _databaseProvider.updateMinStockLevel(itemId, minLevel, isIngredient: isIngredient);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to update min stock level: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStockReconciliation(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final reconciliation = await _databaseProvider.getStockReconciliation(startDate, endDate);
      return Right(reconciliation);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock reconciliation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockDiscrepancies(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final discrepancies = await _databaseProvider.getStockDiscrepancies(startDate, endDate);
      return Right(discrepancies);
    } catch (e) {
      return Left(Failure(message: 'Failed to get stock discrepancies: $e'));
    }
  }
}
