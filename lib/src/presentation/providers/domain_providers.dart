import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../data/repositories/order_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/services/receipt_service_impl.dart';
import '../../domain/repositories/cart_repository.dart' as cart_repo;
import '../../domain/entities/cart.dart' as cart_entity;
import '../../domain/entities/failure.dart';
import '../../domain/services/bluetooth_service.dart';
import '../../domain/services/receipt_service.dart';
import '../../domain/services/transaction_service_stub.dart';
import '../providers/global_providers.dart';

// Cart repository provider
final cartRepositoryProvider = Provider<cart_repo.CartRepository>((ref) {
  // We need to create a CartDao instance, but for now we'll create a simple implementation
  // In a real app, this would be injected properly
  // For now, let's create a simple mock implementation
  return MockCartRepository();
});

// Order repository provider
final orderRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return OrderRepository(database);
});

// Payment repository provider
final paymentRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return PaymentRepository(database);
});

// Bluetooth service provider
final bluetoothServiceProvider = Provider<BluetoothService>((ref) {
  // Create a mock implementation for now
  return MockBluetoothService();
});

// Receipt service provider
final receiptServiceProvider = Provider<ReceiptService>((ref) {
  return ReceiptServiceImpl();
});

// Transaction service provider
final transactionServiceProvider = Provider<TransactionServiceStub?>((ref) {
  return TransactionServiceStub();
});

// Mock implementation for testing
class MockCartRepository implements cart_repo.CartRepository {
  @override
  Future<Either<Failure, cart_entity.Cart?>> getCurrentCart() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> createCart() async {
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> addToCart({
    required int cartId,
    required int productId,
    required int quantity,
    int? variantId,
    String? notes,
  }) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> removeFromCart(int cartItemId) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> clearCart(int cartId) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> applyDiscount(int cartId, String discountCode) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> removeDiscount(int cartId) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, cart_entity.Cart>> getCartById(int cartId) async {
    // Mock implementation
    final cart = cart_entity.Cart(
      id: 1,
      items: [],
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Right(cart);
  }

  @override
  Future<Either<Failure, List<cart_entity.Cart>>> getCartsByDateRange(DateTime startDate, DateTime endDate) async {
    // Mock implementation
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> deleteCart(int cartId) async {
    // Mock implementation
    return const Right(null);
  }
}

// Mock implementation for BluetoothService
class MockBluetoothService implements BluetoothService {
  @override
  Future<bool> isBluetoothAvailable() async {
    return false;
  }

  @override
  Future<List<BluetoothDevice>> getPairedDevices() async {
    return [];
  }

  @override
  Future<bool> connectToDevice(String deviceId) async {
    return false;
  }

  @override
  Future<void> disconnectDevice(String deviceId) async {
    // Mock implementation
  }

  @override
  Future<bool> printToDevice({
    required String deviceId,
    required String content,
    Map<String, dynamic>? options,
  }) async {
    return false;
  }

  @override
  Stream<List<BluetoothDevice>> getAvailableDevices() {
    return Stream.value([]);
  }

  @override
  Stream<BluetoothDevice?> get connectedDeviceStream {
    return Stream.value(null);
  }

  @override
  Stream<String> get connectionStateStream {
    return Stream.value('disconnected');
  }
}