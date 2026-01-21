// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Order {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get customerAddress => throw _privateConstructorUsedError;
  int get subtotal => throw _privateConstructorUsedError;
  int get taxAmount => throw _privateConstructorUsedError;
  int get discountAmount => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  int get paidAmount => throw _privateConstructorUsedError;
  int get changeAmount => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'paid', 'cancelled', 'refunded'
  String get paymentStatus =>
      throw _privateConstructorUsedError; // 'unpaid', 'partial', 'paid', 'refunded'
  String? get paymentMethod =>
      throw _privateConstructorUsedError; // 'cash', 'card', 'transfer', 'ewallet'
  String? get notes => throw _privateConstructorUsedError;
  DateTime get orderDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get syncStatus =>
      throw _privateConstructorUsedError; // Additional fields for POS
  List<OrderItem>? get items => throw _privateConstructorUsedError;
  List<Payment>? get payments => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    int id,
    String uuid,
    String orderNumber,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    int subtotal,
    int taxAmount,
    int discountAmount,
    int totalAmount,
    int paidAmount,
    int changeAmount,
    String status,
    String paymentStatus,
    String? paymentMethod,
    String? notes,
    DateTime orderDate,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
    List<OrderItem>? items,
    List<Payment>? payments,
  });
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? customerAddress = freezed,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? changeAmount = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? notes = freezed,
    Object? orderDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
    Object? items = freezed,
    Object? payments = freezed,
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
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerEmail: freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerAddress: freezed == customerAddress
                ? _value.customerAddress
                : customerAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as int,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            changeAmount: null == changeAmount
                ? _value.changeAmount
                : changeAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderDate: null == orderDate
                ? _value.orderDate
                : orderDate // ignore: cast_nullable_to_non_nullable
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
            items: freezed == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>?,
            payments: freezed == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<Payment>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    String orderNumber,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    int subtotal,
    int taxAmount,
    int discountAmount,
    int totalAmount,
    int paidAmount,
    int changeAmount,
    String status,
    String paymentStatus,
    String? paymentMethod,
    String? notes,
    DateTime orderDate,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
    List<OrderItem>? items,
    List<Payment>? payments,
  });
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? customerAddress = freezed,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? changeAmount = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? notes = freezed,
    Object? orderDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
    Object? items = freezed,
    Object? payments = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerEmail: freezed == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerAddress: freezed == customerAddress
            ? _value.customerAddress
            : customerAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as int,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        changeAmount: null == changeAmount
            ? _value.changeAmount
            : changeAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderDate: null == orderDate
            ? _value.orderDate
            : orderDate // ignore: cast_nullable_to_non_nullable
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
        items: freezed == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>?,
        payments: freezed == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<Payment>?,
      ),
    );
  }
}

/// @nodoc

class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    required this.uuid,
    required this.orderNumber,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.customerAddress,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.notes,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
    final List<OrderItem>? items,
    final List<Payment>? payments,
  }) : _items = items,
       _payments = payments;

  @override
  final int id;
  @override
  final String uuid;
  @override
  final String orderNumber;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? customerEmail;
  @override
  final String? customerAddress;
  @override
  final int subtotal;
  @override
  final int taxAmount;
  @override
  final int discountAmount;
  @override
  final int totalAmount;
  @override
  final int paidAmount;
  @override
  final int changeAmount;
  @override
  final String status;
  // 'pending', 'paid', 'cancelled', 'refunded'
  @override
  final String paymentStatus;
  // 'unpaid', 'partial', 'paid', 'refunded'
  @override
  final String? paymentMethod;
  // 'cash', 'card', 'transfer', 'ewallet'
  @override
  final String? notes;
  @override
  final DateTime orderDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;
  @override
  final String syncStatus;
  // Additional fields for POS
  final List<OrderItem>? _items;
  // Additional fields for POS
  @override
  List<OrderItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Payment>? _payments;
  @override
  List<Payment>? get payments {
    final value = _payments;
    if (value == null) return null;
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Order(id: $id, uuid: $uuid, orderNumber: $orderNumber, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, customerAddress: $customerAddress, subtotal: $subtotal, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, paidAmount: $paidAmount, changeAmount: $changeAmount, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, notes: $notes, orderDate: $orderDate, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, syncStatus: $syncStatus, items: $items, payments: $payments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._payments, _payments));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    uuid,
    orderNumber,
    customerName,
    customerPhone,
    customerEmail,
    customerAddress,
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    paidAmount,
    changeAmount,
    status,
    paymentStatus,
    paymentMethod,
    notes,
    orderDate,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_payments),
  ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);
}

