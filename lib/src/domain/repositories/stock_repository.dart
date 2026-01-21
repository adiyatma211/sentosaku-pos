import '../entities/stock.dart';

abstract class StockRepository {
  /// Get current stock for a product, variant, or ingredient
  Future<Stock> getCurrentStock(
    int? productId,
    int? variantId,
    int? ingredientId,
  );

  /// Update stock quantity
  Future<void> updateStock(StockRequest request);

  /// Create a stock movement record
  Future<void> createStockMovement(StockMovementRequest request);
}