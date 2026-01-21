import 'package:drift/drift.dart';
import '../app_database.dart';

part 'product_option_dao.g.dart';

@DriftAccessor(tables: [
  ProductOptions,
  ProductOptionValues,
  ProductOptionAssignments,
])
class ProductOptionDao extends DatabaseAccessor<AppDatabase> with _$ProductOptionDaoMixin {
  ProductOptionDao(AppDatabase db) : super(db);

  /// Get all active product options
  Future<List<ProductOption>> getAllProductOptions() {
    return (select(productOptions)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();
  }

  /// Get product options for a specific product
  Future<List<ProductOption>> getProductOptionsForProduct(int productId) {
    final query = select(productOptions).join([
      innerJoin(productOptionAssignments,
          productOptionAssignments.optionId.equalsExp(productOptions.id)),
    ])
      ..where(productOptionAssignments.productId.equals(productId))
      ..where(productOptionAssignments.isActive.equals(true))
      ..where(productOptions.isActive.equals(true))
      ..orderBy([
        OrderingTerm.asc(productOptionAssignments.sortOrder),
        OrderingTerm.asc(productOptions.sortOrder),
      ]);

    return query.map((row) => row.readTable(productOptions)).get();
  }

  /// Get option values for a specific option
  Future<List<ProductOptionValue>> getOptionValues(int optionId) {
    return (select(productOptionValues)
          ..where((tbl) => tbl.optionId.equals(optionId))
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();
  }

  /// Get product options with their values for a specific product
  Future<List<Map<String, dynamic>>> getProductOptionsWithValues(int productId) async {
    final options = await getProductOptionsForProduct(productId);
    
    List<Map<String, dynamic>> result = [];
    for (var option in options) {
      final values = await getOptionValues(option.id);
      result.add({
        'option': option,
        'values': values,
      });
    }
    
    return result;
  }

  /// Create a new product option
  Future<int> createProductOption(ProductOptionsCompanion option) {
    return into(productOptions).insert(option);
  }

  /// Create a new product option value
  Future<int> createProductOptionValue(ProductOptionValuesCompanion value) {
    return into(productOptionValues).insert(value);
  }

  /// Assign an option to a product
  Future<int> assignOptionToProduct(ProductOptionAssignmentsCompanion assignment) {
    return into(productOptionAssignments).insert(assignment);
  }

  /// Update a product option
  Future<bool> updateProductOption(ProductOption option) {
    return update(productOptions).replace(option);
  }

  /// Update a product option value
  Future<bool> updateProductOptionValue(ProductOptionValue value) {
    return update(productOptionValues).replace(value);
  }

  /// Update a product option assignment
  Future<bool> updateProductOptionAssignment(ProductOptionAssignment assignment) {
    return update(productOptionAssignments).replace(assignment);
  }

  /// Delete a product option (soft delete)
  Future<int> deleteProductOption(int id) {
    return (update(productOptions)..where((tbl) => tbl.id.equals(id)))
        .write(const ProductOptionsCompanion(isDeleted: const Value(true)));
  }

  /// Delete a product option value (soft delete)
  Future<int> deleteProductOptionValue(int id) {
    return (update(productOptionValues)..where((tbl) => tbl.id.equals(id)))
        .write(const ProductOptionValuesCompanion(isDeleted: const Value(true)));
  }

  /// Delete a product option assignment (soft delete)
  Future<int> deleteProductOptionAssignment(int id) {
    return (update(productOptionAssignments)..where((tbl) => tbl.id.equals(id)))
        .write(const ProductOptionAssignmentsCompanion(isDeleted: const Value(true)));
  }

  /// Get default option value for an option
  Future<ProductOptionValue?> getDefaultValueForOption(int optionId) {
    return (select(productOptionValues)
          ..where((tbl) => tbl.optionId.equals(optionId))
          ..where((tbl) => tbl.isDefault.equals(true))
          ..where((tbl) => tbl.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Set default option value for an option
  Future<void> setDefaultValueForOption(int optionId, int valueId) async {
    // Remove default from all values for this option
    await (update(productOptionValues)
          ..where((tbl) => tbl.optionId.equals(optionId)))
        .write(const ProductOptionValuesCompanion(isDefault: const Value(false)));
    
    // Set default for the selected value
    await (update(productOptionValues)..where((tbl) => tbl.id.equals(valueId)))
        .write(const ProductOptionValuesCompanion(isDefault: const Value(true)));
  }

  /// Get all assignments for a product
  Future<List<ProductOptionAssignment>> getAssignmentsForProduct(int productId) {
    return (select(productOptionAssignments)
          ..where((tbl) => tbl.productId.equals(productId))
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();
  }

  /// Check if an option is required for a product
  Future<bool> isOptionRequiredForProduct(int productId, int optionId) {
    return (select(productOptionAssignments)
          ..where((tbl) => tbl.productId.equals(productId))
          ..where((tbl) => tbl.optionId.equals(optionId))
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .getSingleOrNull()
        .then((assignment) => assignment?.isRequired ?? false);
  }
}
