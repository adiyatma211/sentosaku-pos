import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/failure.dart';
import '../../domain/entities/order.dart' as order_entity;
import '../../domain/repositories/cart_repository.dart';
import '../../domain/services/transaction_service_stub.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/datasources/local/app_database.dart' as db;
import 'domain_providers.dart';

// Provider for CartNotifier
final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart>>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final orderRepository = ref.watch(orderRepositoryProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final transactionService = ref.watch(transactionServiceProvider);
  return CartNotifier(cartRepository, orderRepository, paymentRepository, transactionService);
});

class CartNotifier extends StateNotifier<AsyncValue<Cart>> {
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  final PaymentRepository _paymentRepository;
  final TransactionServiceStub? _transactionService;
  int _currentCartId = 1; // Default cart ID

  CartNotifier(this._cartRepository, this._orderRepository, this._paymentRepository, this._transactionService)
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
    print('DEBUG CHECKOUT: checkout() START');
    print('DEBUG CHECKOUT: Current cart ID: $_currentCartId');
    
    // Check if state is in loading or error state
    print('DEBUG CHECKOUT: State isLoading: ${state.isLoading}, hasError: ${state.hasError}, hasValue: ${state.hasValue}');
    
    final currentCart = state.value;
    print('DEBUG CHECKOUT: Current cart is null: ${currentCart == null}');
    if (currentCart != null) {
      print('DEBUG CHECKOUT: Cart ID: ${currentCart.id}, Cart items count: ${currentCart.items.length}');
    }
    
    if (currentCart == null || currentCart.items.isEmpty) {
      print('DEBUG CHECKOUT: ERROR - Cart is empty or null');
      state = AsyncValue.error(
        Failure(message: 'Cart is empty'),
        StackTrace.current,
      );
      return;
    }