abstract class _Order implements Order {
  const factory _Order({
    required final int id,
    required final String uuid,
    required final String orderNumber,
    final String? customerName,
    final String? customerPhone,
    final String? customerEmail,
    final String? customerAddress,
    required final int subtotal,
    required final int taxAmount,
    required final int discountAmount,
    required final int totalAmount,
    required final int paidAmount,
    required final int changeAmount,
    required final String status,
    required final String paymentStatus,
    final String? paymentMethod,
    final String? notes,
    required final DateTime orderDate,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final bool isDeleted,
    required final String syncStatus,
    final List<OrderItem>? items,
    final List<Payment>? payments,
  }) = _$OrderImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  String get orderNumber;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get customerEmail;
  @override
  String? get customerAddress;
  @override
  int get subtotal;
  @override
  int get taxAmount;
  @override
  int get discountAmount;
  @override
  int get totalAmount;
  @override
  int get paidAmount;
  @override
  int get changeAmount;
  @override
  String get status; // 'pending', 'paid', 'cancelled', 'refunded'
  @override
  String get paymentStatus; // 'unpaid', 'partial', 'paid', 'refunded'
  @override
  String? get paymentMethod; // 'cash', 'card', 'transfer', 'ewallet'
  @override
  String? get notes;
  @override
  DateTime get orderDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get syncStatus; // Additional fields for POS
  @override
  List<OrderItem>? get items;
  @override
  List<Payment>? get payments;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderItem {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  int get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get unitPrice => throw _privateConstructorUsedError;
  int get totalPrice => throw _privateConstructorUsedError;
  int get discountAmount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get syncStatus =>
      throw _privateConstructorUsedError; // Additional fields for POS
  Product? get product => throw _privateConstructorUsedError;
  Variant? get variant =>
      throw _privateConstructorUsedError; // Cart item specific fields
  Map<String, dynamic>? get customizations =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    int id,
    String uuid,
    int orderId,
    int productId,
    int? variantId,
    String productName,
    String? variantName,
    int quantity,
    int unitPrice,
    int totalPrice,
    int discountAmount,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
    Product? product,
    Variant? variant,
    Map<String, dynamic>? customizations,
  });

  $ProductCopyWith<$Res>? get product;
  $VariantCopyWith<$Res>? get variant;
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? orderId = null,
    Object? productId = null,
    Object? variantId = freezed,
    Object? productName = null,
    Object? variantName = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? discountAmount = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
    Object? product = freezed,
    Object? variant = freezed,
    Object? customizations = freezed,
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
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            variantName: freezed == variantName
                ? _value.variantName
                : variantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as int,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Product?,
            variant: freezed == variant
                ? _value.variant
                : variant // ignore: cast_nullable_to_non_nullable
                      as Variant?,
            customizations: freezed == customizations
                ? _value.customizations
                : customizations // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $ProductCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VariantCopyWith<$Res>? get variant {
    if (_value.variant == null) {
      return null;
    }

    return $VariantCopyWith<$Res>(_value.variant!, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    int orderId,
    int productId,
    int? variantId,
    String productName,
    String? variantName,
    int quantity,
    int unitPrice,
    int totalPrice,
    int discountAmount,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
    Product? product,
    Variant? variant,
    Map<String, dynamic>? customizations,
  });

  @override
  $ProductCopyWith<$Res>? get product;
  @override
  $VariantCopyWith<$Res>? get variant;
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? orderId = null,
    Object? productId = null,
    Object? variantId = freezed,
    Object? productName = null,
    Object? variantName = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? discountAmount = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
    Object? product = freezed,
    Object? variant = freezed,
    Object? customizations = freezed,
  }) {
    return _then(
      _$OrderItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        variantName: freezed == variantName
            ? _value.variantName
            : variantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as int,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
        product: freezed == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product?,
        variant: freezed == variant
            ? _value.variant
            : variant // ignore: cast_nullable_to_non_nullable
                  as Variant?,
        customizations: freezed == customizations
            ? _value._customizations
            : customizations // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    required this.uuid,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.productName,
    this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.discountAmount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
    this.product,
    this.variant,
    final Map<String, dynamic>? customizations,
  }) : _customizations = customizations;

  @override
  final int id;
  @override
  final String uuid;
  @override
  final int orderId;
  @override
  final int productId;
  @override
  final int? variantId;
  @override
  final String productName;
  @override
  final String? variantName;
  @override
  final int quantity;
  @override
  final int unitPrice;
  @override
  final int totalPrice;
  @override
  final int discountAmount;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool isDeleted;
  @override
  final String syncStatus;
  // Additional fields for POS
  @override
  final Product? product;
  @override
  final Variant? variant;
  // Cart item specific fields
  final Map<String, dynamic>? _customizations;
  // Cart item specific fields
  @override
  Map<String, dynamic>? get customizations {
    final value = _customizations;
    if (value == null) return null;
    if (_customizations is EqualUnmodifiableMapView) return _customizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'OrderItem(id: $id, uuid: $uuid, orderId: $orderId, productId: $productId, variantId: $variantId, productName: $productName, variantName: $variantName, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, discountAmount: $discountAmount, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, syncStatus: $syncStatus, product: $product, variant: $variant, customizations: $customizations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            const DeepCollectionEquality().equals(
              other._customizations,
              _customizations,
            ));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    uuid,
    orderId,
    productId,
    variantId,
    productName,
    variantName,
    quantity,
    unitPrice,
    totalPrice,
    discountAmount,
    notes,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
    product,
    variant,
    const DeepCollectionEquality().hash(_customizations),
  ]);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    required final int id,
    required final String uuid,
    required final int orderId,
    required final int productId,
    final int? variantId,
    required final String productName,
    final String? variantName,
    required final int quantity,
    required final int unitPrice,
    required final int totalPrice,
    required final int discountAmount,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final bool isDeleted,
    required final String syncStatus,
    final Product? product,
    final Variant? variant,
    final Map<String, dynamic>? customizations,
  }) = _$OrderItemImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  int get orderId;
  @override
  int get productId;
  @override
  int? get variantId;
  @override
  String get productName;
  @override
  String? get variantName;
  @override
  int get quantity;
  @override
  int get unitPrice;
  @override
  int get totalPrice;
  @override
  int get discountAmount;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get syncStatus; // Additional fields for POS
  @override
  Product? get product;
  @override
  Variant? get variant; // Cart item specific fields
  @override
  Map<String, dynamic>? get customizations;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Payment {
  int get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  String get paymentMethod =>
      throw _privateConstructorUsedError; // 'cash', 'card', 'transfer', 'ewallet'
  int get amount => throw _privateConstructorUsedError;
  String? get reference =>
      throw _privateConstructorUsedError; // Card number, transfer reference, etc.
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'completed', 'failed', 'refunded'
  String? get gateway =>
      throw _privateConstructorUsedError; // Payment gateway used
  String? get gatewayTransactionId => throw _privateConstructorUsedError;
  DateTime get paymentDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({
    int id,
    String uuid,
    int orderId,
    String paymentMethod,
    int amount,
    String? reference,
    String status,
    String? gateway,
    String? gatewayTransactionId,
    DateTime paymentDate,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? orderId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? reference = freezed,
    Object? status = null,
    Object? gateway = freezed,
    Object? gatewayTransactionId = freezed,
    Object? paymentDate = null,
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
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            reference: freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            gateway: freezed == gateway
                ? _value.gateway
                : gateway // ignore: cast_nullable_to_non_nullable
                      as String?,
            gatewayTransactionId: freezed == gatewayTransactionId
                ? _value.gatewayTransactionId
                : gatewayTransactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentDate: null == paymentDate
                ? _value.paymentDate
                : paymentDate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String uuid,
    int orderId,
    String paymentMethod,
    int amount,
    String? reference,
    String status,
    String? gateway,
    String? gatewayTransactionId,
    DateTime paymentDate,
    DateTime createdAt,
    DateTime updatedAt,
    bool isDeleted,
    String syncStatus,
  });
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? orderId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? reference = freezed,
    Object? status = null,
    Object? gateway = freezed,
    Object? gatewayTransactionId = freezed,
    Object? paymentDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _$PaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        reference: freezed == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        gateway: freezed == gateway
            ? _value.gateway
            : gateway // ignore: cast_nullable_to_non_nullable
                  as String?,
        gatewayTransactionId: freezed == gatewayTransactionId
            ? _value.gatewayTransactionId
            : gatewayTransactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentDate: null == paymentDate
            ? _value.paymentDate
            : paymentDate // ignore: cast_nullable_to_non_nullable
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

class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({
    required this.id,
    required this.uuid,
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    this.reference,
    required this.status,
    this.gateway,
    this.gatewayTransactionId,
    required this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.syncStatus,
  });

  @override
  final int id;
  @override
  final String uuid;
  @override
  final int orderId;
  @override
  final String paymentMethod;
  // 'cash', 'card', 'transfer', 'ewallet'
  @override
  final int amount;
  @override
  final String? reference;
  // Card number, transfer reference, etc.
  @override
  final String status;
  // 'pending', 'completed', 'failed', 'refunded'
  @override
  final String? gateway;
  // Payment gateway used
  @override
  final String? gatewayTransactionId;
  @override
  final DateTime paymentDate;
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
    return 'Payment(id: $id, uuid: $uuid, orderId: $orderId, paymentMethod: $paymentMethod, amount: $amount, reference: $reference, status: $status, gateway: $gateway, gatewayTransactionId: $gatewayTransactionId, paymentDate: $paymentDate, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.gateway, gateway) || other.gateway == gateway) &&
            (identical(other.gatewayTransactionId, gatewayTransactionId) ||
                other.gatewayTransactionId == gatewayTransactionId) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
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
    orderId,
    paymentMethod,
    amount,
    reference,
    status,
    gateway,
    gatewayTransactionId,
    paymentDate,
    createdAt,
    updatedAt,
    isDeleted,
    syncStatus,
  );

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);
}

