import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/dao/product_dao.dart';
import '../../data/datasources/local/dao/product_option_dao.dart';
import '../../domain/entities/category.dart' as cat;
import '../../presentation/providers/global_providers.dart';

class ProductManagementScreen extends ConsumerStatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  ConsumerState<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState
    extends ConsumerState<ProductManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  cat.Category? _selectedCategory;
  File? _selectedImage;
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Product options state
  List<Map<String, dynamic>> _availableProductOptions = [];
  Map<int, int?> _selectedProductOptions = {};
  Map<int, bool> _selectedOptionCheckboxes = {};

  @override
  void initState() {
    super.initState();
    // Get category from navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        setState(() {
          _selectedCategory = cat.Category(
            id: args['categoryId'] as int,
            uuid: 'cat-${args['categoryId']}',
            name: args['categoryName'] as String,
            description: null,
            color: '#5E8C52',
            icon: 'category',
            parentId: null,
            sortOrder: 1,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isDeleted: false,
            syncStatus: 'synced',
          );
        });
      }
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dao = ref.read(productDaoProvider);
      final products = await dao.getActiveProductsWithCategory(_selectedCategory?.id);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat produk: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Produk',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              if (_selectedCategory != null)
                Text(
                    _selectedCategory!.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
            ],
          ),
          backgroundColor: _selectedCategory != null
              ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
              : const Color(0xFFF5A623),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Produk',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              if (_selectedCategory != null)
                Text(
                    _selectedCategory!.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
            ],
          ),
          backgroundColor: _selectedCategory != null
              ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
              : const Color(0xFFF5A623),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Produk',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            if (_selectedCategory != null)
              Text(
                  _selectedCategory!.name,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
          ],
        ),
        backgroundColor: _selectedCategory != null
            ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
            : const Color(0xFFF5A623),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _showAddProductDialog();
              },
              tooltip: 'Tambah Produk',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                hintText: 'Cari produk...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFFF5A623),
                  size: 22,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xFFF5A623),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          // Product List
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductList(filteredProducts),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: (_selectedCategory != null
                      ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                      : const Color(0xFFF5A623))
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: _selectedCategory != null
                  ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                  : const Color(0xFFF5A623),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedCategory != null
                ? 'Belum Ada Produk di ${_selectedCategory!.name}'
                : 'Belum Ada Produk',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tambahkan produk pertama ke kategori ini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddProductDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Produk Pertama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedCategory != null
                  ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                  : const Color(0xFFF5A623),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            (_selectedCategory != null
                    ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                    : const Color(0xFFF5A623))
                .withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (_selectedCategory != null
                    ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                    : const Color(0xFFF5A623))
                .withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: (_selectedCategory != null
                  ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                  : const Color(0xFFF5A623))
              .withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (_selectedCategory != null
                            ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                            : const Color(0xFFF5A623))
                        .withOpacity(0.15),
                    (_selectedCategory != null
                            ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                            : const Color(0xFFF5A623))
                        .withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getProductIcon(product.name),
                size: 24,
                color: _selectedCategory != null
                    ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                    : const Color(0xFFF5A623),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1A1A2A),
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!product.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Inactive',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description ?? 'No description',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _selectedCategory != null
                                ? [
                                    _parseColor(_selectedCategory!.color ?? '#5E8C52'),
                                    _parseColor(_selectedCategory!.color ?? '#5E8C52')
                                        .withOpacity(0.8),
                                  ]
                                : [
                                    const Color(0xFFF5A623),
                                    const Color(0xFFF5A623).withOpacity(0.8),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Rp ${product.price.toString()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: product.stockQuantity <= product.minStockLevel
                              ? const Color(0xFFE74C3C).withOpacity(0.1)
                              : const Color(0xFF5E8C52).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 12,
                              color: product.stockQuantity <= product.minStockLevel
                                  ? const Color(0xFFE74C3C)
                                  : const Color(0xFF5E8C52),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${product.stockQuantity} ${product.unit}',
                              style: TextStyle(
                                color: product.stockQuantity <= product.minStockLevel
                                    ? const Color(0xFFE74C3C)
                                    : const Color(0xFF5E8C52),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: color.withOpacity(0.1),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final color = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$color', radix: 16));
    } catch (e) {
      return const Color(0xFF5E8C52);
    }
  }

  IconData _getProductIcon(String productName) {
    switch (productName.toLowerCase()) {
      case 'espresso':
      case 'cappuccino':
      case 'green tea':
        return Icons.local_cafe;
      case 'nasi goreng':
      case 'mie goreng':
        return Icons.restaurant;
      case 'chocolate cake':
        return Icons.cookie;
      case 'ice cream':
        return Icons.icecream;
      default:
        return Icons.fastfood;
    }
  }

  List<Product> _getFilteredProducts() {
    List<Product> products = List.from(_products);
    
    // Filter by search query (category is already filtered in _loadProducts)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      products = products.where((p) {
        final name = p.name.toLowerCase();
        final sku = p.sku.toLowerCase();
        final barcode = (p.barcode ?? '').toLowerCase();
        return name.contains(query) || sku.contains(query) || barcode.contains(query);
      }).toList();
    }
    
    return products;
  }

  Future<void> _loadProductOptions() async {
    try {
      final productOptionDao = ref.read(productOptionDaoProvider);
      final options = await productOptionDao.getAllProductOptions();
      
      setState(() {
        _availableProductOptions = options.map((option) {
          return {
            'option': option,
            'isSelected': false,
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading product options: $e');
    }
  }

  void _showAddProductDialog() async {
    // Reset selected image when opening the dialog
    setState(() {
      _selectedImage = null;
    });
    
    // Load available product options
    List<Map<String, dynamic>> availableOptions = [];
    Map<int, bool> selectedOptions = {};
    Map<int, int?> selectedOptionValues = {};
    
    try {
      final productOptionDao = ref.read(productOptionDaoProvider);
      final options = await productOptionDao.getAllProductOptions();
      
      for (var option in options) {
        final values = await productOptionDao.getOptionValues(option.id);
        availableOptions.add({
          'option': option,
          'values': values,
        });
        selectedOptions[option.id] = false; // Default: not selected
        
        // Set default value for this option
        final defaultValue = values.firstWhere(
          (v) => v.isDefault,
          orElse: () => values.isNotEmpty ? values.first : values.first,
        );
        selectedOptionValues[option.id] = defaultValue.id;
      }
    } catch (e) {
      debugPrint('Error loading product options: $e');
    }
    
    final nameController = TextEditingController();
    final skuController = TextEditingController();
    final barcodeController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final costController = TextEditingController();
    final stockQuantityController = TextEditingController();
    final minStockLevelController = TextEditingController();
    final unitController = TextEditingController(text: 'pcs');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final ImagePicker _picker = ImagePicker();

          Future<void> _pickImage(ImageSource source) async {
            try {
              final XFile? pickedFile = await _picker.pickImage(
                source: source,
                imageQuality: 80,
                maxWidth: 800,
              );
              
              if (pickedFile != null) {
                // Validate the file exists
                final file = File(pickedFile.path);
                if (await file.exists()) {
                  setState(() {
                    _selectedImage = file;
                  });
                  setDialogState(() {});
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('File gambar tidak ditemukan'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
              // If pickedFile is null, user cancelled the picker - this is normal
            } catch (e) {
              // Handle any errors during image picking
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memilih gambar: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              // Log the error for debugging
              debugPrint('Error picking image: $e');
            }
          }

          void _removeImage() {
            setState(() {
              _selectedImage = null;
            });
            setDialogState(() {});
          }

          void _showImageSourceDialog() {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Pilih Sumber Gambar'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Galeri'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Kamera'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return AlertDialog(
          title: const Text(
            'Tambah Produk Baru',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Produk',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  autofocus: false,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama produk',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Foto Produk',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: _selectedImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: _removeImage,
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: _showImageSourceDialog,
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap untuk menambahkan foto',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SKU',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: skuController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Masukkan SKU (opsional)',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Barcode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: barcodeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Masukkan barcode (opsional)',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Masukkan deskripsi (opsional)',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Harga Jual (Rp)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Masukkan harga jual',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Harga Beli (Rp)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Masukkan harga beli',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Stok Awal',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockQuantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Masukkan stok awal',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Minimum Stok',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: minStockLevelController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Masukkan minimum stok',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Satuan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: unitController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan satuan (cth: pcs, kg)',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Product Options Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tune,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Opsi Produk',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF1A1A2A),
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              _showAddProductOptionDialog(setDialogState, availableOptions, selectedOptions, selectedOptionValues);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                            ),
                            label: const Text(
                              'Tambah Opsi',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFF5A623),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih opsi yang tersedia untuk produk ini',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (availableOptions.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 32,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Belum ada opsi produk tersedia',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...availableOptions.map((optionData) {
                          final option = optionData['option'] as dynamic;
                          final values = optionData['values'] as List<dynamic>;
                          final optionId = option.id as int;
                          final isSelected = selectedOptions[optionId] ?? false;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFFF5A623)
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFF5A623).withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Option Header with Checkbox
                                InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      selectedOptions[optionId] = !isSelected;
                                    });
                                  },
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFF5A623).withOpacity(0.05)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            setDialogState(() {
                                              selectedOptions[optionId] = value ?? false;
                                            });
                                          },
                                          activeColor: const Color(0xFFF5A623),
                                        ),
                                        Expanded(
                                          child: Text(
                                            option.name as String,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: isSelected
                                                  ? const Color(0xFFF5A623)
                                                  : const Color(0xFF1A1A2A),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: option.selectionType == 'single'
                                                ? Colors.blue.withOpacity(0.1)
                                                : Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                option.selectionType == 'single'
                                                    ? Icons.radio_button_checked
                                                    : Icons.check_box,
                                                size: 14,
                                                color: option.selectionType == 'single'
                                                    ? Colors.blue
                                                    : Colors.green,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                option.selectionType == 'single' ? 'Pilih 1' : 'Banyak',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: option.selectionType == 'single'
                                                      ? Colors.blue
                                                      : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Option Values (only show if option is selected)
                                if (isSelected) ...[
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nilai Default:',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...values.map((value) {
                                          final valueId = value.id as int;
                                          final isDefault = selectedOptionValues[optionId] == valueId;
                                          final priceAdjustment = value.priceAdjustment as int;
                                          final hasPriceAdjustment = priceAdjustment != 0;
                                          
                                          return InkWell(
                                            onTap: () {
                                              setDialogState(() {
                                                selectedOptionValues[optionId] = valueId;
                                              });
                                            },
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                              margin: const EdgeInsets.only(bottom: 6),
                                              decoration: BoxDecoration(
                                                color: isDefault
                                                    ? const Color(0xFFF5A623).withOpacity(0.1)
                                                    : Colors.grey.shade50,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: isDefault
                                                      ? const Color(0xFFF5A623)
                                                      : Colors.grey.shade300,
                                                  width: isDefault ? 2 : 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    isDefault
                                                        ? Icons.radio_button_checked
                                                        : Icons.radio_button_unchecked,
                                                    size: 20,
                                                    color: isDefault
                                                        ? const Color(0xFFF5A623)
                                                        : Colors.grey.shade400,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      value.name as String,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                        color: isDefault
                                                            ? const Color(0xFFF5A623)
                                                            : const Color(0xFF1A1A2A),
                                                      ),
                                                    ),
                                                  ),
                                                  if (hasPriceAdjustment)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: priceAdjustment > 0
                                                            ? Colors.green.withOpacity(0.1)
                                                            : Colors.red.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        priceAdjustment > 0
                                                            ? '+Rp ${priceAdjustment.toString()}'
                                                            : 'Rp ${priceAdjustment.toString()}',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w600,
                                                          color: priceAdjustment > 0
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Reset selected image when cancelling
                setState(() {
                  _selectedImage = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    stockQuantityController.text.isNotEmpty &&
                    minStockLevelController.text.isNotEmpty &&
                    unitController.text.isNotEmpty) {
                  try {
                    final dao = ref.read(productDaoProvider);
                    
                    // Generate SKU if not provided
                    final sku = skuController.text.isNotEmpty
                        ? skuController.text
                        : 'SKU-${DateTime.now().millisecondsSinceEpoch}';
                    
                    final createdProduct = await dao.createProduct(
                      ProductsCompanion.insert(
                        uuid: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        sku: sku,
                        barcode: barcodeController.text.isNotEmpty
                            ? drift.Value(barcodeController.text)
                            : const drift.Value.absent(),
                        description: descriptionController.text.isNotEmpty
                            ? drift.Value(descriptionController.text)
                            : const drift.Value.absent(),
                        categoryId: _selectedCategory?.id ?? 1,
                        price: int.tryParse(priceController.text) ?? 0,
                        cost: int.tryParse(costController.text) ?? 0,
                        stockQuantity: drift.Value(
                            int.tryParse(stockQuantityController.text) ?? 0),
                        minStockLevel: drift.Value(
                            int.tryParse(minStockLevelController.text) ?? 0),
                        unit: drift.Value(unitController.text),
                        image: _selectedImage?.path != null
                            ? drift.Value(_selectedImage!.path)
                            : const drift.Value.absent(),
                      ),
                    );
                    
                    final productId = createdProduct.id;
                    
                    // Assign selected product options to the product
                    final productOptionDao = ref.read(productOptionDaoProvider);
                    for (var entry in selectedOptions.entries) {
                      if (entry.value) {
                        // Option is selected, assign it to the product
                        await productOptionDao.assignOptionToProduct(
                          ProductOptionAssignmentsCompanion(
                            uuid: drift.Value('assignment-${entry.key}-$productId-uuid'),
                            productId: drift.Value(productId),
                            optionId: drift.Value(entry.key),
                            sortOrder: drift.Value(availableOptions.indexWhere((opt) => (opt['option'] as dynamic).id == entry.key) + 1),
                            isRequired: const drift.Value(false),
                            isActive: const drift.Value(true),
                          ),
                        );
                        
                        // Set the default value for this option
                        final defaultValueId = selectedOptionValues[entry.key];
                        if (defaultValueId != null) {
                          await productOptionDao.setDefaultValueForOption(entry.key, defaultValueId);
                        }
                      }
                    }
                    // Reset selected image after saving
                    setState(() {
                      _selectedImage = null;
                    });
                    
                    // Reload products from database
                    await _loadProducts();
                    
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produk berhasil ditambahkan'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menambah produk: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _selectedCategory != null
                        ? _parseColor(_selectedCategory!.color ?? '#5E8C52')
                        : const Color(0xFFF5A623),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
          );
        },
      ),
    );
  }

  void _showAddProductOptionDialog(
    StateSetter setDialogState,
    List<Map<String, dynamic>> availableOptions,
    Map<int, bool> selectedOptions,
    Map<int, int?> selectedOptionValues,
  ) {
    final optionNameController = TextEditingController();
    String selectionType = 'single'; // 'single' or 'multiple'
    List<Map<String, dynamic>> optionValues = [];
    int nextValueId = 1;

    void addOptionValue() {
      final valueNameController = TextEditingController();
      int priceAdjustment = 0;
      bool isDefault = false;

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setValueDialogState) {
            return AlertDialog(
              title: const Text('Tambah Nilai Opsi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: valueNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Nilai',
                      hintText: 'cth: Less Sugar',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Penyesuaian Harga (Rp)',
                      hintText: '0 untuk tanpa perubahan',
                    ),
                    onChanged: (value) {
                      priceAdjustment = int.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Jadikan sebagai nilai default'),
                    value: isDefault,
                    onChanged: (value) {
                      setValueDialogState(() {
                        isDefault = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (valueNameController.text.isNotEmpty) {
                      setDialogState(() {
                        optionValues.add({
                          'id': nextValueId++,
                          'name': valueNameController.text,
                          'priceAdjustment': priceAdjustment,
                          'isDefault': isDefault,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setOptionDialogState) {
          return AlertDialog(
            title: const Text('Tambah Opsi Produk Baru'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: optionNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Opsi',
                        hintText: 'cth: Sugar Level, Ice Level',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tipe Pemilihan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Pilih 1'),
                            subtitle: const Text('Hanya satu nilai yang bisa dipilih'),
                            value: 'single',
                            groupValue: selectionType,
                            onChanged: (value) {
                              setOptionDialogState(() {
                                selectionType = value ?? 'single';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Banyak'),
                            subtitle: const Text('Bisa pilih lebih dari satu'),
                            value: 'multiple',
                            groupValue: selectionType,
                            onChanged: (value) {
                              setOptionDialogState(() {
                                selectionType = value ?? 'multiple';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nilai Opsi',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            addOptionValue();
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Tambah Nilai'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (optionValues.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Belum ada nilai opsi',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...optionValues.asMap().entries.map((entry) {
                        final index = entry.key;
                        final value = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (value['priceAdjustment'] != 0)
                                      Text(
                                        (value['priceAdjustment'] as int) > 0
                                            ? '+Rp ${value['priceAdjustment']}'
                                            : 'Rp ${value['priceAdjustment']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (value['priceAdjustment'] as int) > 0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (value['isDefault'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5A623).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFF5A623),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  setOptionDialogState(() {
                                    optionValues.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (optionNameController.text.isNotEmpty && optionValues.isNotEmpty) {
                    try {
                      final productOptionDao = ref.read(productOptionDaoProvider);
                      
                      // Create the product option
                      final optionId = await productOptionDao.createProductOption(
                        ProductOptionsCompanion(
                          uuid: drift.Value('option-${DateTime.now().millisecondsSinceEpoch}'),
                          name: drift.Value(optionNameController.text),
                          selectionType: drift.Value(selectionType),
                          sortOrder: drift.Value(availableOptions.length + 1),
                          isActive: const drift.Value(true),
                        ),
                      );
                      
                      // Create option values
                      for (var valueData in optionValues) {
                        await productOptionDao.createProductOptionValue(
                          ProductOptionValuesCompanion(
                            uuid: drift.Value('value-${DateTime.now().millisecondsSinceEpoch}-${valueData['id']}'),
                            optionId: drift.Value(optionId),
                            name: drift.Value(valueData['name'] as String),
                            priceAdjustment: drift.Value(valueData['priceAdjustment'] as int),
                            sortOrder: drift.Value(valueData['id'] as int),
                            isDefault: drift.Value(valueData['isDefault'] as bool),
                            isActive: const drift.Value(true),
                          ),
                        );
                      }
                      
                      // Reload options
                      final newOptions = await productOptionDao.getAllProductOptions();
                      setDialogState(() {
                        availableOptions.clear();
                        for (var option in newOptions) {
                          productOptionDao.getOptionValues(option.id).then((values) {
                            availableOptions.add({
                              'option': option,
                              'values': values,
                            });
                            if (!selectedOptions.containsKey(option.id)) {
                              selectedOptions[option.id] = false;
                              if (values.isNotEmpty) {
                                final defaultValue = values.firstWhere(
                                  (v) => v.isDefault,
                                  orElse: () => values.first,
                                );
                                selectedOptionValues[option.id] = defaultValue.id;
                              }
                            }
                          });
                        }
                      });
                      
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opsi produk berhasil ditambahkan'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menambah opsi: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    // TODO: Implement edit product dialog
  }

  void _showDeleteConfirmationDialog(Product product) {
    // TODO: Implement delete confirmation dialog
  }
}
