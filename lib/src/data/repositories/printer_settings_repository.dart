import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';
import '../../domain/entities/printer_settings.dart' as entity;

class PrinterSettingsRepository {
  final AppDatabase _database;
  
  PrinterSettingsRepository(this._database);
  
  Future<List<entity.PrinterSettings>> getPrinterSettings() async {
    final settingsList = await _database.select(_database.printerSettingsTable).get();
    
    return settingsList.map(_mapToEntity).toList();
  }
  
  Future<entity.PrinterSettings?> getPrinterSettingsById(int id) async {
    final setting = await (_database.select(_database.printerSettingsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    
    return setting != null ? _mapToEntity(setting) : null;
  }
  
  Future<entity.PrinterSettings> savePrinterSettings(entity.PrinterSettings settings) async {
    final settingsCompanion = PrinterSettingsTableCompanion.insert(
      printerType: settings.printerType,
      bluetoothAddress: Value(settings.bluetoothAddress),
      paperWidth: Value(settings.paperWidth),
      fontSize: Value(settings.fontSize),
      autoPrint: Value(settings.autoPrint),
      copies: Value(settings.copies),
      showHeader: Value(settings.showHeader),
      showFooter: Value(settings.showFooter),
      showBarcode: Value(settings.showBarcode),
    );
    
    final id = await _database.into(_database.printerSettingsTable).insert(settingsCompanion);
    final insertedSettings = await getPrinterSettingsById(id);
    
    if (insertedSettings == null) {
      throw Exception('Failed to save printer settings');
    }
    
    return insertedSettings;
  }
  
  Future<entity.PrinterSettings> updatePrinterSettings(entity.PrinterSettings settings) async {
    final settingsCompanion = PrinterSettingsTableCompanion(
      printerType: Value(settings.printerType),
      bluetoothAddress: Value(settings.bluetoothAddress),
      paperWidth: Value(settings.paperWidth),
      fontSize: Value(settings.fontSize),
      autoPrint: Value(settings.autoPrint),
      copies: Value(settings.copies),
      showHeader: Value(settings.showHeader),
      showFooter: Value(settings.showFooter),
      showBarcode: Value(settings.showBarcode),
      updatedAt: Value(DateTime.now()),
    );
    
    await (_database.update(_database.printerSettingsTable)
        ..where((tbl) => tbl.id.equals(settings.id)))
        .write(settingsCompanion);
    
    final updatedSettings = await getPrinterSettingsById(settings.id);
    
    if (updatedSettings == null) {
      throw Exception('Failed to update printer settings');
    }
    
    return updatedSettings;
  }
  
  Future<bool> deletePrinterSettings(int id) async {
    await (_database.delete(_database.printerSettingsTable)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  entity.PrinterSettings _mapToEntity(PrinterSetting data) {
    return entity.PrinterSettings(
      id: data.id,
      printerType: data.printerType,
      bluetoothAddress: data.bluetoothAddress,
      paperWidth: data.paperWidth,
      fontSize: data.fontSize,
      autoPrint: data.autoPrint,
      copies: data.copies,
      showHeader: data.showHeader,
      showFooter: data.showFooter,
      showBarcode: data.showBarcode,
      updatedAt: data.updatedAt,
    );
  }
}
