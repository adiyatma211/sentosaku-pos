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
    print('DEBUG PROVIDER: Loading cart...');
    state = const AsyncValue.loading();
    final result = await _cartRepository.getCurrentCart();
    
    result.fold(
      (Failure error) {
        print('DEBUG PROVIDER: Error loading cart - ${error.message}');
        state = AsyncValue.error(error, StackTrace.current);
      },
      (Cart? cart) async {
        if (cart != null) {
          _currentCartId = cart.id;
          print('DEBUG PROVIDER: Cart loaded - ID: $_currentCartId, Items: ${cart.items.length}');
          state = AsyncValue.data(cart);
        } else {
          // Create a new cart if none exists
          print('DEBUG PROVIDER: No cart found, creating new cart...');
          await createCart();
        }
      },
    );
  }

  Future<void> createCart() async {
    print('DEBUG PROVIDER: Creating new cart...');
    final result = await _cartRepository.createCart();
    result.fold(
      (Failure error) {
        print('DEBUG PROVIDER: Error creating cart - ${error.message}');
        state = AsyncValue.error(error, StackTrace.current);
      },
      (Cart cart) {
        _currentCartId = cart.id;
        print('DEBUG PROVIDER: Cart created - ID: $_currentCartId');
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
    print('DEBUG PROVIDER: addToCart START - Product ID: $productId, Quantity: $quantity, Variant ID: $variantId, Notes: $notes');
    print('DEBUG PROVIDER: Current state before addToCart - isLoading: ${state.isLoading}, hasValue: ${state.value != null}');
    if (state.value != null) {
      print('DEBUG PROVIDER: Current cart ID: ${state.value!.id}, Items count: ${state.value!.items.length}');
    }
    
    // Ensure we have a cart and get the correct cart ID
    if (state.value == null) {
      print('DEBUG PROVIDER: Cart state is null, creating new cart...');
      await createCart();
    } else {
      // Update current cart ID from the loaded cart
      _currentCartId = state.value!.id;
      print('DEBUG PROVIDER: Cart state exists - ID: $_currentCartId, Items: ${state.value!.items.length}');
    }

    print('DEBUG PROVIDER: Adding to cart - Cart ID: $_currentCartId, Product ID: $productId, Quantity: $quantity');

    final result = await _cartRepository.addToCart(
      cartId: _currentCartId,
      productId: productId,
      quantity: quantity,
      variantId: variantId,
      notes: notes,
    );
    
    print('DEBUG PROVIDER: addToCart repository call completed');
    
    result.fold(
      (Failure error) {
        print('DEBUG PROVIDER: Error adding to cart: ${error.message}');
        state = AsyncValue.error(error, StackTrace.current);
      },
      (Cart cart) {
        print('DEBUG PROVIDER: Cart updated successfully - ID: ${cart.id}, Items: ${cart.items.length}');
        print('DEBUG PROVIDER: Updating state with new cart data...');
        // Update state with the returned cart that includes the new item
        state = AsyncValue.data(cart);
        print('DEBUG PROVIDER: State updated - New state hasValue: ${state.value != null}, Items count: ${state.value?.items.length ?? 0}');
      },
    );
    print('DEBUG PROVIDER: addToCart END');
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