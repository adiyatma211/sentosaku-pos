import 'package:drift/drift.dart';

import '../app_database.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  // Get all active products
  Future<List<Product>> getAllProducts() {
    return (select(products)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)]))
        .get();
  }

  // Get product by ID
  Future<Product?> getProductById(int id) {
    return (select(products)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Get active products
  Future<List<Product>> getActiveProducts() {
    return (select(products)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)]))
        .get();
  }

  // Get products by category ID
  Future<List<Product>> getProductsByCategory(int categoryId) {
    return (select(products)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true) & tbl.categoryId.equals(categoryId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)]))
        .get();
  }

  // Get products by category ID with category details
  Future<List<Product>> getActiveProductsWithCategory(int? categoryId) {
    final query = select(products)
      ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true));
    
    if (categoryId != null) {
      query.where((tbl) => tbl.categoryId.equals(categoryId));
    }
    
    query.orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)]);
    
    return query.get();
  }

  // Search products by name, SKU, or barcode
  Future<List<Product>> searchProducts(String query) {
    final lowercaseQuery = '%$query%';
    return (select(products)
          ..where((tbl) =>
              tbl.isDeleted.equals(false) &
              tbl.isActive.equals(true) &
              (tbl.name.like(lowercaseQuery) |
               tbl.sku.like(lowercaseQuery) |
               tbl.barcode.like(lowercaseQuery)))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)]))
        .get();
  }

  // Create a new product
  Future<Product> createProduct(ProductsCompanion entry) async {
    final uuid = DateTime.now().millisecondsSinceEpoch.toString();
    return into(products).insertReturning(
      ProductsCompanion.insert(
        uuid: uuid,
        sku: entry.sku.value,
        name: entry.name.value,
        categoryId: entry.categoryId.value,
        price: entry.price.value,
        cost: entry.cost.value,
        stockQuantity: Value(entry.stockQuantity.value),
        minStockLevel: Value(entry.minStockLevel.value),
        unit: Value(entry.unit.value),
        isActive: const Value(true),
        isTrackStock: const Value(true),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isDeleted: const Value(false),
        syncStatus: const Value('pending'),
        barcode: entry.barcode,
        description: entry.description,
        maxStockLevel: entry.maxStockLevel,
        image: entry.image,
      ),
    );
  }

  // Update product
  Future<Product> updateProduct(int id, ProductsCompanion entry) async {
    await (update(products)..where((tbl) => tbl.id.equals(id)))
        .write(ProductsCompanion(
          name: entry.name,
          sku: entry.sku,
          barcode: entry.barcode,
          description: entry.description,
          categoryId: entry.categoryId,
          price: entry.price,
          cost: entry.cost,
          stockQuantity: entry.stockQuantity,
          minStockLevel: entry.minStockLevel,
          maxStockLevel: entry.maxStockLevel,
          unit: entry.unit,
          image: entry.image,
          isActive: entry.isActive,
          isTrackStock: entry.isTrackStock,
          updatedAt: Value(DateTime.now()),
        ));
    
    final product = await getProductById(id);
    if (product == null) {
      throw Exception('Product not found');
    }
    return product;
  }

  // Delete product (soft delete)
  Future<void> deleteProduct(int id) async {
    await (update(products)..where((tbl) => tbl.id.equals(id)))
        .write(ProductsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
  }

  // Get product count
  Future<int> getProductCount() async {
    final result = await (selectOnly(products)
          ..addColumns([products.id.count()])
          ..where(products.isDeleted.equals(false)))
        .getSingle();
    return result.read(products.id.count()) ?? 0;
  }

  // Get product count by category
  Future<int> getProductCountByCategory(int categoryId) async {
    final result = await (selectOnly(products)
          ..addColumns([products.id.count()])
          ..where((products.isDeleted.equals(false) & products.categoryId.equals(categoryId))))
        .getSingle();
    return result.read(products.id.count()) ?? 0;
  }
}