abstract class _Payment implements Payment {
  const factory _Payment({
    required final int id,
    required final String uuid,
    required final int orderId,
    required final String paymentMethod,
    required final int amount,
    final String? reference,
    required final String status,
    final String? gateway,
    final String? gatewayTransactionId,
    required final DateTime paymentDate,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final bool isDeleted,
    required final String syncStatus,
  }) = _$PaymentImpl;

  @override
  int get id;
  @override
  String get uuid;
  @override
  int get orderId;
  @override
  String get paymentMethod; // 'cash', 'card', 'transfer', 'ewallet'
  @override
  int get amount;
  @override
  String? get reference; // Card number, transfer reference, etc.
  @override
  String get status; // 'pending', 'completed', 'failed', 'refunded'
  @override
  String? get gateway; // Payment gateway used
  @override
  String? get gatewayTransactionId;
  @override
  DateTime get paymentDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get syncStatus;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Cart {
  String get id => throw _privateConstructorUsedError;
  List<CartItem> get items => throw _privateConstructorUsedError;
  int get subtotal => throw _privateConstructorUsedError;
  int get taxAmount => throw _privateConstructorUsedError;
  int get discountAmount => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call({
    String id,
    List<CartItem> items,
    int subtotal,
    int taxAmount,
    int discountAmount,
    int totalAmount,
    String? customerName,
    String? customerPhone,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as int,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
    _$CartImpl value,
    $Res Function(_$CartImpl) then,
  ) = __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    List<CartItem> items,
    int subtotal,
    int taxAmount,
    int discountAmount,
    int totalAmount,
    String? customerName,
    String? customerPhone,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
    : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CartImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as int,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$CartImpl implements _Cart {
  const _$CartImpl({
    required this.id,
    required final List<CartItem> items,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.customerName,
    this.customerPhone,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  }) : _items = items;

  @override
  final String id;
  final List<CartItem> _items;
  @override
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int subtotal;
  @override
  final int taxAmount;
  @override
  final int discountAmount;
  @override
  final int totalAmount;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Cart(id: $id, items: $items, subtotal: $subtotal, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, customerName: $customerName, customerPhone: $customerPhone, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    customerName,
    customerPhone,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);
}

abstract class _Cart implements Cart {
  const factory _Cart({
    required final String id,
    required final List<CartItem> items,
    required final int subtotal,
    required final int taxAmount,
    required final int discountAmount,
    required final int totalAmount,
    final String? customerName,
    final String? customerPhone,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$CartImpl;

  @override
  String get id;
  @override
  List<CartItem> get items;
  @override
  int get subtotal;
  @override
  int get taxAmount;
  @override
  int get discountAmount;
  @override
  int get totalAmount;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CartItem {
  String get id => throw _privateConstructorUsedError;
  int get productId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get unitPrice => throw _privateConstructorUsedError;
  int get totalPrice => throw _privateConstructorUsedError;
  int get discountAmount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customizations =>
      throw _privateConstructorUsedError; // For size, sugar level, ice amount, toppings
  Product? get product => throw _privateConstructorUsedError;
  Variant? get variant => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({
    String id,
    int productId,
    int? variantId,
    String productName,
    String? variantName,
    int quantity,
    int unitPrice,
    int totalPrice,
    int discountAmount,
    String? notes,
    Map<String, dynamic>? customizations,
    Product? product,
    Variant? variant,
  });

  $ProductCopyWith<$Res>? get product;
  $VariantCopyWith<$Res>? get variant;
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variantId = freezed,
    Object? productName = null,
    Object? variantName = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? discountAmount = null,
    Object? notes = freezed,
    Object? customizations = freezed,
    Object? product = freezed,
    Object? variant = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int,
            variantId: freezed == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            variantName: freezed == variantName
                ? _value.variantName
                : variantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as int,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            customizations: freezed == customizations
                ? _value.customizations
                : customizations // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Product?,
            variant: freezed == variant
                ? _value.variant
                : variant // ignore: cast_nullable_to_non_nullable
                      as Variant?,
          )
          as $Val,
    );
  }

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $ProductCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VariantCopyWith<$Res>? get variant {
    if (_value.variant == null) {
      return null;
    }

    return $VariantCopyWith<$Res>(_value.variant!, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
    _$CartItemImpl value,
    $Res Function(_$CartItemImpl) then,
  ) = __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int productId,
    int? variantId,
    String productName,
    String? variantName,
    int quantity,
    int unitPrice,
    int totalPrice,
    int discountAmount,
    String? notes,
    Map<String, dynamic>? customizations,
    Product? product,
    Variant? variant,
  });

  @override
  $ProductCopyWith<$Res>? get product;
  @override
  $VariantCopyWith<$Res>? get variant;
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
    _$CartItemImpl _value,
    $Res Function(_$CartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? variantId = freezed,
    Object? productName = null,
    Object? variantName = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? discountAmount = null,
    Object? notes = freezed,
    Object? customizations = freezed,
    Object? product = freezed,
    Object? variant = freezed,
  }) {
    return _then(
      _$CartItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int,
        variantId: freezed == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        variantName: freezed == variantName
            ? _value.variantName
            : variantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as int,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        customizations: freezed == customizations
            ? _value._customizations
            : customizations // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        product: freezed == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product?,
        variant: freezed == variant
            ? _value.variant
            : variant // ignore: cast_nullable_to_non_nullable
                  as Variant?,
      ),
    );
  }
}

