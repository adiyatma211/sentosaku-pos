import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';

@freezed
class Stock with _$Stock {
  const factory Stock({
    required int id,
    required String uuid,
    int? productId,
    int? variantId,
    int? ingredientId,
    required int quantity,
    @Default(0) int reservedQuantity,
    @Default(0) int availableQuantity,
    required DateTime lastUpdated,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
    @Default('pending') String syncStatus,
  }) = _Stock;
}

@freezed
class StockMovement with _$StockMovement {
  const factory StockMovement({
    required int id,
    required String uuid,
    int? productId,
    int? variantId,
    int? ingredientId,
    required String movementType, // 'in', 'out', 'adjustment', 'sale', 'return'
    required int quantity,
    required int previousQuantity,
    required int newQuantity,
    String? reason,
    String? referenceId, // Order ID, adjustment ID, etc.
    String? referenceType, // 'order', 'adjustment', etc.
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
    @Default('pending') String syncStatus,
  }) = _StockMovement;
}

@freezed
class StockRequest with _$StockRequest {
  const factory StockRequest({
    required int? productId,
    required int? variantId,
    required int? ingredientId,
    required int quantity,
    required String reason,
    String? referenceId,
    String? referenceType,
  }) = _StockRequest;
}

@freezed
class StockMovementRequest with _$StockMovementRequest {
  const factory StockMovementRequest({
    required int? productId,
    required int? variantId,
    required int? ingredientId,
    required String movementType,
    required int quantity,
    required int previousQuantity,
    required int newQuantity,
    required String reason,
    String? referenceId,
    String? referenceType,
  }) = _StockMovementRequest;
}