    try {
      // Generate UUID and order number
      final orderUuid = const Uuid().v4();
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final paidAmount = currentCart.totalAmount.round();
      
      print('DEBUG CHECKOUT: Creating order with UUID: $orderUuid, Order Number: $orderNumber, Paid Amount: $paidAmount');
      
      // Create order
      final order = order_entity.Order(
        id: 0, // Will be set by database
        uuid: orderUuid,
        orderNumber: orderNumber,
        customerName: null,
        customerPhone: null,
        customerEmail: null,
        customerAddress: null,
        subtotal: currentCart.subtotal.round(),
        taxAmount: currentCart.taxAmount.round(),
        discountAmount: currentCart.discountAmount.round(),
        totalAmount: currentCart.totalAmount.round(),
        paidAmount: 0, // Will be updated after payments
        changeAmount: 0, // Will be calculated after payments
        status: 'paid',
        paymentStatus: 'paid',
        paymentMethod: 'cash',
        notes: null,
        orderDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
        syncStatus: 'pending',
        items: [], // Will be populated
        payments: null, // Will be populated
      );
      
      print('DEBUG CHECKOUT: Calling createOrder...');
      final createdOrder = await _orderRepository.createOrder(order);
      print('DEBUG CHECKOUT: Order created in database - ID: ${createdOrder.id}, UUID: ${createdOrder.uuid}, Order Number: ${createdOrder.orderNumber}');
      
      // Verify createdOrder is not null and has a valid ID
      if (createdOrder.id == 0) {
        print('DEBUG CHECKOUT: ERROR - Created order has invalid ID: ${createdOrder.id}');
        throw Exception('Created order has invalid ID');
      }
      
      // Create order items from cart items
      print('DEBUG CHECKOUT: Creating order items...');
      for (final cartItem in currentCart.items) {
        print('DEBUG CHECKOUT: Processing cart item - Product ID: ${cartItem.productId}, Quantity: ${cartItem.quantity}');
        
        final orderItem = order_entity.OrderItem(
          id: 0, // Will be set by database
          uuid: const Uuid().v4(),
          orderId: createdOrder.id,
          productId: cartItem.productId,
          variantId: cartItem.variantId,
          productName: '', // Will be filled when needed
          variantName: null,
          quantity: cartItem.quantity,
          unitPrice: cartItem.unitPrice.round(),
          totalPrice: (cartItem.quantity * cartItem.unitPrice).round(),
          discountAmount: 0,
          notes: cartItem.notes,
          customizations: const {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
          syncStatus: 'pending',
        );
        
        await _orderRepository.createOrderItem(orderItem);
        print('DEBUG CHECKOUT: Order item created - Product ID: ${cartItem.productId}, Quantity: ${cartItem.quantity}');
      }
      
      // Create payment using PaymentRepository
      print('DEBUG CHECKOUT: Creating payment...');
      final payment = order_entity.Payment(
        id: 0, // Will be set by database
        uuid: const Uuid().v4(),
        orderId: createdOrder.id,
        paymentMethod: 'cash',
        amount: paidAmount,
        reference: null,
        status: 'completed',
        gateway: null,
        gatewayTransactionId: null,
        paymentDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
        syncStatus: 'pending',
      );
      
      await _paymentRepository.createPayment(payment);
      print('DEBUG CHECKOUT: Payment created - Amount: $paidAmount');
      
      // Update order with payment information
      final changeAmount = paidAmount - currentCart.totalAmount.round();
      print('DEBUG CHECKOUT: Calculating change amount: $changeAmount');
      
      print('DEBUG CHECKOUT: Created order state before copyWith:');
      print('DEBUG CHECKOUT: - ID: ${createdOrder.id}');
      print('DEBUG CHECKOUT: - UUID: ${createdOrder.uuid}');
      print('DEBUG CHECKOUT: - Order Number: ${createdOrder.orderNumber}');
      print('DEBUG CHECKOUT: - Paid Amount: ${createdOrder.paidAmount}');
      print('DEBUG CHECKOUT: - Change Amount: ${createdOrder.changeAmount}');
      print('DEBUG CHECKOUT: - Status: ${createdOrder.status}');
      print('DEBUG CHECKOUT: - Payment Status: ${createdOrder.paymentStatus}');
      print('DEBUG CHECKOUT: - Payment Method: ${createdOrder.paymentMethod}');
      
      print('DEBUG CHECKOUT: Calling copyWith to create updatedOrder...');
      final updatedOrder = createdOrder.copyWith(
        paidAmount: paidAmount,
        changeAmount: changeAmount > 0 ? changeAmount : 0,
        status: 'paid',
        paymentStatus: 'paid',
        paymentMethod: 'cash',
      );
      
      print('DEBUG CHECKOUT: Updated order state after copyWith:');
      print('DEBUG CHECKOUT: - ID: ${updatedOrder.id}');
      print('DEBUG CHECKOUT: - UUID: ${updatedOrder.uuid}');
      print('DEBUG CHECKOUT: - Order Number: ${updatedOrder.orderNumber}');
      print('DEBUG CHECKOUT: - Paid Amount: ${updatedOrder.paidAmount}');
      print('DEBUG CHECKOUT: - Change Amount: ${updatedOrder.changeAmount}');
      print('DEBUG CHECKOUT: - Status: ${updatedOrder.status}');
      print('DEBUG CHECKOUT: - Payment Status: ${updatedOrder.paymentStatus}');
      print('DEBUG CHECKOUT: - Payment Method: ${updatedOrder.paymentMethod}');
      
      print('DEBUG CHECKOUT: Updating order with payment info...');
      await _orderRepository.updateOrder(updatedOrder);
      print('DEBUG CHECKOUT: Order updated with payment info - Paid: $paidAmount, Change: $changeAmount');
      
      print('DEBUG CHECKOUT: Clearing cart...');
      // Clear cart after successful checkout
      await clearCart();
      
      // Create a new empty cart state instead of using copyWith on the old cart
      print('DEBUG CHECKOUT: Creating new empty cart state...');
      final newCart = currentCart.copyWith(
        items: [],
        subtotal: 0.0,
        taxAmount: 0.0,
        discountAmount: 0.0,
        totalAmount: 0.0,
        updatedAt: DateTime.now(),
      );
      
      state = AsyncValue.data(newCart);
      print('DEBUG CHECKOUT: Cart cleared and state updated');
    } catch (e) {
      print('DEBUG CHECKOUT: EXCEPTION - ${e.toString()}');
      print('DEBUG CHECKOUT: Stack trace: ${StackTrace.current}');
      state = AsyncValue.error(
        Failure(message: e.toString()),
        StackTrace.current,
      );
    }
    print('DEBUG CHECKOUT: checkout() END');
  }
}