/// @nodoc

class _$CartItemImpl implements _CartItem {
  const _$CartItemImpl({
    required this.id,
    required this.productId,
    this.variantId,
    required this.productName,
    this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.discountAmount,
    this.notes,
    final Map<String, dynamic>? customizations,
    this.product,
    this.variant,
  }) : _customizations = customizations;

  @override
  final String id;
  @override
  final int productId;
  @override
  final int? variantId;
  @override
  final String productName;
  @override
  final String? variantName;
  @override
  final int quantity;
  @override
  final int unitPrice;
  @override
  final int totalPrice;
  @override
  final int discountAmount;
  @override
  final String? notes;
  final Map<String, dynamic>? _customizations;
  @override
  Map<String, dynamic>? get customizations {
    final value = _customizations;
    if (value == null) return null;
    if (_customizations is EqualUnmodifiableMapView) return _customizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // For size, sugar level, ice amount, toppings
  @override
  final Product? product;
  @override
  final Variant? variant;

  @override
  String toString() {
    return 'CartItem(id: $id, productId: $productId, variantId: $variantId, productName: $productName, variantName: $variantName, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, discountAmount: $discountAmount, notes: $notes, customizations: $customizations, product: $product, variant: $variant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._customizations,
              _customizations,
            ) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.variant, variant) || other.variant == variant));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    variantId,
    productName,
    variantName,
    quantity,
    unitPrice,
    totalPrice,
    discountAmount,
    notes,
    const DeepCollectionEquality().hash(_customizations),
    product,
    variant,
  );

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);
}

