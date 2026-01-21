import 'package:dartz/dartz.dart';
import '../entities/ingredient.dart';
import '../entities/product.dart';
import '../entities/stock.dart';
import '../entities/failure.dart';

abstract class InventoryRepositoryInterface {
  // Ingredient operations
  Future<Either<Failure, List<Ingredient>>> getAllIngredients();
  Future<Either<Failure, Ingredient>> getIngredientById(int id);
  Future<Either<Failure, Ingredient>> getIngredientByUuid(String uuid);
  Future<Either<Failure, List<Ingredient>>> getActiveIngredients();
  Future<Either<Failure, List<Ingredient>>> getLowStockIngredients();
  Future<Either<Failure, Ingredient>> createIngredient(Ingredient ingredient);
  Future<Either<Failure, Ingredient>> updateIngredient(Ingredient ingredient);
  Future<Either<Failure, void>> deleteIngredient(int id);
  Future<Either<Failure, void>> deleteIngredientByUuid(String uuid);

  // Product operations with inventory tracking
  Future<Either<Failure, List<Product>>> getAllProductsWithInventory();
  Future<Either<Failure, Product>> getProductWithInventory(int id);
  Future<Either<Failure, Product>> getProductWithInventoryByUuid(String uuid);
  Future<Either<Failure, List<Product>>> getLowStockProducts();
  Future<Either<Failure, Product>> updateProductInventory(int productId, int quantity);
  Future<Either<Failure, Product>> updateProductInventoryByUuid(String productUuid, int quantity);

  // Stock operations
  Future<Either<Failure, List<Stock>>> getAllStocks();
  Future<Either<Failure, Stock>> getStockById(int id);
  Future<Either<Failure, Stock>> getStockByUuid(String uuid);
  Future<Either<Failure, Stock>> getStockByProduct(int productId);
  Future<Either<Failure, Stock>> getStockByProductUuid(String productUuid);
  Future<Either<Failure, Stock>> getStockByVariant(int variantId);
  Future<Either<Failure, Stock>> getStockByIngredient(int ingredientId);
  Future<Either<Failure, Stock>> getStockByIngredientUuid(String ingredientUuid);
  Future<Either<Failure, Stock>> createStock(Stock stock);
  Future<Either<Failure, Stock>> updateStock(Stock stock);
  Future<Either<Failure, void>> deleteStock(int id);
  Future<Either<Failure, void>> deleteStockByUuid(String uuid);

  // Stock movement operations
  Future<Either<Failure, List<StockMovement>>> getAllStockMovements();
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByProduct(int productId);
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByIngredient(int ingredientId);
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<StockMovement>>> getStockMovementsByType(String movementType);
  Future<Either<Failure, StockMovement>> createStockMovement(StockMovement movement);
  Future<Either<Failure, void>> createBulkStockMovements(List<StockMovement> movements);

  // Stock adjustment operations
  Future<Either<Failure, Stock>> adjustStock(
    int stockId,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  );
  Future<Either<Failure, Stock>> adjustStockByUuid(
    String stockUuid,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  );

  // Stock opname (physical counting) operations
  Future<Either<Failure, List<Stock>>> getStocksForOpname();
  Future<Either<Failure, void>> processStockOpname(
    List<Map<String, dynamic>> opnameData,
    String reason,
  );

  // Stock alert operations
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockAlerts();
  Future<Either<Failure, bool>> checkLowStockAlerts();
  Future<Either<Failure, void>> updateMinStockLevel(int itemId, int minLevel, {bool isIngredient = false});

  // Stock reconciliation operations
  Future<Either<Failure, Map<String, dynamic>>> getStockReconciliation(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getStockDiscrepancies(
    DateTime startDate,
    DateTime endDate,
  );
}