import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_settings.freezed.dart';

@freezed
class BusinessSettings with _$BusinessSettings {
  const factory BusinessSettings({
    required int id,
    required String storeName,
    required String address,
    required String phoneNumber,
    String? email,
    String? logoPath,
    String? taxNumber,
    required DateTime updatedAt,
  }) = _BusinessSettings;
}
