import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dao/cart_dao.dart';
import 'dao/ingredient_dao.dart';
import 'dao/category_dao.dart';
import 'dao/product_dao.dart';
import 'dao/recipe_dao.dart';
import 'dao/product_option_dao.dart';
part 'app_database.g.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get sku => text().unique()();
  TextColumn get barcode => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get price => integer()();
  IntColumn get cost => integer()();
  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();
  IntColumn get minStockLevel => integer().withDefault(const Constant(0))();
  IntColumn get maxStockLevel => integer().nullable()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  TextColumn get image => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isTrackStock => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Variant')
class Variants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get name => text()();
  TextColumn get sku => text().nullable()();
  TextColumn get barcode => text().nullable()();
  IntColumn get price => integer()();
  IntColumn get cost => integer()();
  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get image => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Ingredient')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();
  IntColumn get minStockLevel => integer().withDefault(const Constant(0))();
  IntColumn get maxStockLevel => integer().nullable()();
  IntColumn get cost => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Recipe')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('ProductOption')
class ProductOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get name => text()(); // e.g., "Sugar Level"
  TextColumn get selectionType => text().withDefault(const Constant('single'))(); // 'single' or 'multiple' selection
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('ProductOptionValue')
class ProductOptionValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get optionId => integer().references(ProductOptions, #id)();
  TextColumn get name => text()(); // e.g., "Low Sugar"
  IntColumn get priceAdjustment => integer().withDefault(const Constant(0))(); // Additional price
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('ProductOptionAssignment')
class ProductOptionAssignments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get optionId => integer().references(ProductOptions, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Stock')
class Stocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId => integer().nullable().references(Variants, #id)();
  IntColumn get ingredientId => integer().nullable().references(Ingredients, #id)();
  IntColumn get quantity => integer()();
  IntColumn get reservedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get availableQuantity => integer()();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('StockMovement')
class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId => integer().nullable().references(Variants, #id)();
  IntColumn get ingredientId => integer().nullable().references(Ingredients, #id)();
  TextColumn get movementType => text()(); // 'in', 'out', 'adjustment', 'sale', 'return'
  IntColumn get quantity => integer()();
  IntColumn get previousQuantity => integer()();
  IntColumn get newQuantity => integer()();
  TextColumn get reason => text().nullable()();
  TextColumn get referenceId => text().nullable()(); // Order ID, etc.
  TextColumn get referenceType => text().nullable()(); // 'order', 'adjustment', etc.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Order')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get orderNumber => text().unique()();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get customerEmail => text().nullable()();
  TextColumn get customerAddress => text().nullable()();
  IntColumn get subtotal => integer()();
  IntColumn get taxAmount => integer().withDefault(const Constant(0))();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();
  IntColumn get totalAmount => integer()();
  IntColumn get paidAmount => integer().withDefault(const Constant(0))();
  IntColumn get changeAmount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // 'pending', 'paid', 'cancelled', 'refunded'
  TextColumn get paymentStatus => text().withDefault(const Constant('unpaid'))(); // 'unpaid', 'partial', 'paid', 'refunded'
  TextColumn get paymentMethod => text().nullable()(); // 'cash', 'card', 'transfer', 'ewallet'
  TextColumn get notes => text().nullable()();
  DateTimeColumn get orderDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('OrderItem')
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId => integer().nullable().references(Variants, #id)();
  TextColumn get productName => text()();
  TextColumn get variantName => text().nullable()();
  IntColumn get quantity => integer()();
  IntColumn get unitPrice => integer()();
  IntColumn get totalPrice => integer()();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Payment')
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get orderId => integer().references(Orders, #id)();
  TextColumn get paymentMethod => text()(); // 'cash', 'card', 'transfer', 'ewallet'
  IntColumn get amount => integer()();
  TextColumn get reference => text().nullable()(); // Card number, transfer reference, etc.
  TextColumn get status => text().withDefault(const Constant('pending'))(); // 'pending', 'completed', 'failed', 'refunded'
  TextColumn get gateway => text().nullable()(); // Payment gateway used
  TextColumn get gatewayTransactionId => text().nullable()();
  DateTimeColumn get paymentDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get username => text().unique()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()(); // Hashed password
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('cashier'))(); // 'admin', 'manager', 'cashier'
  TextColumn get avatar => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('AuditLog')
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get userId => integer().nullable().references(Users, #id)();
  TextColumn get action => text()(); // 'create', 'update', 'delete', 'login', 'logout'
  TextColumn get entityType => text()(); // 'product', 'order', 'user', etc.
  TextColumn get entityId => text().nullable()();
  TextColumn get oldValues => text().nullable()(); // JSON string
  TextColumn get newValues => text().nullable()(); // JSON string
  TextColumn get ipAddress => text().nullable()();
  TextColumn get userAgent => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('AppSetting')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get dataType => text().withDefault(const Constant('string'))(); // 'string', 'number', 'boolean', 'json'
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('Cart')
class Carts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get customerId => integer().nullable().references(Users, #id)();
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  TextColumn get discountCode => text().nullable()();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('active'))(); // 'active', 'completed', 'abandoned'
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DataClassName('CartItem')
class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get cartId => integer().references(Carts, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get variantId => integer().nullable().references(Variants, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  RealColumn get totalPrice => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}

@DriftDatabase(
  tables: [
    Categories,
    Products,
    Variants,
    Ingredients,
    Recipes,
    ProductOptions,
    ProductOptionValues,
    ProductOptionAssignments,
    Stocks,
    StockMovements,
    Orders,
    OrderItems,
    Payments,
    Carts,
    CartItems,
    Users,
    AuditLogs,
    AppSettings,
  ],
  daos: [
    CartDao,
    IngredientDao,
    CategoryDao,
    ProductDao,
    RecipeDao,
    ProductOptionDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migration logic here when schema version changes
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sentosa_pos.db'));
    return NativeDatabase(file);
  });
}