import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/business_settings_repository.dart';
import '../providers/global_providers.dart';
import '../../domain/entities/business_settings.dart';

// Business settings repository provider
final businessSettingsRepositoryProvider = Provider<BusinessSettingsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return BusinessSettingsRepository(database);
});

// Business settings state
class BusinessSettingsState {
  final List<BusinessSettings> settings;
  final bool isLoading;
  final String? errorMessage;

  BusinessSettingsState({
    required this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  BusinessSettingsState copyWith({
    List<BusinessSettings>? settings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BusinessSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Business settings state notifier
class BusinessSettingsNotifier extends StateNotifier<BusinessSettingsState> {
  final BusinessSettingsRepository _repository;

  BusinessSettingsNotifier(this._repository)
      : super(BusinessSettingsState(settings: []));

  Future<void> loadBusinessSettings() async {
    print('DEBUG BUSINESS SETTINGS PROVIDER: loadBusinessSettings called');
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final settings = await _repository.getBusinessSettings();
      print('DEBUG BUSINESS SETTINGS PROVIDER: Loaded ${settings.length} settings');
      if (settings.isNotEmpty) {
        print('DEBUG BUSINESS SETTINGS PROVIDER: First setting - storeName: ${settings.first.storeName}, address: ${settings.first.address}, phoneNumber: ${settings.first.phoneNumber}');
      }
      state = state.copyWith(settings: settings, isLoading: false);
      print('DEBUG BUSINESS SETTINGS PROVIDER: State updated with settings');
    } catch (e) {
      print('DEBUG BUSINESS SETTINGS PROVIDER: Error loading settings: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat pengaturan bisnis: $e',
      );
    }
  }

  Future<void> saveBusinessSettings(BusinessSettings settings) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final savedSettings = await _repository.saveBusinessSettings(settings);
      final updatedSettings = [...state.settings, savedSettings];
      state = state.copyWith(settings: updatedSettings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menyimpan pengaturan bisnis: $e',
      );
    }
  }

  Future<void> updateBusinessSettings(BusinessSettings settings) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedSettings = await _repository.updateBusinessSettings(settings);
      final settingsList = state.settings.map((s) {
        return s.id == updatedSettings.id ? updatedSettings : s;
      }).toList();
      state = state.copyWith(settings: settingsList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal mengupdate pengaturan bisnis: $e',
      );
    }
  }

  Future<void> deleteBusinessSettings(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.deleteBusinessSettings(id);
      final updatedSettings = state.settings.where((s) => s.id != id).toList();
      state = state.copyWith(settings: updatedSettings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menghapus pengaturan bisnis: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Business settings provider
final businessSettingsProvider =
    StateNotifierProvider<BusinessSettingsNotifier, BusinessSettingsState>((ref) {
  final repository = ref.watch(businessSettingsRepositoryProvider);
  final notifier = BusinessSettingsNotifier(repository);
  // Load settings when provider is first accessed
  Future.microtask(() => notifier.loadBusinessSettings());
  return notifier;
});
