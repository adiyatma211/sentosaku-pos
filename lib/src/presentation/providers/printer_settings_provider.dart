import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/printer_settings_repository.dart';
import '../providers/global_providers.dart';
import '../../domain/entities/printer_settings.dart';

// Printer settings repository provider
final printerSettingsRepositoryProvider = Provider<PrinterSettingsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return PrinterSettingsRepository(database);
});

// Printer settings state
class PrinterSettingsState {
  final List<PrinterSettings> settings;
  final bool isLoading;
  final String? errorMessage;

  PrinterSettingsState({
    required this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  PrinterSettingsState copyWith({
    List<PrinterSettings>? settings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PrinterSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Printer settings state notifier
class PrinterSettingsNotifier extends StateNotifier<PrinterSettingsState> {
  final PrinterSettingsRepository _repository;

  PrinterSettingsNotifier(this._repository)
      : super(PrinterSettingsState(settings: []));

  Future<void> loadPrinterSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final settings = await _repository.getPrinterSettings();
      state = state.copyWith(settings: settings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat pengaturan printer: $e',
      );
    }
  }

  Future<void> savePrinterSettings(PrinterSettings settings) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final savedSettings = await _repository.savePrinterSettings(settings);
      final updatedSettings = [...state.settings, savedSettings];
      state = state.copyWith(settings: updatedSettings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menyimpan pengaturan printer: $e',
      );
    }
  }

  Future<void> updatePrinterSettings(PrinterSettings settings) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedSettings = await _repository.updatePrinterSettings(settings);
      final settingsList = state.settings.map((s) {
        return s.id == updatedSettings.id ? updatedSettings : s;
      }).toList();
      state = state.copyWith(settings: settingsList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal mengupdate pengaturan printer: $e',
      );
    }
  }

  Future<void> deletePrinterSettings(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.deletePrinterSettings(id);
      final updatedSettings = state.settings.where((s) => s.id != id).toList();
      state = state.copyWith(settings: updatedSettings, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menghapus pengaturan printer: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Printer settings provider
final printerSettingsProvider =
    StateNotifierProvider<PrinterSettingsNotifier, PrinterSettingsState>((ref) {
  final repository = ref.watch(printerSettingsRepositoryProvider);
  final notifier = PrinterSettingsNotifier(repository);
  // Load settings when provider is first accessed
  Future.microtask(() => notifier.loadPrinterSettings());
  return notifier;
});
