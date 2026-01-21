import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';

part 'order.freezed.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    required String uuid,
    required String orderNumber,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    required int subtotal,
    required int taxAmount,
    required int discountAmount,
    required int totalAmount,
    required int paidAmount,
    required int changeAmount,
    required String status, // 'pending', 'paid', 'cancelled', 'refunded'
    required String paymentStatus, // 'unpaid', 'partial', 'paid', 'refunded'
    String? paymentMethod, // 'cash', 'card', 'transfer', 'ewallet'
    String? notes,
    required DateTime orderDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
    // Additional fields for POS
    List<OrderItem>? items,
    List<Payment>? payments,
  }) = _Order;
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int id,
    required String uuid,
    required int orderId,
    required int productId,
    int? variantId,
    required String productName,
    String? variantName,
    required int quantity,
    required int unitPrice,
    required int totalPrice,
    required int discountAmount,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
    // Additional fields for POS
    Product? product,
    Variant? variant,
    // Cart item specific fields
    Map<String, dynamic>? customizations, // For size, sugar level, ice amount, toppings
  }) = _OrderItem;
}

@freezed
class Payment with _$Payment {
  const factory Payment({
    required int id,
    required String uuid,
    required int orderId,
    required String paymentMethod, // 'cash', 'card', 'transfer', 'ewallet'
    required int amount,
    String? reference, // Card number, transfer reference, etc.
    required String status, // 'pending', 'completed', 'failed', 'refunded'
    String? gateway, // Payment gateway used
    String? gatewayTransactionId,
    required DateTime paymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
  }) = _Payment;
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    required List<CartItem> items,
    required int subtotal,
    required int taxAmount,
    required int discountAmount,
    required int totalAmount,
    String? customerName,
    String? customerPhone,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Cart;
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required int productId,
    int? variantId,
    required String productName,
    String? variantName,
    required int quantity,
    required int unitPrice,
    required int totalPrice,
    required int discountAmount,
    String? notes,
    Map<String, dynamic>? customizations, // For size, sugar level, ice amount, toppings
    Product? product,
    Variant? variant,
  }) = _CartItem;
}

@freezed
class CartItemCustomization with _$CartItemCustomization {
  const factory CartItemCustomization({
    required String type, // 'size', 'sugar', 'ice', 'topping'
    required String name,
    required String value,
    required int priceAdjustment,
  }) = _CartItemCustomization;
}

// Transaction request/response models
@freezed
class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required List<CartItem> items,
    required int subtotal,
    required int taxAmount,
    required int discountAmount,
    required int totalAmount,
    required List<PaymentRequest> payments,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    String? notes,
  }) = _TransactionRequest;
}

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String paymentMethod,
    required int amount,
    String? reference,
  }) = _PaymentRequest;
}

@freezed
class TransactionResult with _$TransactionResult {
  const factory TransactionResult({
    required bool success,
    required Order? order,
    required String? error,
    required String? errorCode,
  }) = _TransactionResult;
}