import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/dao/category_dao.dart';
import '../../data/datasources/local/dao/product_dao.dart';
import '../../data/datasources/local/dao/recipe_dao.dart';
import '../../data/datasources/local/dao/product_option_dao.dart';
import '../../domain/services/transaction_service_stub.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Database Connection Provider
final dbConnectionProvider = Provider<AppDatabase>((ref) {
  final db = ref.watch(databaseProvider);
  return db;
});

// Category DAO Provider
final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.watch(dbConnectionProvider);
  return db.categoryDao;
});

// Product DAO Provider
final productDaoProvider = Provider<ProductDao>((ref) {
  final db = ref.watch(dbConnectionProvider);
  return db.productDao;
});

// Recipe DAO Provider
final recipeDaoProvider = Provider<RecipeDao>((ref) {
  final db = ref.watch(dbConnectionProvider);
  return db.recipeDao;
});

// Transaction Service Provider
final transactionServiceProvider = Provider<TransactionServiceStub?>((ref) {
  // This will be implemented when TransactionService is available
  return TransactionServiceStub();
});

// Product Option DAO Provider
final productOptionDaoProvider = Provider<ProductOptionDao>((ref) {
  final db = ref.watch(dbConnectionProvider);
  return db.productOptionDao;
});