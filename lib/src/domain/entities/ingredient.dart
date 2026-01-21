import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required int id,
    required String uuid,
    required String name,
    String? description,
    String? unit,
    required int stockQuantity,
    required int minStockLevel,
    int? maxStockLevel,
    required int cost,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
    required String syncStatus,
  }) = _Ingredient;

  const Ingredient._();
}