abstract class _CartItem implements CartItem {
  const factory _CartItem({
    required final String id,
    required final int productId,
    final int? variantId,
    required final String productName,
    final String? variantName,
    required final int quantity,
    required final int unitPrice,
    required final int totalPrice,
    required final int discountAmount,
    final String? notes,
    final Map<String, dynamic>? customizations,
    final Product? product,
    final Variant? variant,
  }) = _$CartItemImpl;

  @override
  String get id;
  @override
  int get productId;
  @override
  int? get variantId;
  @override
  String get productName;
  @override
  String? get variantName;
  @override
  int get quantity;
  @override
  int get unitPrice;
  @override
  int get totalPrice;
  @override
  int get discountAmount;
  @override
  String? get notes;
  @override
  Map<String, dynamic>? get customizations; // For size, sugar level, ice amount, toppings
  @override
  Product? get product;
  @override
  Variant? get variant;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CartItemCustomization {
  String get type =>
      throw _privateConstructorUsedError; // 'size', 'sugar', 'ice', 'topping'
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  int get priceAdjustment => throw _privateConstructorUsedError;

  /// Create a copy of CartItemCustomization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCustomizationCopyWith<CartItemCustomization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCustomizationCopyWith<$Res> {
  factory $CartItemCustomizationCopyWith(
    CartItemCustomization value,
    $Res Function(CartItemCustomization) then,
  ) = _$CartItemCustomizationCopyWithImpl<$Res, CartItemCustomization>;
  @useResult
  $Res call({String type, String name, String value, int priceAdjustment});
}

/// @nodoc
class _$CartItemCustomizationCopyWithImpl<
  $Res,
  $Val extends CartItemCustomization
>
    implements $CartItemCustomizationCopyWith<$Res> {
  _$CartItemCustomizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItemCustomization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? value = null,
    Object? priceAdjustment = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            priceAdjustment: null == priceAdjustment
                ? _value.priceAdjustment
                : priceAdjustment // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartItemCustomizationImplCopyWith<$Res>
    implements $CartItemCustomizationCopyWith<$Res> {
  factory _$$CartItemCustomizationImplCopyWith(
    _$CartItemCustomizationImpl value,
    $Res Function(_$CartItemCustomizationImpl) then,
  ) = __$$CartItemCustomizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String name, String value, int priceAdjustment});
}

