import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../app_database.dart';

part 'cart_dao.g.dart';

@DriftAccessor(tables: [Carts, CartItems, Products, Variants])
class CartDao extends DatabaseAccessor<AppDatabase> with _$CartDaoMixin {
  CartDao(super.db);

  // Get current active cart
  Future<Cart?> getCurrentCart() {
    return (select(carts)
          ..where((tbl) => tbl.status.equals('active'))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  // Get cart by ID
  Future<Cart?> getCartById(int id) {
    return (select(carts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Create a new cart
  Future<Cart> createCart() async {
    final uuid = DateTime.now().millisecondsSinceEpoch.toString();
    return into(carts).insertReturning(
      CartsCompanion.insert(
        uuid: uuid,
        status: const Value('active'),
        subtotal: const Value(0.0),
        taxAmount: const Value(0.0),
        discountAmount: const Value(0.0),
        totalAmount: const Value(0.0),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Update cart totals
  Future<void> updateCartTotals(int cartId) async {
    // Calculate totals from cart items
    final itemsQuery = selectOnly(cartItems)
      ..addColumns([cartItems.totalPrice.sum()])
      ..where(cartItems.cartId.equals(cartId));
    
    final result = await itemsQuery.getSingle();
    final subtotal = result.read(cartItems.totalPrice.sum()) ?? 0.0;
    
    // Calculate tax (10%)
    final taxAmount = subtotal * 0.1;
    final totalAmount = subtotal + taxAmount;
    
    // Update cart
    await (update(carts)..where((tbl) => tbl.id.equals(cartId)))
        .write(CartsCompanion(
      subtotal: Value(subtotal),
      taxAmount: Value(taxAmount),
      totalAmount: Value(totalAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // Update cart discount
  Future<void> updateCartDiscount(int cartId, String? discountCode, double discountAmount) async {
    // Get current cart
    final cart = await getCartById(cartId);
    if (cart == null) return;
    
    // Calculate new total with discount
    final newTotalAmount = cart.subtotal + cart.taxAmount - discountAmount;
    
    // Update cart
    await (update(carts)..where((tbl) => tbl.id.equals(cartId)))
        .write(CartsCompanion(
      discountCode: Value(discountCode),
      discountAmount: Value(discountAmount),
      totalAmount: Value(newTotalAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // Get cart items
  Future<List<CartItem>> getCartItems(int cartId) {
    return (select(cartItems)
          ..where((tbl) => tbl.cartId.equals(cartId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
        .get();
  }

  // Get cart item by ID
  Future<CartItem?> getCartItemById(int id) {
    return (select(cartItems)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Get cart item by product and variant
  Future<CartItem?> getCartItemByProductVariant(int cartId, int productId, int? variantId) {
    final query = select(cartItems)
      ..where((tbl) => tbl.cartId.equals(cartId) & tbl.productId.equals(productId));
    
    if (variantId != null) {
      query.where((tbl) => tbl.variantId.equals(variantId));
    } else {
      query.where((tbl) => tbl.variantId.isNull());
    }
    
    return query.getSingleOrNull();
  }

  // Add cart item
  Future<CartItem> addCartItem(CartItemsCompanion entry) {
    return into(cartItems).insertReturning(entry);
  }

  // Update cart item quantity
  Future<CartItem> updateCartItemQuantity(int cartItemId, int quantity) async {
    // Get current item
    final item = await getCartItemById(cartItemId);
    if (item == null) throw Exception('Cart item not found');
    
    // Get product or variant price
    double unitPrice;
    if (item.variantId != null) {
      final variant = await getVariantById(item.variantId!);
      if (variant == null) throw Exception('Product variant not found');
      unitPrice = variant.price.toDouble();
    } else {
      final product = await getProductById(item.productId);
      if (product == null) throw Exception('Product not found');
      unitPrice = product.price.toDouble();
    }
    
    // Calculate new total price
    final totalPrice = unitPrice * quantity;
    
    // Update item
    await (update(cartItems)..where((tbl) => tbl.id.equals(cartItemId)))
        .write(CartItemsCompanion(
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      totalPrice: Value(totalPrice),
      updatedAt: Value(DateTime.now()),
    ));
    
    // Get updated item
    final updatedItem = await getCartItemById(cartItemId);
    if (updatedItem == null) throw Exception('Failed to update cart item');
    
    // Update cart totals
    await updateCartTotals(item.cartId);
    
    return updatedItem;
  }

  // Remove cart item
  Future<void> removeCartItem(int cartItemId) async {
    // Get item to get cart ID
    final item = await getCartItemById(cartItemId);
    if (item == null) throw Exception('Cart item not found');
    
    // Delete item
    await (delete(cartItems)..where((tbl) => tbl.id.equals(cartItemId))).go();
    
    // Update cart totals
    await updateCartTotals(item.cartId);
  }

  // Clear cart
  Future<void> clearCart(int cartId) async {
    await (delete(cartItems)..where((tbl) => tbl.cartId.equals(cartId))).go();
    await updateCartTotals(cartId);
  }

  // Get product by ID
  Future<Product?> getProductById(int id) {
    return (select(products)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Get variant by ID
  Future<Variant?> getVariantById(int id) {
    return (select(variants)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Get carts by date range
  Future<List<Cart>> getCartsByDateRange(DateTime startDate, DateTime endDate) {
    return (select(carts)
          ..where((tbl) =>
              tbl.createdAt.isBetweenValues(startDate, endDate) &
              tbl.status.isNotIn(['active'])
            )
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  // Delete cart
  Future<void> deleteCart(int cartId) async {
    // Delete cart items first
    await (delete(cartItems)..where((tbl) => tbl.cartId.equals(cartId))).go();
    
    // Delete cart
    await (delete(carts)..where((tbl) => tbl.id.equals(cartId))).go();
  }
}