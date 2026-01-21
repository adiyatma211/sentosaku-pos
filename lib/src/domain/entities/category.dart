import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

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