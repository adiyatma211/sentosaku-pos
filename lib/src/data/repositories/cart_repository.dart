import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/entities/failure.dart';
import '../datasources/local/app_database.dart' as db;
import '../datasources/local/dao/cart_dao.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartDao _cartDao;

  CartRepositoryImpl(this._cartDao);

  @override
  Future<Either<Failure, Cart?>> getCurrentCart() async {
    try {
      final cartData = await _cartDao.getCurrentCart();
      if (cartData == null) return const Right(null);
      
      final cartItemsData = await _cartDao.getCartItems(cartData.id);
      final items = cartItemsData.map(_mapCartItemToEntity).toList();
      
      return Right(_mapCartToEntity(cartData, items));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> createCart() async {
    try {
      final cartData = await _cartDao.createCart();
      return Right(_mapCartToEntity(cartData, []));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart({
    required int cartId,
    required int productId,
    required int quantity,
    int? variantId,
    String? notes,
  }) async {
    try {
      // Get product details
      final product = await _cartDao.getProductById(productId);
      if (product == null) {
        return const Left(Failure(message: 'Product not found'));
      }
      
      // Get variant details if provided
      db.Variant? variant;
      if (variantId != null) {
        variant = await _cartDao.getVariantById(variantId);
        if (variant == null) {
          return const Left(Failure(message: 'Product variant not found'));
        }
      }
      
      // Check if item already exists in cart
      final existingItem = await _cartDao.getCartItemByProductVariant(
        cartId, productId, variantId,
      );
      
      db.CartItem cartItemData;
      if (existingItem != null) {
        // Update existing item quantity
        final newQuantity = existingItem.quantity + quantity;
        cartItemData = await _cartDao.updateCartItemQuantity(
          existingItem.id, newQuantity,
        );
      } else {
        // Add new item to cart
        cartItemData = await _cartDao.addCartItem(
          db.CartItemsCompanion.insert(
            uuid: DateTime.now().millisecondsSinceEpoch.toString(),
            cartId: cartId,
            productId: productId,
            quantity: Value(quantity),
            variantId: variantId != null ? Value(variantId) : const Value.absent(),
            notes: notes != null ? Value(notes) : const Value.absent(),
            unitPrice: Value((variant?.price ?? product.price).toDouble()),
            totalPrice: Value(((variant?.price ?? product.price) * quantity).toDouble()),
          ),
        );
      }
      
      // Get updated cart
      return await getCartById(cartId);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      if (quantity <= 0) {
        // Remove item if quantity is 0 or negative
        await _cartDao.removeCartItem(cartItemId);
      } else {
        // Update quantity
        await _cartDao.updateCartItemQuantity(cartItemId, quantity);
      }
      
      // Get cart ID from the item
      final cartItem = await _cartDao.getCartItemById(cartItemId);
      if (cartItem == null) {
        return const Left(Failure(message: 'Cart item not found'));
      }
      
      return await getCartById(cartItem.cartId);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart(int cartItemId) async {
    try {
      final cartItem = await _cartDao.getCartItemById(cartItemId);
      if (cartItem == null) {
        return const Left(Failure(message: 'Cart item not found'));
      }
      
      await _cartDao.removeCartItem(cartItemId);
      
      return await getCartById(cartItem.cartId);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> clearCart(int cartId) async {
    try {
      await _cartDao.clearCart(cartId);
      return await getCartById(cartId);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> applyDiscount(int cartId, String discountCode) async {
    try {
      // In a real implementation, this would validate the discount code
      // and apply the appropriate discount
      final discountAmount = 0.0; // Calculate based on discount code
      
      await _cartDao.updateCartDiscount(cartId, discountCode, discountAmount);
      
      return await getCartById(cartId);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeDiscount(int cartId) async {
    try {
      await _cartDao.updateCartDiscount(cartId, null, 0.0);
      
      return await getCartById(cartId);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> getCartById(int cartId) async {
    try {
      final cartData = await _cartDao.getCartById(cartId);
      if (cartData == null) {
        return const Left(Failure(message: 'Cart not found'));
      }
      
      final cartItemsData = await _cartDao.getCartItems(cartId);
      final items = cartItemsData.map(_mapCartItemToEntity).toList();
      
      return Right(_mapCartToEntity(cartData, items));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Cart>>> getCartsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final cartsData = await _cartDao.getCartsByDateRange(startDate, endDate);
      
      final List<Cart> carts = [];
      for (final cartData in cartsData) {
        final cartItemsData = await _cartDao.getCartItems(cartData.id);
        final items = cartItemsData.map(_mapCartItemToEntity).toList();
        carts.add(_mapCartToEntity(cartData, items));
      }
      
      return Right(carts);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCart(int cartId) async {
    try {
      await _cartDao.deleteCart(cartId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  // Helper methods to map between data and domain entities

  Cart _mapCartToEntity(db.Cart data, List<CartItem> items) {
    return Cart(
      id: data.id,
      customerId: data.customerId,
      subtotal: data.subtotal,
      taxAmount: data.taxAmount,
      discountAmount: data.discountAmount,
      totalAmount: data.totalAmount,
      status: data.status,
      notes: data.notes,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      items: items,
    );
  }

  CartItem _mapCartItemToEntity(db.CartItem data) {
    return CartItem(
      id: data.id,
      cartId: data.cartId,
      productId: data.productId,
      variantId: data.variantId,
      quantity: data.quantity,
      unitPrice: data.unitPrice,
      totalPrice: data.totalPrice,
      notes: data.notes,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}