/// @nodoc
class __$$CartItemCustomizationImplCopyWithImpl<$Res>
    extends
        _$CartItemCustomizationCopyWithImpl<$Res, _$CartItemCustomizationImpl>
    implements _$$CartItemCustomizationImplCopyWith<$Res> {
  __$$CartItemCustomizationImplCopyWithImpl(
    _$CartItemCustomizationImpl _value,
    $Res Function(_$CartItemCustomizationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItemCustomization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? value = null,
    Object? priceAdjustment = null,
  }) {
    return _then(
      _$CartItemCustomizationImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        priceAdjustment: null == priceAdjustment
            ? _value.priceAdjustment
            : priceAdjustment // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CartItemCustomizationImpl implements _CartItemCustomization {
  const _$CartItemCustomizationImpl({
    required this.type,
    required this.name,
    required this.value,
    required this.priceAdjustment,
  });

  @override
  final String type;
  // 'size', 'sugar', 'ice', 'topping'
  @override
  final String name;
  @override
  final String value;
  @override
  final int priceAdjustment;

  @override
  String toString() {
    return 'CartItemCustomization(type: $type, name: $name, value: $value, priceAdjustment: $priceAdjustment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemCustomizationImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.priceAdjustment, priceAdjustment) ||
                other.priceAdjustment == priceAdjustment));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, type, name, value, priceAdjustment);

  /// Create a copy of CartItemCustomization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemCustomizationImplCopyWith<_$CartItemCustomizationImpl>
  get copyWith =>
      __$$CartItemCustomizationImplCopyWithImpl<_$CartItemCustomizationImpl>(
        this,
        _$identity,
      );
}

abstract class _CartItemCustomization implements CartItemCustomization {
  const factory _CartItemCustomization({
    required final String type,
    required final String name,
    required final String value,
    required final int priceAdjustment,
  }) = _$CartItemCustomizationImpl;

  @override
  String get type; // 'size', 'sugar', 'ice', 'topping'
  @override
  String get name;
  @override
  String get value;
  @override
  int get priceAdjustment;

