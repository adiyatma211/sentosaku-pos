import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String uuid,
    required String sku,
    String? barcode,
    required String name,
    String? description,
    required int categoryId,
    required int price,
    required int cost,
    required int stockQuantity,
    required int minStockLevel,
    int? maxStockLevel,
    required String unit,
    String? image,
    required bool isActive,
    required bool isTrackStock,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
    // Additional fields for POS
    List<Variant>? variants,
    Category? category,
    List<Recipe>? recipes,
  }) = _Product;
}

@freezed
class Variant with _$Variant {
  const factory Variant({
    required int id,
    required String uuid,
    required int productId,
    required String name,
    String? sku,
    String? barcode,
    required int price,
    required int cost,
    required int stockQuantity,
    required int sortOrder,
    String? image,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
  }) = _Variant;
}

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required int id,
    required String uuid,
    required int productId,
    required int ingredientId,
    required double quantity,
    required String unit,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
  }) = _Recipe;
}

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String uuid,
    required String name,
    String? description,
    String? color,
    String? icon,
    int? parentId,
    required int sortOrder,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
  }) = _Category;
}