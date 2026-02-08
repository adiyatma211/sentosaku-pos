import 'package:drift/drift.dart';

import '../app_database.dart';

part 'printer_settings_dao.g.dart';

@DriftAccessor(tables: [PrinterSettingsTable])
class PrinterSettingsDao extends DatabaseAccessor<AppDatabase> with _$PrinterSettingsDaoMixin {
  PrinterSettingsDao(super.db);

  // Get all printer settings
  Future<List<PrinterSetting>> getPrinterSettings() {
    return (select(printerSettingsTable)).get();
  }

  // Get printer settings by ID
  Future<PrinterSetting?> getPrinterSettingsById(int id) {
    return (select(printerSettingsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Save printer settings
  Future<PrinterSetting> savePrinterSettings(PrinterSettingsTableCompanion entry) async {
    return into(printerSettingsTable).insertReturning(
      PrinterSettingsTableCompanion.insert(
        printerType: entry.printerType.value,
        bluetoothAddress: entry.bluetoothAddress,
        paperWidth: entry.paperWidth,
        fontSize: entry.fontSize,
        autoPrint: entry.autoPrint,
        copies: entry.copies,
        showHeader: entry.showHeader,
        showFooter: entry.showFooter,
        showBarcode: entry.showBarcode,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Update printer settings
  Future<PrinterSetting> updatePrinterSettings(int id, PrinterSettingsTableCompanion entry) async {
    await (update(printerSettingsTable)..where((tbl) => tbl.id.equals(id)))
        .write(PrinterSettingsTableCompanion(
          printerType: entry.printerType,
          bluetoothAddress: entry.bluetoothAddress,
          paperWidth: entry.paperWidth,
          fontSize: entry.fontSize,
          autoPrint: entry.autoPrint,
          copies: entry.copies,
          showHeader: entry.showHeader,
          showFooter: entry.showFooter,
          showBarcode: entry.showBarcode,
          updatedAt: Value(DateTime.now()),
        ));
    
    final settings = await getPrinterSettingsById(id);
    if (settings == null) {
      throw Exception('Printer settings not found');
    }
    return settings;
  }

  // Delete printer settings
  Future<void> deletePrinterSettings(int id) async {
    await (delete(printerSettingsTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
