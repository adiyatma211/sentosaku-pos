import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';
import '../../domain/entities/category.dart' as entity;
import '../../domain/repositories/category_repository_interface.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final AppDatabase _database;
  
  CategoryRepository(this._database);
  
  @override
  Future<List<entity.Category>> getAllCategories() async {
    final categories = await (_database.select(_database.categories)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    
    return categories.map(_mapToEntity).toList();
  }
  
  @override
  Future<List<entity.Category>> getActiveCategories() async {
    final categories = await (_database.select(_database.categories)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true)))
        .get();
    
    return categories.map(_mapToEntity).toList();
  }
  
  @override
  Future<entity.Category?> getCategoryById(int id) async {
    final category = await (_database.select(_database.categories)
          ..where((tbl) => tbl.id.equals(id) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return category != null ? _mapToEntity(category) : null;
  }
  
  @override
  Future<entity.Category?> getCategoryByUuid(String uuid) async {
    final category = await (_database.select(_database.categories)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    
    return category != null ? _mapToEntity(category) : null;
  }
  
  @override
  Future<entity.Category> createCategory(entity.Category category) async {
    final categoryCompanion = CategoriesCompanion.insert(
      uuid: category.uuid,
      name: category.name,
      description: Value(category.description),
      color: Value(category.color),
      icon: Value(category.icon),
      parentId: Value(category.parentId),
      sortOrder: Value(category.sortOrder),
      isActive: Value(category.isActive),
    );
    
    final id = await _database.into(_database.categories).insert(categoryCompanion);
    final insertedCategory = await getCategoryById(id);
    
    if (insertedCategory == null) {
      throw Exception('Failed to create category');
    }
    
    return insertedCategory;
  }
  
  @override
  Future<entity.Category> updateCategory(entity.Category category) async {
    final categoryCompanion = CategoriesCompanion(
      uuid: Value(category.uuid),
      name: Value(category.name),
      description: Value(category.description),
      color: Value(category.color),
      icon: Value(category.icon),
      parentId: Value(category.parentId),
      sortOrder: Value(category.sortOrder),
      isActive: Value(category.isActive),
      updatedAt: Value(DateTime.now()),
    );
    
    await _database.update(_database.categories).replace(categoryCompanion);
    final updatedCategory = await getCategoryByUuid(category.uuid);
    
    if (updatedCategory == null) {
      throw Exception('Failed to update category');
    }
    
    return updatedCategory;
  }
  
  @override
  Future<bool> deleteCategory(int id) async {
    await (_database.delete(_database.categories)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    // In Drift, delete() returns void, so we'll assume success if no exception is thrown
    return true;
  }
  
  @override
  Future<bool> softDeleteCategory(int id) async {
    await (_database.update(_database.categories)
        ..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));
    
    // In Drift, update() returns void, so we'll assume success if no exception is thrown
    return true;
  }
  
  entity.Category _mapToEntity(Category data) {
    return entity.Category(
      id: data.id,
      uuid: data.uuid,
      name: data.name,
      description: data.description,
      color: data.color,
      icon: data.icon,
      parentId: data.parentId,
      sortOrder: data.sortOrder,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncStatus: data.syncStatus,
    );
  }
}