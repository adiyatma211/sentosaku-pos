import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/responsive_helper.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/dao/category_dao.dart';
import '../../presentation/providers/global_providers.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends ConsumerState<CategoryManagementScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dao = ref.read(categoryDaoProvider);
      final categories = await dao.getAllCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat kategori: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addCategory({
    required String name,
    String? description,
    required String color,
    required String icon,
  }) async {
    try {
      final dao = ref.read(categoryDaoProvider);
      final nextSortOrder = await dao.getNextSortOrder();
      await dao.createCategory(
        CategoriesCompanion.insert(
          uuid: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          description: description == null || description.isEmpty
              ? const drift.Value.absent()
              : drift.Value(description),
          color: color != null ? drift.Value(color) : const drift.Value.absent(),
          icon: icon != null ? drift.Value(icon) : const drift.Value.absent(),
          sortOrder: drift.Value(nextSortOrder),
        ),
      );
      await _loadCategories();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menambah kategori: $e';
      });
    }
  }

  Future<void> _updateCategory(Category category) async {
    try {
      final dao = ref.read(categoryDaoProvider);
      await dao.updateCategory(
        category.id,
        CategoriesCompanion(
          name: drift.Value(category.name),
          description: category.description == null || category.description!.isEmpty
              ? const drift.Value.absent()
              : drift.Value(category.description),
          color: drift.Value(category.color ?? '#5E8C52'),
          icon: drift.Value(category.icon ?? 'category'),
        ),
      );
      await _loadCategories();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengupdate kategori: $e';
      });
    }
  }

  Future<void> _deleteCategory(int categoryId) async {
    try {
      final dao = ref.read(categoryDaoProvider);
      await dao.deleteCategory(categoryId);
      await _loadCategories();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menghapus kategori: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen Produk',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: responsive.getResponsiveFontSize(portraitSize: 20, landscapeSize: 22),
              ),
            ),
            Text(
              'Kelola kategori dan produk',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontSize: responsive.getResponsiveFontSize(portraitSize: 13, landscapeSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5E8C52),
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
                _showAddCategoryDialog();
              },
              tooltip: 'Tambah Kategori',
            ),
          ),
        ],
      ),
      body: _categories.isEmpty
          ? _buildEmptyState()
          : _buildCategoryList(),
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
              color: const Color(0xFF5E8C52).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.category_outlined,
              size: 80,
              color: Color(0xFF5E8C52),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Kategori',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Buat kategori pertama untuk mulai mengelola produk',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddCategoryDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Kategori Pertama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E8C52),
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

  Widget _buildCategoryList() {
    final responsive = ResponsiveHelper(context);
    
    return Padding(
      padding: EdgeInsets.all(responsive.getResponsivePadding()),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive.getCategoryGridColumns(),
          crossAxisSpacing: responsive.getResponsiveSpacing(),
          mainAxisSpacing: responsive.getResponsiveSpacing(),
          childAspectRatio: 1.0,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(_categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product_management',
          arguments: {'categoryId': category.id, 'categoryName': category.name},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              _parseColor(category.color ?? '#5E8C52').withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _parseColor(category.color ?? '#5E8C52').withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
          border: Border.all(
            color: _parseColor(category.color ?? '#5E8C52').withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Category Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _parseColor(category.color ?? '#5E8C52').withOpacity(0.2),
                          _parseColor(category.color ?? '#5E8C52').withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(category.icon),
                      size: 28,
                      color: _parseColor(category.color ?? '#5E8C52'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category Name
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF1A1A2A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Category Description
                  Text(
                    category.description ?? 'Tidak ada deskripsi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // View Products Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _parseColor(category.color ?? '#5E8C52'),
                          _parseColor(category.color ?? '#5E8C52').withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Lihat Produk',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 9,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    color: const Color(0xFF4A90E2),
                    onTap: () {
                      _showEditCategoryDialog(category);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.delete,
                    color: const Color(0xFFE74C3C),
                    onTap: () {
                      _showDeleteConfirmationDialog(category);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
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

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'local_cafe':
        return Icons.local_cafe;
      case 'local_cafe_outlined':
        return Icons.local_cafe_outlined;
      case 'restaurant':
        return Icons.restaurant;
      case 'cookie':
        return Icons.cookie;
      case 'fastfood':
        return Icons.fastfood;
      case 'icecream':
        return Icons.icecream;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'dinner_dining':
        return Icons.dinner_dining;
      case 'set_meal':
        return Icons.set_meal;
      default:
        return Icons.category;
    }
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedColor = '#5E8C52';
    String selectedIcon = 'category';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Tambah Kategori Baru',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Kategori',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kategori',
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
                  'Warna',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildColorOption(
                      color: '#5E8C52',
                      isSelected: selectedColor == '#5E8C52',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#5E8C52';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#8B4513',
                      isSelected: selectedColor == '#8B4513',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#8B4513';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#2E8B57',
                      isSelected: selectedColor == '#2E8B57',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#2E8B57';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#D2691E',
                      isSelected: selectedColor == '#D2691E',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#D2691E';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#FF6B6B',
                      isSelected: selectedColor == '#FF6B6B',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#FF6B6B';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#4A90E2',
                      isSelected: selectedColor == '#4A90E2',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#4A90E2';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ikon',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildIconOption(
                      icon: 'category',
                      isSelected: selectedIcon == 'category',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'category';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'local_cafe',
                      isSelected: selectedIcon == 'local_cafe',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'local_cafe';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'restaurant',
                      isSelected: selectedIcon == 'restaurant',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'restaurant';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'cookie',
                      isSelected: selectedIcon == 'cookie',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'cookie';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'fastfood',
                      isSelected: selectedIcon == 'fastfood',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'fastfood';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'icecream',
                      isSelected: selectedIcon == 'icecream',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'icecream';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  _addCategory(
                    name: nameController.text,
                    description: descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : null,
                    color: selectedColor,
                    icon: selectedIcon,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E8C52),
              ),
              child: const Text('Tambah Kategori'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption({
    required String color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _parseColor(color),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildIconOption({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5E8C52).withOpacity(0.1)
              : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5E8C52) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(
          _getIconData(icon),
          color: isSelected ? const Color(0xFF5E8C52) : Colors.grey[600],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(Category category) {
    final nameController = TextEditingController(text: category.name);
    final descriptionController =
        TextEditingController(text: category.description ?? '');
    String selectedColor = category.color ?? '#5E8C52';
    String selectedIcon = category.icon ?? 'category';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Edit Kategori',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Kategori',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kategori',
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
                  'Warna',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildColorOption(
                      color: '#5E8C52',
                      isSelected: selectedColor == '#5E8C52',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#5E8C52';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#8B4513',
                      isSelected: selectedColor == '#8B4513',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#8B4513';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#2E8B57',
                      isSelected: selectedColor == '#2E8B57',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#2E8B57';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#D2691E',
                      isSelected: selectedColor == '#D2691E',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#D2691E';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#FF6B6B',
                      isSelected: selectedColor == '#FF6B6B',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#FF6B6B';
                        });
                      },
                    ),
                    _buildColorOption(
                      color: '#4A90E2',
                      isSelected: selectedColor == '#4A90E2',
                      onTap: () {
                        setDialogState(() {
                          selectedColor = '#4A90E2';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ikon',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildIconOption(
                      icon: 'category',
                      isSelected: selectedIcon == 'category',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'category';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'local_cafe',
                      isSelected: selectedIcon == 'local_cafe',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'local_cafe';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'restaurant',
                      isSelected: selectedIcon == 'restaurant',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'restaurant';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'cookie',
                      isSelected: selectedIcon == 'cookie',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'cookie';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'fastfood',
                      isSelected: selectedIcon == 'fastfood',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'fastfood';
                        });
                      },
                    ),
                    _buildIconOption(
                      icon: 'icecream',
                      isSelected: selectedIcon == 'icecream',
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = 'icecream';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
              if (nameController.text.isNotEmpty) {
                  _updateCategory(category.copyWith(
                    name: nameController.text,
                    description: drift.Value(
                      descriptionController.text.isNotEmpty 
                        ? descriptionController.text 
                        : null
                    ),
                    color: drift.Value(selectedColor),
                    icon: drift.Value(selectedIcon),
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E8C52),
              ),
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Kategori',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${category.name}"?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _categories.removeWhere((c) => c.id == category.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
