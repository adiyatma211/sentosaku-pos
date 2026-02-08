import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';
import '../../domain/entities/business_settings.dart' as entity;

class BusinessSettingsRepository {
  final AppDatabase _database;
  
  BusinessSettingsRepository(this._database);
  
  Future<List<entity.BusinessSettings>> getBusinessSettings() async {
    final settingsList = await _database.select(_database.businessSettingsTable).get();
    
    return settingsList.map(_mapToEntity).toList();
  }
  
  Future<entity.BusinessSettings?> getBusinessSettingsById(int id) async {
    final setting = await (_database.select(_database.businessSettingsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    
    return setting != null ? _mapToEntity(setting) : null;
  }
  
  Future<entity.BusinessSettings> saveBusinessSettings(entity.BusinessSettings settings) async {
    final settingsCompanion = BusinessSettingsTableCompanion.insert(
      storeName: settings.storeName,
      address: settings.address,
      phoneNumber: settings.phoneNumber,
      email: Value(settings.email),
      logoPath: Value(settings.logoPath),
      taxNumber: Value(settings.taxNumber),
    );
    
    final id = await _database.into(_database.businessSettingsTable).insert(settingsCompanion);
    final insertedSettings = await getBusinessSettingsById(id);
    
    if (insertedSettings == null) {
      throw Exception('Failed to save business settings');
    }
    
    return insertedSettings;
  }
  
  Future<entity.BusinessSettings> updateBusinessSettings(entity.BusinessSettings settings) async {
    final settingsCompanion = BusinessSettingsTableCompanion(
      storeName: Value(settings.storeName),
      address: Value(settings.address),
      phoneNumber: Value(settings.phoneNumber),
      email: Value(settings.email),
      logoPath: Value(settings.logoPath),
      taxNumber: Value(settings.taxNumber),
      updatedAt: Value(DateTime.now()),
    );
    
    await (_database.update(_database.businessSettingsTable)
        ..where((tbl) => tbl.id.equals(settings.id)))
        .write(settingsCompanion);
    
    final updatedSettings = await getBusinessSettingsById(settings.id);
    
    if (updatedSettings == null) {
      throw Exception('Failed to update business settings');
    }
    
    return updatedSettings;
  }
  
  Future<bool> deleteBusinessSettings(int id) async {
    await (_database.delete(_database.businessSettingsTable)
        ..where((tbl) => tbl.id.equals(id)))
        .go();
    
    return true;
  }
  
  entity.BusinessSettings _mapToEntity(BusinessSetting data) {
    return entity.BusinessSettings(
      id: data.id,
      storeName: data.storeName,
      address: data.address,
      phoneNumber: data.phoneNumber,
      email: data.email,
      logoPath: data.logoPath,
      taxNumber: data.taxNumber,
      updatedAt: data.updatedAt,
    );
  }
}
