import 'package:drift/drift.dart';

import '../app_database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(super.db);

  // Get all active categories
  Future<List<Category>> getAllCategories() {
    return (select(categories)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc)]))
        .get();
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) {
    return (select(categories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Get active categories
  Future<List<Category>> getActiveCategories() {
    return (select(categories)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc)]))
        .get();
  }

  // Create a new category
  Future<Category> createCategory(CategoriesCompanion entry) async {
    final uuid = DateTime.now().millisecondsSinceEpoch.toString();
    return into(categories).insertReturning(
      CategoriesCompanion.insert(
        uuid: uuid,
        sortOrder: entry.sortOrder,
        isActive: const Value(true),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isDeleted: const Value(false),
        syncStatus: const Value('pending'),
        name: entry.name.value,
        description: entry.description,
        color: entry.color,
        icon: entry.icon,
        parentId: entry.parentId,
      ),
    );
  }

  // Update category
  Future<Category> updateCategory(int id, CategoriesCompanion entry) async {
    await (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(
          name: entry.name,
          description: entry.description,
          color: entry.color,
          icon: entry.icon,
          parentId: entry.parentId,
          sortOrder: entry.sortOrder,
          isActive: entry.isActive,
          updatedAt: Value(DateTime.now()),
        ));
    
    final category = await getCategoryById(id);
    if (category == null) {
      throw Exception('Category not found');
    }
    return category;
  }

  // Delete category (soft delete)
  Future<void> deleteCategory(int id) async {
    await (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
  }

  // Get categories by parent ID
  Future<List<Category>> getCategoriesByParent(int? parentId) {
    if (parentId == null) {
      return (select(categories)
            ..where((tbl) => tbl.isDeleted.equals(false) & tbl.parentId.isNull())
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc)]))
          .get();
    } else {
      return (select(categories)
            ..where((tbl) => tbl.isDeleted.equals(false) & tbl.parentId.equals(parentId))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.asc)]))
          .get();
    }
  }

  // Get next sort order
  Future<int> getNextSortOrder() async {
    final result = await (select(categories)
          ..where((tbl) => tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    
    return (result?.sortOrder ?? 0) + 1;
  }

  // Get category count
  Future<int> getCategoryCount() async {
    final result = await (selectOnly(categories)
          ..addColumns([categories.id.count()])
          ..where(categories.isDeleted.equals(false)))
        .getSingle();
    return result.read(categories.id.count()) ?? 0;
  }
}

