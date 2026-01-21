import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    required int id,
    int? customerId,
    @Default(0.0) double subtotal,
    @Default(0.0) double taxAmount,
    @Default(0.0) double discountAmount,
    @Default(0.0) double totalAmount,
    @Default('active') String status,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<CartItem> items,
  }) = _Cart;
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required int id,
    required int cartId,
    required int productId,
    int? variantId,
    @Default(1) int quantity,
    @Default(0.0) double unitPrice,
    @Default(0.0) double totalPrice,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CartItem;
}

@freezed
class CartRequest with _$CartRequest {
  const factory CartRequest({
    int? customerId,
    String? notes,
  }) = _CartRequest;
}

@freezed
class CartItemRequest with _$CartItemRequest {
  const factory CartItemRequest({
    required int productId,
    int? variantId,
    @Default(1) int quantity,
    String? notes,
  }) = _CartItemRequest;
}