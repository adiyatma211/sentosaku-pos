import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../entities/order.dart' as order_entity;
import '../entities/product.dart' as product_entity;
import '../entities/stock.dart';
import '../repositories/cart_repository.dart';
import '../repositories/order_repository_interface.dart';
import '../repositories/payment_repository_interface.dart';
import '../repositories/product_repository_interface.dart';
import '../repositories/stock_repository.dart';
import '../../data/datasources/local/app_database.dart';
import 'transaction_service_interface.dart';

@LazySingleton(as: TransactionService)
class TransactionServiceImpl implements TransactionService {
  final AppDatabase _database;
  final CartRepository _cartRepository;
  final OrderRepositoryInterface _orderRepository;
  final PaymentRepositoryInterface _paymentRepository;
  final ProductRepositoryInterface _productRepository;
  final StockRepository _stockRepository;

  TransactionServiceImpl(
    this._database,
    this._cartRepository,
    this._orderRepository,
    this._paymentRepository,
    this._productRepository,
    this._stockRepository,
  );

  @override
  Future<order_entity.Order> processTransaction({
    required int cartId,
    required String paymentMethod,
    required double paidAmount,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    String? notes,
  }) async {
    // Generate UUID for the transaction
    final orderUuid = const Uuid().v4();
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    
    // Get cart details
    final cartResult = await _cartRepository.getCartById(cartId);
    final cart = cartResult.fold((error) => throw Exception(error.message), (cart) => cart);
    
    // Start transaction
    return _database.transaction(() async {
      // Create order
      final order = await _orderRepository.createOrder(
        order_entity.Order(
          id: 0, // Will be set by database
          uuid: orderUuid,
          orderNumber: orderNumber,
          customerName: customerName,
          customerPhone: customerPhone,
          customerEmail: customerEmail,
          customerAddress: customerAddress,
          subtotal: cart.totalAmount.round(),
          taxAmount: 0,
          discountAmount: 0,
          totalAmount: cart.totalAmount.round(),
          paidAmount: 0,
          changeAmount: 0,
          status: 'pending',
          paymentStatus: 'unpaid',
          paymentMethod: paymentMethod,
          notes: notes,
          orderDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
          syncStatus: 'pending',
        ),
      );
      
      // Create order items from cart items
      for (final cartItem in cart.items) {
        // Get product details
        final product = await _productRepository.getProductById(cartItem.productId);
        if (product == null) {
          throw Exception('Product not found: ${cartItem.productId}');
        }
        
        // Get variant details if provided
        product_entity.Variant? variant;
        if (cartItem.variantId != null) {
          variant = await _productRepository.getVariantById(cartItem.variantId!);
          if (variant == null) {
            throw Exception('Product variant not found: ${cartItem.variantId}');
          }
        }
        
        // Create order item
        await _orderRepository.createOrderItem(
          order_entity.OrderItem(
            id: 0, // Will be set by database
            uuid: const Uuid().v4(),
            orderId: order.id,
            productId: cartItem.productId,
            variantId: cartItem.variantId,
            productName: '', // Will be filled when we get product details
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
          ),
        );
        
        // Resolve recipe and calculate ingredient usage
        // For now, we'll assume all products are not recipes
        if (false) { // if (product.isRecipe) {
          await _resolveRecipeAndUpdateStock(
            productId: cartItem.productId,
            variantId: cartItem.variantId,
            quantity: cartItem.quantity,
            orderUuid: orderUuid,
          );
        }
        else {
          // Direct product stock update
          await _updateDirectProductStock(
            productId: cartItem.productId,
            variantId: cartItem.variantId,
            quantity: cartItem.quantity,
            orderUuid: orderUuid,
          );
        }
      }
      
      // Calculate order totals
      // Process payment
      final payment = order_entity.Payment(
        id: 0, // Will be set by database
        uuid: const Uuid().v4(),
        orderId: order.id,
        paymentMethod: paymentMethod,
        amount: paidAmount.round(),
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
      
      // Create payment through payment repository
      final paymentCompanion = PaymentsCompanion.insert(
        uuid: payment.uuid,
        orderId: payment.orderId,
        paymentMethod: payment.paymentMethod,
        amount: payment.amount,
        reference: Value(payment.reference),
        status: const Value('completed'),
        gateway: Value(null),
        gatewayTransactionId: Value(null),
        paymentDate: Value(payment.paymentDate),
      );
      
      await _database.into(_database.payments).insert(paymentCompanion);
      
      // Update cart status to completed
      // Update cart status to completed - this method doesn't exist yet
      // await _cartRepository.updateCartStatus(cartId, 'completed');
      
      // Return the created order
      final updatedOrder = await _orderRepository.getOrderById(order.id);
      if (updatedOrder == null) {
        throw Exception('Failed to retrieve updated order');
      }
      return updatedOrder;
    });
  }

  @override
  Future<void> refundTransaction({
    required int orderId,
    required String reason,
    double? refundAmount,
  }) async {
    await _database.transaction(() async {
      // Get order details
      final order = await _orderRepository.getOrderById(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }
      
      if (order.status != 'paid') {
        throw Exception('Only paid orders can be refunded');
      }
      
      // Create refund payment if amount is specified
      if (refundAmount != null && refundAmount > 0) {
        // Create refund payment
        final refundPayment = order_entity.Payment(
          id: 0, // Will be set by database
          uuid: const Uuid().v4(),
          orderId: orderId,
          paymentMethod: 'refund',
          amount: -refundAmount.round(), // Negative amount for refund
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
        
        final paymentCompanion = PaymentsCompanion.insert(
          uuid: refundPayment.uuid,
          orderId: refundPayment.orderId,
          paymentMethod: refundPayment.paymentMethod,
          amount: refundPayment.amount,
          reference: Value(refundPayment.reference),
          status: const Value('completed'),
          gateway: Value(null),
          gatewayTransactionId: Value(null),
          paymentDate: Value(refundPayment.paymentDate),
        );
        
        await _database.into(_database.payments).insert(paymentCompanion);
      }
      
      // Update order status
      // Update order status
      final updatedOrder = order.copyWith(
        status: 'refunded',
        notes: '${order.notes ?? ''}\n\nRefunded: $reason',
        updatedAt: DateTime.now(),
      );
      
      await _orderRepository.updateOrder(updatedOrder);
      
      // Restore stock for refunded items
      await _restoreStockForRefundedOrder(orderId);
    });
  }

  @override
  Future<void> voidTransaction({
    required int orderId,
    required String reason,
  }) async {
    await _database.transaction(() async {
      // Get order details
      final order = await _orderRepository.getOrderById(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }
      
      if (order.status != 'paid') {
        throw Exception('Only paid orders can be voided');
      }
      
      // Create void payment
      // Create void payment
      final voidPayment = order_entity.Payment(
        id: 0, // Will be set by database
        uuid: const Uuid().v4(),
        orderId: orderId,
        paymentMethod: 'void',
        amount: -order.totalAmount, // Negative amount for void
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
      
      final paymentCompanion = PaymentsCompanion.insert(
        uuid: voidPayment.uuid,
        orderId: voidPayment.orderId,
        paymentMethod: voidPayment.paymentMethod,
        amount: voidPayment.amount,
        reference: Value(voidPayment.reference),
        status: const Value('completed'),
        gateway: Value(null),
        gatewayTransactionId: Value(null),
        paymentDate: Value(voidPayment.paymentDate),
      );
      
      await _database.into(_database.payments).insert(paymentCompanion);
      
      // Update order status
      // Update order status
      final updatedOrder = order.copyWith(
        status: 'voided',
        notes: '${order.notes ?? ''}\n\nVoided: $reason',
        updatedAt: DateTime.now(),
      );
      
      await _orderRepository.updateOrder(updatedOrder);
      
      // Restore stock for voided items
      await _restoreStockForRefundedOrder(orderId);
    });
  }

  // Helper methods

  Future<void> _resolveRecipeAndUpdateStock({
    required int productId,
    int? variantId,
    required int quantity,
    required String orderUuid,
  }) async {
    // Get product recipes
    // For now, we'll use an empty list as a placeholder
    // final recipes = await _productRepository.getProductRecipes(productId);
    final recipes = <product_entity.Recipe>[];
    
    for (final recipe in recipes) {
      // Calculate ingredient usage
      final ingredientQuantity = recipe.quantity * quantity;
      
      // Get current stock
      final currentStock = await _stockRepository.getCurrentStock(
        recipe.ingredientId,
        variantId,
        recipe.ingredientId,
      );
      
      // Calculate new stock
      final newStock = currentStock.quantity - ingredientQuantity;
      
      if (newStock < 0) {
        throw Exception('Insufficient stock for ingredient: ${recipe.ingredientId}');
      }
      
      // Update stock
      await _stockRepository.updateStock(
        StockRequest(
          productId: null,
          variantId: variantId,
          ingredientId: recipe.ingredientId,
          quantity: newStock.toInt(),
          reason: 'Sale - $orderUuid',
        ),
      );
      
      // Create stock movement
      await _stockRepository.createStockMovement(
        StockMovementRequest(
          productId: null,
          variantId: variantId,
          ingredientId: recipe.ingredientId,
          movementType: 'out',
          quantity: ingredientQuantity.toInt(),
          previousQuantity: currentStock.quantity,
          newQuantity: newStock.toInt(),
          reason: 'Sale - $orderUuid',
          referenceId: orderUuid,
          referenceType: 'order',
        ),
      );
    }
  }

  Future<void> _updateDirectProductStock({
    required int productId,
    int? variantId,
    required int quantity,
    required String orderUuid,
  }) async {
    // Get current stock
    final currentStock = await _stockRepository.getCurrentStock(
      productId,
      variantId,
      null,
    );
    
    // Calculate new stock
    final newStock = currentStock.quantity - quantity;
    
    if (newStock < 0) {
      throw Exception('Insufficient stock for product: $productId');
    }
    
    // Update stock
    await _stockRepository.updateStock(
      StockRequest(
        productId: productId,
        variantId: variantId,
        ingredientId: null,
        quantity: newStock,
        reason: 'Sale - $orderUuid',
      ),
    );
    
    // Create stock movement
    await _stockRepository.createStockMovement(
      StockMovementRequest(
        productId: productId,
        variantId: variantId,
        ingredientId: null,
        movementType: 'out',
        quantity: quantity,
        previousQuantity: currentStock.quantity,
        newQuantity: newStock,
        reason: 'Sale - $orderUuid',
        referenceId: orderUuid,
        referenceType: 'order',
      ),
    );
  }

  Future<void> _restoreStockForRefundedOrder(int orderId) async {
    // Get order items
    final orderItems = await _orderRepository.getOrderItems(orderId);
    
    for (final orderItem in orderItems) {
      // Get product details
      final product = await _productRepository.getProductById(orderItem.productId);
      if (product == null) {
        throw Exception('Product not found: ${orderItem.productId}');
      }
      
      // Restore stock based on product type
      if (false) { // if (product.isRecipe) {
        await _restoreRecipeStock(
          productId: orderItem.productId,
          variantId: orderItem.variantId,
          quantity: orderItem.quantity,
        );
      }
      else {
        await _restoreDirectProductStock(
          productId: orderItem.productId,
          variantId: orderItem.variantId,
          quantity: orderItem.quantity,
        );
      }
    }
  }

  Future<void> _restoreRecipeStock({
    required int productId,
    int? variantId,
    required int quantity,
  }) async {
    // Get product recipes
    final recipes = await _productRepository.getRecipesByProduct(productId);
    
    for (final recipe in recipes) {
      // Calculate ingredient usage
      final ingredientQuantity = recipe.quantity * quantity;
      
      // Get current stock
      final currentStock = await _stockRepository.getCurrentStock(
        recipe.ingredientId,
        variantId,
        recipe.ingredientId,
      );
      
      // Calculate new stock
      final newStock = currentStock.quantity + ingredientQuantity;
      
      // Update stock
      await _stockRepository.updateStock(
        StockRequest(
          productId: null,
          variantId: variantId,
          ingredientId: recipe.ingredientId,
          quantity: newStock.toInt(),
          reason: 'Refund - Restored',
        ),
      );
      
      // Create stock movement
      await _stockRepository.createStockMovement(
        StockMovementRequest(
          productId: null,
          variantId: variantId,
          ingredientId: recipe.ingredientId,
          movementType: 'in',
          quantity: ingredientQuantity.toInt(),
          previousQuantity: currentStock.quantity,
          newQuantity: newStock.toInt(),
          reason: 'Refund - Restored',
          referenceType: 'refund',
        ),
      );
    }
  }

  Future<void> _restoreDirectProductStock({
    required int productId,
    int? variantId,
    required int quantity,
  }) async {
    // Get current stock
    final currentStock = await _stockRepository.getCurrentStock(
      productId,
      variantId,
      null,
    );
    
    // Calculate new stock
    final newStock = currentStock.quantity + quantity;
    
    // Update stock
    await _stockRepository.updateStock(
      StockRequest(
        productId: productId,
        variantId: variantId,
        ingredientId: null,
        quantity: newStock,
        reason: 'Refund - Restored',
      ),
    );
    
    // Create stock movement
    await _stockRepository.createStockMovement(
      StockMovementRequest(
        productId: productId,
        variantId: variantId,
        ingredientId: null,
        movementType: 'in',
        quantity: quantity,
        previousQuantity: currentStock.quantity,
        newQuantity: newStock,
        reason: 'Refund - Restored',
        referenceType: 'refund',
      ),
    );
  }
}