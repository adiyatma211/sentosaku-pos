import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/printer_settings_provider.dart';
import '../../domain/entities/printer_settings.dart';
import '../providers/domain_providers.dart';
import '../widgets/custom_toast.dart';

class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() =>
      _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _copiesController = TextEditingController(text: '1');
  
  String _printerType = 'bluetooth';
  String? _selectedBluetoothDevice;
  int _paperWidth = 58;
  String _fontSize = 'medium';
  bool _autoPrint = false;
  int _copies = 1;
  bool _showHeader = true;
  bool _showFooter = true;
  bool _showBarcode = true;
  PrinterSettings? _currentSettings;
  List<BluetoothDevice> _bluetoothDevices = [];
  bool _isLoadingDevices = false;
  String? _scanError;
  bool _isDialogScanning = false;
  String? _dialogScanError;

  @override
  void initState() {
    super.initState();
    _copiesController.text = _copies.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  @override
  void dispose() {
    _copiesController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final state = ref.read(printerSettingsProvider);
    if (state.settings.isNotEmpty) {
      setState(() {
        _currentSettings = state.settings.first;
        _printerType = _currentSettings!.printerType;
        _selectedBluetoothDevice = _currentSettings!.bluetoothAddress;
        _paperWidth = _currentSettings!.paperWidth;
        _fontSize = _currentSettings!.fontSize;
        _autoPrint = _currentSettings!.autoPrint;
        _copies = _currentSettings!.copies;
        _showHeader = _currentSettings!.showHeader;
        _showFooter = _currentSettings!.showFooter;
        _showBarcode = _currentSettings!.showBarcode;
        _copiesController.text = _copies.toString();
      });
      
      if (_printerType == 'bluetooth') {
        _loadBluetoothDevices();
      }
    }
  }

  Future<void> _loadBluetoothDevices() async {
    setState(() {
      _isLoadingDevices = true;
      _scanError = null;
    });
    try {
      final bluetoothService = ref.read(bluetoothServiceProvider);
      final devices = await bluetoothService.getPairedDevices();
      setState(() {
        _bluetoothDevices = devices;
        _isLoadingDevices = false;
        _scanError = null;
      });
    } catch (e) {
      setState(() {
        _isLoadingDevices = false;
        _scanError = 'Gagal memuat perangkat Bluetooth: $e';
      });
      if (mounted) {
        CustomToast.error(
          context,
          'Gagal memuat perangkat Bluetooth: $e',
        );
      }
    }
  }

  Future<void> _scanBluetoothDevicesForDialog() async {
    setState(() {
      _isDialogScanning = true;
      _dialogScanError = null;
    });
    try {
      final bluetoothService = ref.read(bluetoothServiceProvider);
      final devices = await bluetoothService.getPairedDevices();
      setState(() {
        _bluetoothDevices = devices;
        _isDialogScanning = false;
        _dialogScanError = null;
      });
    } catch (e) {
      setState(() {
        _isDialogScanning = false;
        _dialogScanError = 'Gagal memindai perangkat Bluetooth: $e';
      });
    }
  }

  String _getSelectedDeviceName() {
    if (_selectedBluetoothDevice == null) {
      return 'Pilih Perangkat Bluetooth';
    }
    final device = _bluetoothDevices.firstWhere(
      (d) => d.address == _selectedBluetoothDevice,
      orElse: () => BluetoothDevice(
        name: 'Unknown',
        address: _selectedBluetoothDevice!,
      ),
    );
    return device.name ?? 'Unknown';
  }

  Future<void> _testConnection() async {
    if (_printerType == 'bluetooth' && _selectedBluetoothDevice == null) {
      CustomToast.warning(
        context,
        'Pilih perangkat Bluetooth terlebih dahulu',
      );
      return;
    }

    try {
      final bluetoothService = ref.read(bluetoothServiceProvider);
      bool connected = false;
      
      if (_printerType == 'bluetooth') {
        connected = await bluetoothService.connectToDevice(_selectedBluetoothDevice!);
      }
      
      if (mounted) {
        if (connected) {
          CustomToast.success(
            context,
            'Koneksi printer berhasil!',
          );
        } else {
          CustomToast.error(
            context,
            'Gagal terhubung ke printer',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomToast.error(
          context,
          'Gagal menguji koneksi: $e',
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = PrinterSettings(
      id: _currentSettings?.id ?? 0,
      printerType: _printerType,
      bluetoothAddress: _printerType == 'bluetooth' ? _selectedBluetoothDevice : null,
      paperWidth: _paperWidth,
      fontSize: _fontSize,
      autoPrint: _autoPrint,
      copies: _copies,
      showHeader: _showHeader,
      showFooter: _showFooter,
      showBarcode: _showBarcode,
      updatedAt: DateTime.now(),
    );

    if (_currentSettings == null) {
      await ref.read(printerSettingsProvider.notifier).savePrinterSettings(settings);
    } else {
      await ref.read(printerSettingsProvider.notifier).updatePrinterSettings(settings);
    }

    if (mounted) {
      CustomToast.success(
        context,
        'Pengaturan printer berhasil disimpan',
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(printerSettingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Pengaturan Printer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5E8C52),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final responsive = ResponsiveHelper(context);
          return state.isLoading && state.settings.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(responsive.getResponsivePadding()),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    if (state.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Printer Type
                    _buildDropdownField(
                      label: 'Jenis Printer',
                      value: _printerType,
                      items: const [
                        DropdownMenuItem(value: 'bluetooth', child: Text('Bluetooth')),
                        DropdownMenuItem(value: 'usb', child: Text('USB')),
                        DropdownMenuItem(value: 'network', child: Text('Network')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _printerType = value as String;
                          if (_printerType == 'bluetooth') {
                            _loadBluetoothDevices();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Bluetooth Device Selection
                    if (_printerType == 'bluetooth')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Perangkat Bluetooth',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _showBluetoothDeviceDialog,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedBluetoothDevice != null
                                      ? const Color(0xFF5E8C52)
                                      : Colors.grey.shade300,
                                  width: _selectedBluetoothDevice != null ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _selectedBluetoothDevice != null
                                          ? const Color(0xFF5E8C52).withValues(alpha: 0.1)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.bluetooth,
                                      color: _selectedBluetoothDevice != null
                                          ? const Color(0xFF5E8C52)
                                          : Colors.grey.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getSelectedDeviceName(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: _selectedBluetoothDevice != null
                                                ? const Color(0xFF1A1A2A)
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                        if (_selectedBluetoothDevice != null)
                                          Text(
                                            _selectedBluetoothDevice!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_scanError != null)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _scanError!,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    if (_printerType == 'bluetooth')
                      const SizedBox(height: 16),
                    // Paper Width
                    _buildDropdownField(
                      label: 'Lebar Kertas',
                      value: _paperWidth,
                      items: const [
                        DropdownMenuItem(value: 58, child: Text('58mm')),
                        DropdownMenuItem(value: 80, child: Text('80mm')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _paperWidth = value as int;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Font Size
                    _buildDropdownField(
                      label: 'Ukuran Font',
                      value: _fontSize,
                      items: const [
                        DropdownMenuItem(value: 'small', child: Text('Kecil')),
                        DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                        DropdownMenuItem(value: 'large', child: Text('Besar')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value as String;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    // Switches
                    _buildSwitchTile(
                      title: 'Cetak Otomatis',
                      subtitle: 'Cetak struk otomatis setelah pembayaran',
                      value: _autoPrint,
                      onChanged: (value) {
                        setState(() {
                          _autoPrint = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Tampilkan Header',
                      subtitle: 'Tampilkan informasi bisnis di header struk',
                      value: _showHeader,
                      onChanged: (value) {
                        setState(() {
                          _showHeader = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Tampilkan Footer',
                      subtitle: 'Tampilkan pesan di footer struk',
                      value: _showFooter,
                      onChanged: (value) {
                        setState(() {
                          _showFooter = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Tampilkan Barcode',
                      subtitle: 'Tampilkan barcode pada struk',
                      value: _showBarcode,
                      onChanged: (value) {
                        setState(() {
                          _showBarcode = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Copies
                    _buildTextField(
                      label: 'Jumlah Salinan',
                      controller: _copiesController,
                      icon: Icons.content_copy,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final copies = int.tryParse(value);
                        if (copies != null && copies > 0) {
                          setState(() {
                            _copies = copies;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Jumlah salinan wajib diisi';
                        }
                        final copies = int.tryParse(value);
                        if (copies == null || copies < 1) {
                          return 'Jumlah salinan minimal 1';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Test Connection Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: (_isLoadingDevices || _isDialogScanning) ? null : _testConnection,
                        icon: const Icon(Icons.print),
                        label: const Text('Uji Koneksi Printer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF5E8C52),
                          side: const BorderSide(color: Color(0xFF5E8C52)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (state.isLoading || _isDialogScanning) ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E8C52),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required dynamic value,
    required List<DropdownMenuItem<dynamic>> items,
    required void Function(dynamic) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2A),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<dynamic>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5E8C52), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF5E8C52),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: const Color(0xFF5E8C52)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5E8C52), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _showBluetoothDeviceDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 500,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5E8C52),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bluetooth,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Pilih Perangkat Bluetooth',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Scan Ulang Button
                          TextButton.icon(
                            onPressed: _isDialogScanning
                                ? null
                                : () async {
                                    await _scanBluetoothDevicesForDialog();
                                    setDialogState(() {});
                                  },
                            icon: _isDialogScanning
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.refresh, size: 18),
                            label: const Text(
                              'Scan Ulang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Close Button
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: _isDialogScanning
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF5E8C52),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Memindai perangkat...',
                                      style: TextStyle(
                                        color: Color(0xFF1A1A2A),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _dialogScanError != null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red.shade500,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          _dialogScanError!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _bluetoothDevices.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.bluetooth_disabled,
                                              color: Colors.grey.shade400,
                                              size: 48,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Tidak ada perangkat ditemukan',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tekan "Scan Ulang" untuk memindai ulang',
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _bluetoothDevices.length,
                                        itemBuilder: (context, index) {
                                          final device = _bluetoothDevices[index];
                                          final isSelected = device.address == _selectedBluetoothDevice;
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedBluetoothDevice = device.address;
                                              });
                                              Navigator.pop(context);
                                            },
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? const Color(0xFF5E8C52).withValues(alpha: 0.1)
                                                    : Colors.grey.shade50,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(0xFF5E8C52)
                                                      : Colors.grey.shade200,
                                                  width: isSelected ? 2 : 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? const Color(0xFF5E8C52)
                                                          : Colors.grey.shade200,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Icon(
                                                      Icons.bluetooth,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.grey.shade600,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          device.name ?? 'Unknown',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: isSelected
                                                                ? const Color(0xFF5E8C52)
                                                                : const Color(0xFF1A1A2A),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          device.address,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xFF5E8C52),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
