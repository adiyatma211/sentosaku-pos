// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Ingredient {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  int get stockQuantity => throw _privateConstructorUsedError;
  int get minStockLevel => throw _privateConstructorUsedError;
  int? get maxStockLevel => throw _privateConstructorUsedError;
  int get cost => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngredientCopyWith<Ingredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientCopyWith<$Res> {
  factory $IngredientCopyWith(
    Ingredient value,
    $Res Function(Ingredient) then,
  ) = _$IngredientCopyWithImpl<$Res, Ingredient>;
  @useResult
  $Res call({
    int id,
    String uuid,
    String name,
    String? description,
    String? unit,
    int stockQuantity,
    int minStockLevel,
    int? maxStockLevel,
    int cost,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class _$IngredientCopyWithImpl<$Res, $Val extends Ingredient>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? name = null,
    Object? description = freezed,
    Object? unit = freezed,
    Object? stockQuantity = null,
    Object? minStockLevel = null,
    Object? maxStockLevel = freezed,
    Object? cost = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            uuid: null == uuid
                ? _value.uuid
                : uuid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            stockQuantity: null == stockQuantity
                ? _value.stockQuantity
                : stockQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            minStockLevel: null == minStockLevel
                ? _value.minStockLevel
                : minStockLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            maxStockLevel: freezed == maxStockLevel
                ? _value.maxStockLevel
                : maxStockLevel // ignore: cast_nullable_to_non_nullable
                      as int?,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IngredientImplCopyWith<$Res>
    implements $IngredientCopyWith<$Res> {
  factory _$$IngredientImplCopyWith(
    _$IngredientImpl value,
    $Res Function(_$IngredientImpl) then,
  ) = __$$IngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    String name,
    String? description,
    String? unit,
    int stockQuantity,
    int minStockLevel,
    int? maxStockLevel,
    int cost,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class __$$IngredientImplCopyWithImpl<$Res>
    extends _$IngredientCopyWithImpl<$Res, _$IngredientImpl>
    implements _$$IngredientImplCopyWith<$Res> {
  __$$IngredientImplCopyWithImpl(
    _$IngredientImpl _value,
    $Res Function(_$IngredientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? name = null,
    Object? description = freezed,
    Object? unit = freezed,
    Object? stockQuantity = null,
    Object? minStockLevel = null,
    Object? maxStockLevel = freezed,
    Object? cost = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _$IngredientImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        stockQuantity: null == stockQuantity
            ? _value.stockQuantity
            : stockQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        minStockLevel: null == minStockLevel
            ? _value.minStockLevel
            : minStockLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        maxStockLevel: freezed == maxStockLevel
            ? _value.maxStockLevel
            : maxStockLevel // ignore: cast_nullable_to_non_nullable
                  as int?,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$IngredientImpl extends _Ingredient {
  const _$IngredientImpl({
    required this.id,
    required this.uuid,
    required this.name,
    this.description,
    this.unit,
    required this.stockQuantity,
    required this.minStockLevel,
    this.maxStockLevel,
    required this.cost,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  }) : super._();

  @override
  final int id;
  @override
  final String uuid;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? unit;
  @override
  final int stockQuantity;
  @override
  final int minStockLevel;
  @override
  final int? maxStockLevel;
  @override
  final int cost;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;
  @override
  final String syncStatus;

  @override
  String toString() {
    return 'Ingredient(id: $id, uuid: $uuid, name: $name, description: $description, unit: $unit, stockQuantity: $stockQuantity, minStockLevel: $minStockLevel, maxStockLevel: $maxStockLevel, cost: $cost, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngredientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.minStockLevel, minStockLevel) ||
                other.minStockLevel == minStockLevel) &&
            (identical(other.maxStockLevel, maxStockLevel) ||
                other.maxStockLevel == maxStockLevel) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    uuid,
    name,
    description,
    unit,
    stockQuantity,
    minStockLevel,
    maxStockLevel,
    cost,
    isActive,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngredientImplCopyWith<_$IngredientImpl> get copyWith =>
      __$$IngredientImplCopyWithImpl<_$IngredientImpl>(this, _$identity);
}

abstract class _Ingredient extends Ingredient {
  const factory _Ingredient({
    required final int id,
    required final String uuid,
    required final String name,
    final String? description,
    final String? unit,
    required final int stockQuantity,
    required final int minStockLevel,
    final int? maxStockLevel,
    required final int cost,
    required final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final bool isDeleted,
    required final String syncStatus,
  }) = _$IngredientImpl;
  const _Ingredient._() : super._();

  @override
  int get id;
  @override
  String get uuid;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get unit;
  @override
  int get stockQuantity;
  @override
  int get minStockLevel;
  @override
  int? get maxStockLevel;
  @override
  int get cost;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get syncStatus;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngredientImplCopyWith<_$IngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
