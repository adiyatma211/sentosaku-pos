import 'package:drift/drift.dart';

import '../app_database.dart';

part 'business_settings_dao.g.dart';

@DriftAccessor(tables: [BusinessSettingsTable])
class BusinessSettingsDao extends DatabaseAccessor<AppDatabase> with _$BusinessSettingsDaoMixin {
  BusinessSettingsDao(super.db);

  // Get all business settings
  Future<List<BusinessSetting>> getBusinessSettings() {
    return (select(businessSettingsTable)).get();
  }

  // Get business settings by ID
  Future<BusinessSetting?> getBusinessSettingsById(int id) {
    return (select(businessSettingsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Save business settings
  Future<BusinessSetting> saveBusinessSettings(BusinessSettingsTableCompanion entry) async {
    return into(businessSettingsTable).insertReturning(
      BusinessSettingsTableCompanion.insert(
        storeName: entry.storeName.value,
        address: entry.address.value,
        phoneNumber: entry.phoneNumber.value,
        email: entry.email,
        logoPath: entry.logoPath,
        taxNumber: entry.taxNumber,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Update business settings
  Future<BusinessSetting> updateBusinessSettings(int id, BusinessSettingsTableCompanion entry) async {
    await (update(businessSettingsTable)..where((tbl) => tbl.id.equals(id)))
        .write(BusinessSettingsTableCompanion(
          storeName: entry.storeName,
          address: entry.address,
          phoneNumber: entry.phoneNumber,
          email: entry.email,
          logoPath: entry.logoPath,
          taxNumber: entry.taxNumber,
          updatedAt: Value(DateTime.now()),
        ));
    
    final settings = await getBusinessSettingsById(id);
    if (settings == null) {
      throw Exception('Business settings not found');
    }
    return settings;
  }

  // Delete business settings
  Future<void> deleteBusinessSettings(int id) async {
    await (delete(businessSettingsTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
