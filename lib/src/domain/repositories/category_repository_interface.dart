import '../entities/category.dart';

abstract class CategoryRepositoryInterface {
  Future<List<Category>> getAllCategories();
  Future<List<Category>> getActiveCategories();
  Future<Category?> getCategoryById(int id);
  Future<Category?> getCategoryByUuid(String uuid);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<bool> deleteCategory(int id);
  Future<bool> softDeleteCategory(int id);
}