  /// Create a copy of CartItemCustomization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemCustomizationImplCopyWith<_$CartItemCustomizationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionRequest {
  List<CartItem> get items => throw _privateConstructorUsedError;
  int get subtotal => throw _privateConstructorUsedError;
  int get taxAmount => throw _privateConstructorUsedError;
  int get discountAmount => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  List<PaymentRequest> get payments => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get customerAddress => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of TransactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionRequestCopyWith<TransactionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionRequestCopyWith<$Res> {
  factory $TransactionRequestCopyWith(
    TransactionRequest value,
    $Res Function(TransactionRequest) then,
  ) = _$TransactionRequestCopyWithImpl<$Res, TransactionRequest>;
  @useResult
  $Res call({
    List<CartItem> items,
    int subtotal,
    int taxAmount,
    int discountAmount,
    int totalAmount,
    List<PaymentRequest> payments,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    String? notes,
  });
}

/// @nodoc
class _$TransactionRequestCopyWithImpl<$Res, $Val extends TransactionRequest>
    implements $TransactionRequestCopyWith<$Res> {
  _$TransactionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? payments = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? customerAddress = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as int,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<PaymentRequest>,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerEmail: freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerAddress: freezed == customerAddress
                ? _value.customerAddress
                : customerAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionRequestImplCopyWith<$Res>
    implements $TransactionRequestCopyWith<$Res> {
  factory _$$TransactionRequestImplCopyWith(
    _$TransactionRequestImpl value,
    $Res Function(_$TransactionRequestImpl) then,
  ) = __$$TransactionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CartItem> items,
    int subtotal,
    int taxAmount,
    int discountAmount,
    int totalAmount,
    List<PaymentRequest> payments,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    String? notes,
  });
}

