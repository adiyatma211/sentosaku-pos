// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Stock {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  int? get ingredientId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get reservedQuantity => throw _privateConstructorUsedError;
  int get availableQuantity => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockCopyWith<Stock> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockCopyWith<$Res> {
  factory $StockCopyWith(Stock value, $Res Function(Stock) then) =
      _$StockCopyWithImpl<$Res, Stock>;
  @useResult
  $Res call({
    int id,
    String uuid,
    int? productId,
    int? variantId,
    int? ingredientId,
    int quantity,
    int reservedQuantity,
    int availableQuantity,
    DateTime lastUpdated,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class _$StockCopyWithImpl<$Res, $Val extends Stock>
    implements $StockCopyWith<$Res> {
  _$StockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? quantity = null,
    Object? reservedQuantity = null,
    Object? availableQuantity = null,
    Object? lastUpdated = null,
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
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int?,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            ingredientId: freezed == ingredientId
                ? _value.ingredientId
                : ingredientId // ignore: cast_nullable_to_non_nullable
                      as int?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            reservedQuantity: null == reservedQuantity
                ? _value.reservedQuantity
                : reservedQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            availableQuantity: null == availableQuantity
                ? _value.availableQuantity
                : availableQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$StockImplCopyWith<$Res> implements $StockCopyWith<$Res> {
  factory _$$StockImplCopyWith(
    _$StockImpl value,
    $Res Function(_$StockImpl) then,
  ) = __$$StockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    int? productId,
    int? variantId,
    int? ingredientId,
    int quantity,
    int reservedQuantity,
    int availableQuantity,
    DateTime lastUpdated,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class __$$StockImplCopyWithImpl<$Res>
    extends _$StockCopyWithImpl<$Res, _$StockImpl>
    implements _$$StockImplCopyWith<$Res> {
  __$$StockImplCopyWithImpl(
    _$StockImpl _value,
    $Res Function(_$StockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? quantity = null,
    Object? reservedQuantity = null,
    Object? availableQuantity = null,
    Object? lastUpdated = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _$StockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int?,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        ingredientId: freezed == ingredientId
            ? _value.ingredientId
            : ingredientId // ignore: cast_nullable_to_non_nullable
                  as int?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        reservedQuantity: null == reservedQuantity
            ? _value.reservedQuantity
            : reservedQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        availableQuantity: null == availableQuantity
            ? _value.availableQuantity
            : availableQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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

class _$StockImpl implements _Stock {
  const _$StockImpl({
    required this.id,
    required this.uuid,
    this.productId,
    this.variantId,
    this.ingredientId,
    required this.quantity,
    this.reservedQuantity = 0,
    this.availableQuantity = 0,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.syncStatus = 'pending',
  });

  @override
  final int id;
  @override
  final String uuid;
  @override
  final int? productId;
  @override
  final int? variantId;
  @override
  final int? ingredientId;
  @override
  final int quantity;
  @override
  @JsonKey()
  final int reservedQuantity;
  @override
  @JsonKey()
  final int availableQuantity;
  @override
  final DateTime lastUpdated;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final String syncStatus;

  @override
  String toString() {
    return 'Stock(id: $id, uuid: $uuid, productId: $productId, variantId: $variantId, ingredientId: $ingredientId, quantity: $quantity, reservedQuantity: $reservedQuantity, availableQuantity: $availableQuantity, lastUpdated: $lastUpdated, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reservedQuantity, reservedQuantity) ||
                other.reservedQuantity == reservedQuantity) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
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
    productId,
    variantId,
    ingredientId,
    quantity,
    reservedQuantity,
    availableQuantity,
    lastUpdated,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockImplCopyWith<_$StockImpl> get copyWith =>
      __$$StockImplCopyWithImpl<_$StockImpl>(this, _$identity);
}

abstract class _Stock implements Stock {
  const factory _Stock({
    required final int id,
    required final String uuid,
    final int? productId,
    final int? variantId,
    final int? ingredientId,
    required final int quantity,
    final int reservedQuantity,
    final int availableQuantity,
    required final DateTime lastUpdated,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final bool isDeleted,
    final String syncStatus,
  }) = _$StockImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  int? get productId;
  @override
  int? get variantId;
  @override
  int? get ingredientId;
  @override
  int get quantity;
  @override
  int get reservedQuantity;
  @override
  int get availableQuantity;
  @override
  DateTime get lastUpdated;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get syncStatus;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockImplCopyWith<_$StockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockMovement {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  int? get ingredientId => throw _privateConstructorUsedError;
  String get movementType =>
      throw _privateConstructorUsedError; // 'in', 'out', 'adjustment', 'sale', 'return'
  int get quantity => throw _privateConstructorUsedError;
  int get previousQuantity => throw _privateConstructorUsedError;
  int get newQuantity => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get referenceId =>
      throw _privateConstructorUsedError; // Order ID, adjustment ID, etc.
  String? get referenceType =>
      throw _privateConstructorUsedError; // 'order', 'adjustment', etc.
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMovementCopyWith<StockMovement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMovementCopyWith<$Res> {
  factory $StockMovementCopyWith(
    StockMovement value,
    $Res Function(StockMovement) then,
  ) = _$StockMovementCopyWithImpl<$Res, StockMovement>;
  @useResult
  $Res call({
    int id,
    String uuid,
    int? productId,
    int? variantId,
    int? ingredientId,
    String movementType,
    int quantity,
    int previousQuantity,
    int newQuantity,
    String? reason,
    String? referenceId,
    String? referenceType,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class _$StockMovementCopyWithImpl<$Res, $Val extends StockMovement>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? movementType = null,
    Object? quantity = null,
    Object? previousQuantity = null,
    Object? newQuantity = null,
    Object? reason = freezed,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
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
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int?,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            ingredientId: freezed == ingredientId
                ? _value.ingredientId
                : ingredientId // ignore: cast_nullable_to_non_nullable
                      as int?,
            movementType: null == movementType
                ? _value.movementType
                : movementType // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            previousQuantity: null == previousQuantity
                ? _value.previousQuantity
                : previousQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            newQuantity: null == newQuantity
                ? _value.newQuantity
                : newQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceType: freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$StockMovementImplCopyWith<$Res>
    implements $StockMovementCopyWith<$Res> {
  factory _$$StockMovementImplCopyWith(
    _$StockMovementImpl value,
    $Res Function(_$StockMovementImpl) then,
  ) = __$$StockMovementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    int? productId,
    int? variantId,
    int? ingredientId,
    String movementType,
    int quantity,
    int previousQuantity,
    int newQuantity,
    String? reason,
    String? referenceId,
    String? referenceType,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class __$$StockMovementImplCopyWithImpl<$Res>
    extends _$StockMovementCopyWithImpl<$Res, _$StockMovementImpl>
    implements _$$StockMovementImplCopyWith<$Res> {
  __$$StockMovementImplCopyWithImpl(
    _$StockMovementImpl _value,
    $Res Function(_$StockMovementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? movementType = null,
    Object? quantity = null,
    Object? previousQuantity = null,
    Object? newQuantity = null,
    Object? reason = freezed,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _$StockMovementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int?,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        ingredientId: freezed == ingredientId
            ? _value.ingredientId
            : ingredientId // ignore: cast_nullable_to_non_nullable
                  as int?,
        movementType: null == movementType
            ? _value.movementType
            : movementType // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        previousQuantity: null == previousQuantity
            ? _value.previousQuantity
            : previousQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        newQuantity: null == newQuantity
            ? _value.newQuantity
            : newQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceType: freezed == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String?,
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

class _$StockMovementImpl implements _StockMovement {
  const _$StockMovementImpl({
    required this.id,
    required this.uuid,
    this.productId,
    this.variantId,
    this.ingredientId,
    required this.movementType,
    required this.quantity,
    required this.previousQuantity,
    required this.newQuantity,
    this.reason,
    this.referenceId,
    this.referenceType,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.syncStatus = 'pending',
  });

  @override
  final int id;
  @override
  final String uuid;
  @override
  final int? productId;
  @override
  final int? variantId;
  @override
  final int? ingredientId;
  @override
  final String movementType;
  // 'in', 'out', 'adjustment', 'sale', 'return'
  @override
  final int quantity;
  @override
  final int previousQuantity;
  @override
  final int newQuantity;
  @override
  final String? reason;
  @override
  final String? referenceId;
  // Order ID, adjustment ID, etc.
  @override
  final String? referenceType;
  // 'order', 'adjustment', etc.
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final String syncStatus;

  @override
  String toString() {
    return 'StockMovement(id: $id, uuid: $uuid, productId: $productId, variantId: $variantId, ingredientId: $ingredientId, movementType: $movementType, quantity: $quantity, previousQuantity: $previousQuantity, newQuantity: $newQuantity, reason: $reason, referenceId: $referenceId, referenceType: $referenceType, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.movementType, movementType) ||
                other.movementType == movementType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.newQuantity, newQuantity) ||
                other.newQuantity == newQuantity) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
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
    productId,
    variantId,
    ingredientId,
    movementType,
    quantity,
    previousQuantity,
    newQuantity,
    reason,
    referenceId,
    referenceType,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementImplCopyWith<_$StockMovementImpl> get copyWith =>
      __$$StockMovementImplCopyWithImpl<_$StockMovementImpl>(this, _$identity);
}

abstract class _StockMovement implements StockMovement {
  const factory _StockMovement({
    required final int id,
    required final String uuid,
    final int? productId,
    final int? variantId,
    final int? ingredientId,
    required final String movementType,
    required final int quantity,
    required final int previousQuantity,
    required final int newQuantity,
    final String? reason,
    final String? referenceId,
    final String? referenceType,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final bool isDeleted,
    final String syncStatus,
  }) = _$StockMovementImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  int? get productId;
  @override
  int? get variantId;
  @override
  int? get ingredientId;
  @override
  String get movementType; // 'in', 'out', 'adjustment', 'sale', 'return'
  @override
  int get quantity;
  @override
  int get previousQuantity;
  @override
  int get newQuantity;
  @override
  String? get reason;
  @override
  String? get referenceId; // Order ID, adjustment ID, etc.
  @override
  String? get referenceType; // 'order', 'adjustment', etc.
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get syncStatus;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMovementImplCopyWith<_$StockMovementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockRequest {
  int? get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  int? get ingredientId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get referenceId => throw _privateConstructorUsedError;
  String? get referenceType => throw _privateConstructorUsedError;

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockRequestCopyWith<StockRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockRequestCopyWith<$Res> {
  factory $StockRequestCopyWith(
    StockRequest value,
    $Res Function(StockRequest) then,
  ) = _$StockRequestCopyWithImpl<$Res, StockRequest>;
  @useResult
  $Res call({
    int? productId,
    int? variantId,
    int? ingredientId,
    int quantity,
    String reason,
    String? referenceId,
    String? referenceType,
  });
}

/// @nodoc
class _$StockRequestCopyWithImpl<$Res, $Val extends StockRequest>
    implements $StockRequestCopyWith<$Res> {
  _$StockRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? quantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int?,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            ingredientId: freezed == ingredientId
                ? _value.ingredientId
                : ingredientId // ignore: cast_nullable_to_non_nullable
                      as int?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceType: freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockRequestImplCopyWith<$Res>
    implements $StockRequestCopyWith<$Res> {
  factory _$$StockRequestImplCopyWith(
    _$StockRequestImpl value,
    $Res Function(_$StockRequestImpl) then,
  ) = __$$StockRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? productId,
    int? variantId,
    int? ingredientId,
    int quantity,
    String reason,
    String? referenceId,
    String? referenceType,
  });
}

/// @nodoc
class __$$StockRequestImplCopyWithImpl<$Res>
    extends _$StockRequestCopyWithImpl<$Res, _$StockRequestImpl>
    implements _$$StockRequestImplCopyWith<$Res> {
  __$$StockRequestImplCopyWithImpl(
    _$StockRequestImpl _value,
    $Res Function(_$StockRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? quantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
  }) {
    return _then(
      _$StockRequestImpl(
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int?,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        ingredientId: freezed == ingredientId
            ? _value.ingredientId
            : ingredientId // ignore: cast_nullable_to_non_nullable
                  as int?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceType: freezed == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$StockRequestImpl implements _StockRequest {
  const _$StockRequestImpl({
    required this.productId,
    required this.variantId,
    required this.ingredientId,
    required this.quantity,
    required this.reason,
    this.referenceId,
    this.referenceType,
  });

  @override
  final int? productId;
  @override
  final int? variantId;
  @override
  final int? ingredientId;
  @override
  final int quantity;
  @override
  final String reason;
  @override
  final String? referenceId;
  @override
  final String? referenceType;

  @override
  String toString() {
    return 'StockRequest(productId: $productId, variantId: $variantId, ingredientId: $ingredientId, quantity: $quantity, reason: $reason, referenceId: $referenceId, referenceType: $referenceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockRequestImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    variantId,
    ingredientId,
    quantity,
    reason,
    referenceId,
    referenceType,
  );

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockRequestImplCopyWith<_$StockRequestImpl> get copyWith =>
      __$$StockRequestImplCopyWithImpl<_$StockRequestImpl>(this, _$identity);
}

abstract class _StockRequest implements StockRequest {
  const factory _StockRequest({
    required final int? productId,
    required final int? variantId,
    required final int? ingredientId,
    required final int quantity,
    required final String reason,
    final String? referenceId,
    final String? referenceType,
  }) = _$StockRequestImpl;

  @override
  int? get productId;
  @override
  int? get variantId;
  @override
  int? get ingredientId;
  @override
  int get quantity;
  @override
  String get reason;
  @override
  String? get referenceId;
  @override
  String? get referenceType;

  /// Create a copy of StockRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockRequestImplCopyWith<_$StockRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StockMovementRequest {
  int? get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  int? get ingredientId => throw _privateConstructorUsedError;
  String get movementType => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get previousQuantity => throw _privateConstructorUsedError;
  int get newQuantity => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get referenceId => throw _privateConstructorUsedError;
  String? get referenceType => throw _privateConstructorUsedError;

  /// Create a copy of StockMovementRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMovementRequestCopyWith<StockMovementRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMovementRequestCopyWith<$Res> {
  factory $StockMovementRequestCopyWith(
    StockMovementRequest value,
    $Res Function(StockMovementRequest) then,
  ) = _$StockMovementRequestCopyWithImpl<$Res, StockMovementRequest>;
  @useResult
  $Res call({
    int? productId,
    int? variantId,
    int? ingredientId,
    String movementType,
    int quantity,
    int previousQuantity,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  });
}

/// @nodoc
class _$StockMovementRequestCopyWithImpl<
  $Res,
  $Val extends StockMovementRequest
>
    implements $StockMovementRequestCopyWith<$Res> {
  _$StockMovementRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMovementRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? movementType = null,
    Object? quantity = null,
    Object? previousQuantity = null,
    Object? newQuantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int?,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            ingredientId: freezed == ingredientId
                ? _value.ingredientId
                : ingredientId // ignore: cast_nullable_to_non_nullable
                      as int?,
            movementType: null == movementType
                ? _value.movementType
                : movementType // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            previousQuantity: null == previousQuantity
                ? _value.previousQuantity
                : previousQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            newQuantity: null == newQuantity
                ? _value.newQuantity
                : newQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceType: freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockMovementRequestImplCopyWith<$Res>
    implements $StockMovementRequestCopyWith<$Res> {
  factory _$$StockMovementRequestImplCopyWith(
    _$StockMovementRequestImpl value,
    $Res Function(_$StockMovementRequestImpl) then,
  ) = __$$StockMovementRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? productId,
    int? variantId,
    int? ingredientId,
    String movementType,
    int quantity,
    int previousQuantity,
    int newQuantity,
    String reason,
    String? referenceId,
    String? referenceType,
  });
}

/// @nodoc
class __$$StockMovementRequestImplCopyWithImpl<$Res>
    extends _$StockMovementRequestCopyWithImpl<$Res, _$StockMovementRequestImpl>
    implements _$$StockMovementRequestImplCopyWith<$Res> {
  __$$StockMovementRequestImplCopyWithImpl(
    _$StockMovementRequestImpl _value,
    $Res Function(_$StockMovementRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMovementRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? variantId = freezed,
    Object? ingredientId = freezed,
    Object? movementType = null,
    Object? quantity = null,
    Object? previousQuantity = null,
    Object? newQuantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
  }) {
    return _then(
      _$StockMovementRequestImpl(
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int?,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        ingredientId: freezed == ingredientId
            ? _value.ingredientId
            : ingredientId // ignore: cast_nullable_to_non_nullable
                  as int?,
        movementType: null == movementType
            ? _value.movementType
            : movementType // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        previousQuantity: null == previousQuantity
            ? _value.previousQuantity
            : previousQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        newQuantity: null == newQuantity
            ? _value.newQuantity
            : newQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceType: freezed == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$StockMovementRequestImpl implements _StockMovementRequest {
  const _$StockMovementRequestImpl({
    required this.productId,
    required this.variantId,
    required this.ingredientId,
    required this.movementType,
    required this.quantity,
    required this.previousQuantity,
    required this.newQuantity,
    required this.reason,
    this.referenceId,
    this.referenceType,
  });

  @override
  final int? productId;
  @override
  final int? variantId;
  @override
  final int? ingredientId;
  @override
  final String movementType;
  @override
  final int quantity;
  @override
  final int previousQuantity;
  @override
  final int newQuantity;
  @override
  final String reason;
  @override
  final String? referenceId;
  @override
  final String? referenceType;

  @override
  String toString() {
    return 'StockMovementRequest(productId: $productId, variantId: $variantId, ingredientId: $ingredientId, movementType: $movementType, quantity: $quantity, previousQuantity: $previousQuantity, newQuantity: $newQuantity, reason: $reason, referenceId: $referenceId, referenceType: $referenceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMovementRequestImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.movementType, movementType) ||
                other.movementType == movementType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.newQuantity, newQuantity) ||
                other.newQuantity == newQuantity) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    variantId,
    ingredientId,
    movementType,
    quantity,
    previousQuantity,
    newQuantity,
    reason,
    referenceId,
    referenceType,
  );

  /// Create a copy of StockMovementRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMovementRequestImplCopyWith<_$StockMovementRequestImpl>
  get copyWith =>
      __$$StockMovementRequestImplCopyWithImpl<_$StockMovementRequestImpl>(
        this,
        _$identity,
      );
}

abstract class _StockMovementRequest implements StockMovementRequest {
  const factory _StockMovementRequest({
    required final int? productId,
    required final int? variantId,
    required final int? ingredientId,
    required final String movementType,
    required final int quantity,
    required final int previousQuantity,
    required final int newQuantity,
    required final String reason,
    final String? referenceId,
    final String? referenceType,
  }) = _$StockMovementRequestImpl;

  @override
  int? get productId;
  @override
  int? get variantId;
  @override
  int? get ingredientId;
  @override
  String get movementType;
  @override
  int get quantity;
  @override
  int get previousQuantity;
  @override
  int get newQuantity;
  @override
  String get reason;
  @override
  String? get referenceId;
  @override
  String? get referenceType;

  /// Create a copy of StockMovementRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMovementRequestImplCopyWith<_$StockMovementRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
