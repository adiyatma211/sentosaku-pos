// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BusinessSettings {
  int get id => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get logoPath => throw _privateConstructorUsedError;
  String? get taxNumber => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of BusinessSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessSettingsCopyWith<BusinessSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessSettingsCopyWith<$Res> {
  factory $BusinessSettingsCopyWith(
    BusinessSettings value,
    $Res Function(BusinessSettings) then,
  ) = _$BusinessSettingsCopyWithImpl<$Res, BusinessSettings>;
  @useResult
  $Res call({
    int id,
    String storeName,
    String address,
    String phoneNumber,
    String? email,
    String? logoPath,
    String? taxNumber,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$BusinessSettingsCopyWithImpl<$Res, $Val extends BusinessSettings>
    implements $BusinessSettingsCopyWith<$Res> {
  _$BusinessSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeName = null,
    Object? address = null,
    Object? phoneNumber = null,
    Object? email = freezed,
    Object? logoPath = freezed,
    Object? taxNumber = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            storeName: null == storeName
                ? _value.storeName
                : storeName // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoPath: freezed == logoPath
                ? _value.logoPath
                : logoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxNumber: freezed == taxNumber
                ? _value.taxNumber
                : taxNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$BusinessSettingsImplCopyWith<$Res>
    implements $BusinessSettingsCopyWith<$Res> {
  factory _$$BusinessSettingsImplCopyWith(
    _$BusinessSettingsImpl value,
    $Res Function(_$BusinessSettingsImpl) then,
  ) = __$$BusinessSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String storeName,
    String address,
    String phoneNumber,
    String? email,
    String? logoPath,
    String? taxNumber,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$BusinessSettingsImplCopyWithImpl<$Res>
    extends _$BusinessSettingsCopyWithImpl<$Res, _$BusinessSettingsImpl>
    implements _$$BusinessSettingsImplCopyWith<$Res> {
  __$$BusinessSettingsImplCopyWithImpl(
    _$BusinessSettingsImpl _value,
    $Res Function(_$BusinessSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeName = null,
    Object? address = null,
    Object? phoneNumber = null,
    Object? email = freezed,
    Object? logoPath = freezed,
    Object? taxNumber = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BusinessSettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        storeName: null == storeName
            ? _value.storeName
            : storeName // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoPath: freezed == logoPath
            ? _value.logoPath
            : logoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxNumber: freezed == taxNumber
            ? _value.taxNumber
            : taxNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$BusinessSettingsImpl implements _BusinessSettings {
  const _$BusinessSettingsImpl({
    required this.id,
    required this.storeName,
    required this.address,
    required this.phoneNumber,
    this.email,
    this.logoPath,
    this.taxNumber,
    required this.updatedAt,
  });

  @override
  final int id;
  @override
  final String storeName;
  @override
  final String address;
  @override
  final String phoneNumber;
  @override
  final String? email;
  @override
  final String? logoPath;
  @override
  final String? taxNumber;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BusinessSettings(id: $id, storeName: $storeName, address: $address, phoneNumber: $phoneNumber, email: $email, logoPath: $logoPath, taxNumber: $taxNumber, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.logoPath, logoPath) ||
                other.logoPath == logoPath) &&
            (identical(other.taxNumber, taxNumber) ||
                other.taxNumber == taxNumber) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    storeName,
    address,
    phoneNumber,
    email,
    logoPath,
    taxNumber,
    updatedAt,
  );

  /// Create a copy of BusinessSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessSettingsImplCopyWith<_$BusinessSettingsImpl> get copyWith =>
      __$$BusinessSettingsImplCopyWithImpl<_$BusinessSettingsImpl>(
        this,
        _$identity,
      );
}

abstract class _BusinessSettings implements BusinessSettings {
  const factory _BusinessSettings({
    required final int id,
    required final String storeName,
    required final String address,
    required final String phoneNumber,
    final String? email,
    final String? logoPath,
    final String? taxNumber,
    required final DateTime updatedAt,
  }) = _$BusinessSettingsImpl;

  @override
  int get id;
  @override
  String get storeName;
  @override
  String get address;
  @override
  String get phoneNumber;
  @override
  String? get email;
  @override
  String? get logoPath;
  @override
  String? get taxNumber;
  @override
  DateTime get updatedAt;

  /// Create a copy of BusinessSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessSettingsImplCopyWith<_$BusinessSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
