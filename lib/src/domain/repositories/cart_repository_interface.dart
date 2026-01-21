import '../entities/order.dart';

abstract class CartRepositoryInterface {
  // Cart operations
  Future<Cart> getCart(String cartId);
  Future<Cart> createCart();
  Future<Cart> updateCart(Cart cart);
  Future<bool> clearCart(String cartId);
  Future<bool> deleteCart(String cartId);
  
  // Cart item operations
  Future<Cart> addItemToCart(String cartId, CartItem item);
  Future<Cart> removeItemFromCart(String cartId, String itemId);
  Future<Cart> updateCartItemQuantity(String cartId, String itemId, int quantity);
  Future<Cart> updateCartItemNotes(String cartId, String itemId, String? notes);
  Future<Cart> updateCartItemCustomizations(String cartId, String itemId, Map<String, dynamic>? customizations);
  
  // Cart calculations
  Future<int> calculateCartSubtotal(String cartId);
  Future<int> calculateCartTax(String cartId);
  Future<int> calculateCartDiscount(String cartId);
  Future<int> calculateCartTotal(String cartId);
  
  // Cart validation
  Future<bool> validateCart(String cartId);
  Future<List<String>> getCartValidationErrors(String cartId);
  
  // Cart customer operations
  Future<Cart> updateCartCustomer(String cartId, String? customerName, String? customerPhone);
  Future<Cart> updateCartNotes(String cartId, String? notes);
  
  // Cart to order conversion
  Future<TransactionRequest> convertCartToTransaction(String cartId, List<PaymentRequest> payments);
}