/// @nodoc
class __$$TransactionRequestImplCopyWithImpl<$Res>
    extends _$TransactionRequestCopyWithImpl<$Res, _$TransactionRequestImpl>
    implements _$$TransactionRequestImplCopyWith<$Res> {
  __$$TransactionRequestImplCopyWithImpl(
    _$TransactionRequestImpl _value,
    $Res Function(_$TransactionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? payments = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? customerAddress = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$TransactionRequestImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as int,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<PaymentRequest>,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerEmail: freezed == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerAddress: freezed == customerAddress
            ? _value.customerAddress
            : customerAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TransactionRequestImpl implements _TransactionRequest {
  const _$TransactionRequestImpl({
    required final List<CartItem> items,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required final List<PaymentRequest> payments,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.customerAddress,
    this.notes,
  }) : _items = items,
       _payments = payments;

  final List<CartItem> _items;
  @override
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int subtotal;
  @override
  final int taxAmount;
  @override
  final int discountAmount;
  @override
  final int totalAmount;
  final List<PaymentRequest> _payments;
  @override
  List<PaymentRequest> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? customerEmail;
  @override
  final String? customerAddress;
  @override
  final String? notes;

  @override
  String toString() {
    return 'TransactionRequest(items: $items, subtotal: $subtotal, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, payments: $payments, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, customerAddress: $customerAddress, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionRequestImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    const DeepCollectionEquality().hash(_payments),
    customerName,
    customerPhone,
    customerEmail,
    customerAddress,
    notes,
  );

  /// Create a copy of TransactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionRequestImplCopyWith<_$TransactionRequestImpl> get copyWith =>
      __$$TransactionRequestImplCopyWithImpl<_$TransactionRequestImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionRequest implements TransactionRequest {
  const factory _TransactionRequest({
    required final List<CartItem> items,
    required final int subtotal,
    required final int taxAmount,
    required final int discountAmount,
    required final int totalAmount,
    required final List<PaymentRequest> payments,
    final String? customerName,
    final String? customerPhone,
    final String? customerEmail,
    final String? customerAddress,
    final String? notes,
  }) = _$TransactionRequestImpl;

  @override
  List<CartItem> get items;
  @override
  int get subtotal;
  @override
  int get taxAmount;
  @override
  int get discountAmount;
  @override
  int get totalAmount;
  @override
  List<PaymentRequest> get payments;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get customerEmail;
  @override
  String? get customerAddress;
  @override
  String? get notes;

  /// Create a copy of TransactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionRequestImplCopyWith<_$TransactionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaymentRequest {
  String get paymentMethod => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentRequestCopyWith<PaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentRequestCopyWith<$Res> {
  factory $PaymentRequestCopyWith(
    PaymentRequest value,
    $Res Function(PaymentRequest) then,
  ) = _$PaymentRequestCopyWithImpl<$Res, PaymentRequest>;
  @useResult
  $Res call({String paymentMethod, int amount, String? reference});
}

/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res, $Val extends PaymentRequest>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethod = null,
    Object? amount = null,
    Object? reference = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            reference: freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentRequestImplCopyWith<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  factory _$$PaymentRequestImplCopyWith(
    _$PaymentRequestImpl value,
    $Res Function(_$PaymentRequestImpl) then,
  ) = __$$PaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String paymentMethod, int amount, String? reference});
}

/// @nodoc
class __$$PaymentRequestImplCopyWithImpl<$Res>
    extends _$PaymentRequestCopyWithImpl<$Res, _$PaymentRequestImpl>
    implements _$$PaymentRequestImplCopyWith<$Res> {
  __$$PaymentRequestImplCopyWithImpl(
    _$PaymentRequestImpl _value,
    $Res Function(_$PaymentRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethod = null,
    Object? amount = null,
    Object? reference = freezed,
  }) {
    return _then(
      _$PaymentRequestImpl(
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        reference: freezed == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PaymentRequestImpl implements _PaymentRequest {
  const _$PaymentRequestImpl({
    required this.paymentMethod,
    required this.amount,
    this.reference,
  });

  @override
  final String paymentMethod;
  @override
  final int amount;
  @override
  final String? reference;

  @override
  String toString() {
    return 'PaymentRequest(paymentMethod: $paymentMethod, amount: $amount, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentRequestImpl &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentMethod, amount, reference);

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      __$$PaymentRequestImplCopyWithImpl<_$PaymentRequestImpl>(
        this,
        _$identity,
      );
}

abstract class _PaymentRequest implements PaymentRequest {
  const factory _PaymentRequest({
    required final String paymentMethod,
    required final int amount,
    final String? reference,
  }) = _$PaymentRequestImpl;

  @override
  String get paymentMethod;
  @override
  int get amount;
  @override
  String? get reference;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionResult {
  bool get success => throw _privateConstructorUsedError;
  Order? get order => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get errorCode => throw _privateConstructorUsedError;

  /// Create a copy of TransactionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionResultCopyWith<TransactionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionResultCopyWith<$Res> {
  factory $TransactionResultCopyWith(
    TransactionResult value,
    $Res Function(TransactionResult) then,
  ) = _$TransactionResultCopyWithImpl<$Res, TransactionResult>;
  @useResult
  $Res call({bool success, Order? order, String? error, String? errorCode});

  $OrderCopyWith<$Res>? get order;
}

/// @nodoc
class _$TransactionResultCopyWithImpl<$Res, $Val extends TransactionResult>
    implements $TransactionResultCopyWith<$Res> {
  _$TransactionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? order = freezed,
    Object? error = freezed,
    Object? errorCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as Order?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorCode: freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TransactionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $OrderCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionResultImplCopyWith<$Res>
    implements $TransactionResultCopyWith<$Res> {
  factory _$$TransactionResultImplCopyWith(
    _$TransactionResultImpl value,
    $Res Function(_$TransactionResultImpl) then,
  ) = __$$TransactionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, Order? order, String? error, String? errorCode});

  @override
  $OrderCopyWith<$Res>? get order;
}

/// @nodoc
class __$$TransactionResultImplCopyWithImpl<$Res>
    extends _$TransactionResultCopyWithImpl<$Res, _$TransactionResultImpl>
    implements _$$TransactionResultImplCopyWith<$Res> {
  __$$TransactionResultImplCopyWithImpl(
    _$TransactionResultImpl _value,
    $Res Function(_$TransactionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? order = freezed,
    Object? error = freezed,
    Object? errorCode = freezed,
  }) {
    return _then(
      _$TransactionResultImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as Order?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorCode: freezed == errorCode
            ? _value.errorCode
            : errorCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TransactionResultImpl implements _TransactionResult {
  const _$TransactionResultImpl({
    required this.success,
    required this.order,
    required this.error,
    required this.errorCode,
  });

  @override
  final bool success;
  @override
  final Order? order;
  @override
  final String? error;
  @override
  final String? errorCode;

  @override
  String toString() {
    return 'TransactionResult(success: $success, order: $order, error: $error, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, success, order, error, errorCode);

  /// Create a copy of TransactionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionResultImplCopyWith<_$TransactionResultImpl> get copyWith =>
      __$$TransactionResultImplCopyWithImpl<_$TransactionResultImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionResult implements TransactionResult {
  const factory _TransactionResult({
    required final bool success,
    required final Order? order,
    required final String? error,
    required final String? errorCode,
  }) = _$TransactionResultImpl;

  @override
  bool get success;
  @override
  Order? get order;
  @override
  String? get error;
  @override
  String? get errorCode;

  /// Create a copy of TransactionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionResultImplCopyWith<_$TransactionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
