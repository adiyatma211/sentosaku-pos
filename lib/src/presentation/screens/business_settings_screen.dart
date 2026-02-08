import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/utils/responsive_helper.dart';
import '../providers/business_settings_provider.dart';
import '../../domain/entities/business_settings.dart';
import '../widgets/custom_toast.dart';

class BusinessSettingsScreen extends ConsumerStatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  ConsumerState<BusinessSettingsScreen> createState() =>
      _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends ConsumerState<BusinessSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _taxNumberController = TextEditingController();
  File? _logoFile;
  BusinessSettings? _currentSettings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final state = ref.read(businessSettingsProvider);
    if (state.settings.isNotEmpty) {
      setState(() {
        _currentSettings = state.settings.first;
        _storeNameController.text = _currentSettings!.storeName;
        _addressController.text = _currentSettings!.address;
        _phoneNumberController.text = _currentSettings!.phoneNumber;
        _emailController.text = _currentSettings!.email ?? '';
        _taxNumberController.text = _currentSettings!.taxNumber ?? '';
      });
    }
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = BusinessSettings(
      id: _currentSettings?.id ?? 0,
      storeName: _storeNameController.text.trim(),
      address: _addressController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      logoPath: _logoFile?.path ?? _currentSettings?.logoPath,
      taxNumber: _taxNumberController.text.trim().isEmpty
          ? null
          : _taxNumberController.text.trim(),
      updatedAt: DateTime.now(),
    );

    if (_currentSettings == null) {
      await ref.read(businessSettingsProvider.notifier).saveBusinessSettings(settings);
    } else {
      await ref.read(businessSettingsProvider.notifier).updateBusinessSettings(settings);
    }

    if (mounted) {
      CustomToast.success(
        context,
        'Pengaturan bisnis berhasil disimpan',
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final state = ref.watch(businessSettingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Pengaturan Bisnis',
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
                    // Logo Upload
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickLogo,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: _logoFile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _logoFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : _currentSettings?.logoPath != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(_currentSettings!.logoPath!),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.store,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.add_photo_alternate,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk upload logo',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Store Name
                    _buildTextField(
                      label: 'Nama Toko *',
                      controller: _storeNameController,
                      icon: Icons.store,
                      required: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama toko wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Address
                    _buildTextField(
                      label: 'Alamat *',
                      controller: _addressController,
                      icon: Icons.location_on,
                      required: true,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alamat wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Phone Number
                    _buildTextField(
                      label: 'Nomor Telepon *',
                      controller: _phoneNumberController,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      required: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nomor telepon wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Tax Number
                    _buildTextField(
                      label: 'NPWP',
                      controller: _taxNumberController,
                      icon: Icons.receipt_long,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : _saveSettings,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2A),
            ),
            children: required
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
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
}
