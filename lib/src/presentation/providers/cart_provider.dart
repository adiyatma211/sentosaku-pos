import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/failure.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/services/transaction_service_stub.dart';
import 'domain_providers.dart';

// Provider for CartNotifier
final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart>>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final transactionService = ref.watch(transactionServiceProvider);
  return CartNotifier(cartRepository, transactionService);
});

class CartNotifier extends StateNotifier<AsyncValue<Cart>> {
  final CartRepository _cartRepository;
  final TransactionServiceStub? _transactionService;
  int _currentCartId = 1; // Default cart ID

  CartNotifier(this._cartRepository, this._transactionService)
      : super(const AsyncValue.loading());

  Future<void> loadCart() async {
    state = const AsyncValue.loading();
    final result = await _cartRepository.getCurrentCart();
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart? cart) {
        if (cart != null) {
          _currentCartId = cart.id;
          state = AsyncValue.data(cart);
        } else {
          // Create a new cart if none exists
          createCart();
        }
      },
    );
  }

  Future<void> createCart() async {
    final result = await _cartRepository.createCart();
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) {
        _currentCartId = cart.id;
        state = AsyncValue.data(cart);
      },
    );
  }

  Future<void> addToCart({
    required int productId,
    required int quantity,
    int? variantId,
    String? notes,
  }) async {
    // Ensure we have a cart
    if (state.value == null) {
      await createCart();
    }

    final result = await _cartRepository.addToCart(
      cartId: _currentCartId,
      productId: productId,
      quantity: quantity,
      variantId: variantId,
      notes: notes,
    );
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) => state = AsyncValue.data(cart),
    );
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final result = await _cartRepository.updateCartItemQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) => state = AsyncValue.data(cart),
    );
  }

  Future<void> removeFromCart(int cartItemId) async {
    final result = await _cartRepository.removeFromCart(cartItemId);
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) => state = AsyncValue.data(cart),
    );
  }

  Future<void> clearCart() async {
    final result = await _cartRepository.clearCart(_currentCartId);
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) => state = AsyncValue.data(cart),
    );
  }

  Future<void> applyDiscount(String discountCode) async {
    final result = await _cartRepository.applyDiscount(_currentCartId, discountCode);
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) => state = AsyncValue.data(cart),
    );
  }

  Future<void> removeDiscount() async {
    final result = await _cartRepository.removeDiscount(_currentCartId);
    
    result.fold(
      (Failure error) => state = AsyncValue.error(error, StackTrace.current),
      (Cart cart) => state = AsyncValue.data(cart),
    );
  }

  Future<void> checkout() async {
    if (_transactionService == null) {
      state = AsyncValue.error(
        Failure(message: 'Transaction service not available'),
        StackTrace.current,
      );
      return;
    }

    final currentCart = state.value;
    if (currentCart == null || currentCart.items.isEmpty) {
      state = AsyncValue.error(
        Failure(message: 'Cart is empty'),
        StackTrace.current,
      );
      return;
    }

    try {
      final result = await _transactionService.processTransaction(
        cartId: _currentCartId,
        paymentMethod: 'cash',
        paidAmount: currentCart.totalAmount.round(),
      );
      
      result.fold(
        (Failure error) => state = AsyncValue.error(error, StackTrace.current),
        (order) async {
          // Clear cart after successful checkout
          await clearCart();
          state = AsyncValue.data(currentCart.copyWith(
            updatedAt: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      state = AsyncValue.error(
        Failure(message: e.toString()),
        StackTrace.current,
      );
    }
  }
}