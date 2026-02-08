import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_settings.freezed.dart';

@freezed
class PrinterSettings with _$PrinterSettings {
  const factory PrinterSettings({
    required int id,
    required String printerType,
    String? bluetoothAddress,
    required int paperWidth,
    required String fontSize,
    required bool autoPrint,
    required int copies,
    required bool showHeader,
    required bool showFooter,
    required bool showBarcode,
    required DateTime updatedAt,
  }) = _PrinterSettings;
}
