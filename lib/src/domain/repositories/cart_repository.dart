import 'package:dartz/dartz.dart';

import '../entities/cart.dart';
import '../entities/failure.dart';

abstract class CartRepository {
  /// Get the current active cart
  Future<Either<Failure, Cart?>> getCurrentCart();
  
  /// Create a new cart
  Future<Either<Failure, Cart>> createCart();
  
  /// Add an item to the cart
  Future<Either<Failure, Cart>> addToCart({
    required int cartId,
    required int productId,
    required int quantity,
    int? variantId,
    String? notes,
  });
  
  /// Update the quantity of a cart item
  Future<Either<Failure, Cart>> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  });
  
  /// Remove an item from the cart
  Future<Either<Failure, Cart>> removeFromCart(int cartItemId);
  
  /// Clear all items from the cart
  Future<Either<Failure, Cart>> clearCart(int cartId);
  
  /// Apply a discount to the cart
  Future<Either<Failure, Cart>> applyDiscount(int cartId, String discountCode);
  
  /// Remove discount from the cart
  Future<Either<Failure, Cart>> removeDiscount(int cartId);
  
  /// Get a cart by ID
  Future<Either<Failure, Cart>> getCartById(int cartId);
  
  /// Get carts within a date range
  Future<Either<Failure, List<Cart>>> getCartsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Delete a cart
  Future<Either<Failure, void>> deleteCart(int cartId);
}