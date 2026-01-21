import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart.dart' as cart_entity;
import '../../core/utils/responsive_helper.dart';
import '../providers/cart_provider.dart';
import '../providers/global_providers.dart';
import '../widgets/cart_summary_widget.dart';
import '../widgets/product_customization_dialog.dart';
import '../widgets/custom_toast.dart';
import 'cart_screen.dart';
import '../../data/datasources/local/app_database.dart';

/// Point of Sale Screen
/// Main screen for processing sales transactions
/// Supports both portrait and landscape orientations
class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  // State variables
  String? _selectedCategory;
  String _searchQuery = '';
  
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // Data
  List<Category> _categories = [];
  List<Product> _products = [];
  
  // UI State
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Load the cart when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Load categories and products from database
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categoryDao = ref.read(categoryDaoProvider);
      final productDao = ref.read(productDaoProvider);
      
      // Load active categories
      final categories = await categoryDao.getActiveCategories();
      
      // Load active products
      final products = await productDao.getActiveProducts();
      
      setState(() {
        _categories = categories;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final responsive = ResponsiveHelper(context);
    
    // Debug log to track cart state changes
    print('DEBUG POS SCREEN: build() called - Cart state isLoading: ${cartState.isLoading}, hasValue: ${cartState.value != null}');
    if (cartState.value != null) {
      print('DEBUG POS SCREEN: Cart ID: ${cartState.value!.id}, Items count: ${cartState.value!.items.length}');
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Sentosa POS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5E8C52),
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Cart button with badge
          _buildCartButton(cartState),
          // History button
          _buildAppBarButton(
            icon: Icons.history,
            onPressed: () => Navigator.pushNamed(context, '/transaction_history'),
            tooltip: 'Transaction History',
          ),
          // Settings button
          _buildAppBarButton(
            icon: Icons.settings,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final flexRatios = responsive.getPOSFlexRatios();
          
          if (responsive.useColumnLayout) {
            return _buildPortraitLayout(cartState, cartNotifier, responsive, flexRatios);
          } else {
            return _buildLandscapeLayout(cartState, cartNotifier, responsive, flexRatios);
          }
        },
      ),
    );
  }

  /// Build portrait layout (column layout)
  Widget _buildPortraitLayout(
    AsyncValue<cart_entity.Cart> cartState,
    CartNotifier cartNotifier,
    ResponsiveHelper responsive,
    Map<String, int> flexRatios,
  ) {
    return Column(
      children: [
        Expanded(
          flex: flexRatios['productArea']!,
          child: Column(
            children: [
              // Category dropdown and search
              _buildFilterSection(responsive, portrait: true),
              // Product grid
              Expanded(
                child: _buildProductGrid(responsive),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build landscape layout (row layout)
  Widget _buildLandscapeLayout(
    AsyncValue<cart_entity.Cart> cartState,
    CartNotifier cartNotifier,
    ResponsiveHelper responsive,
    Map<String, int> flexRatios,
  ) {
    return Row(
      children: [
        // Product selection area
        Expanded(
          flex: flexRatios['productArea']!,
          child: Column(
            children: [
              // Category dropdown and search
              _buildFilterSection(responsive, portrait: false),
              // Product grid
              Expanded(
                child: _buildProductGrid(responsive),
              ),
            ],
          ),
        ),
        // Cart area
        Expanded(
          flex: flexRatios['cartArea']!,
          child: _buildCartArea(cartState, cartNotifier),
        ),
      ],
    );
  }

  /// Build filter section with category dropdown and search bar
  Widget _buildFilterSection(ResponsiveHelper responsive, {required bool portrait}) {
    final padding = responsive.getResponsivePadding(
      portraitPadding: 12,
      landscapePadding: 20,
    );
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: portrait
          ? Column(
              children: [
                _buildCategoryDropdown(responsive),
                const SizedBox(height: 12),
                _buildSearchBar(responsive),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildCategoryDropdown(responsive),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildSearchBar(responsive),
                ),
              ],
            ),
    );
  }

  /// Build category dropdown
  Widget _buildCategoryDropdown(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5E8C52).withOpacity(0.05),
            const Color(0xFFA1B986).withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5E8C52).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF5E8C52),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 8,
          style: const TextStyle(
            color: Color(0xFF1A1A2A),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          items: _getCategoryDropdownItems(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          selectedItemBuilder: (BuildContext context) {
            return _getCategoryNames().map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF5E8C52).withOpacity(0.15),
                              const Color(0xFFA1B986).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getCategoryIcon(category),
                          size: 18,
                          color: const Color(0xFF5E8C52),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      if (category != 'All' && category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_getCategoryCount(category)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(ResponsiveHelper responsive) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        hintText: 'Search products...',
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF5E8C52),
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Color(0xFF5E8C52),
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                  _searchFocusNode.unfocus();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF5E8C52).withOpacity(0.15),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF5E8C52).withOpacity(0.15),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF5E8C52),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  /// Build product grid
  Widget _buildProductGrid(ResponsiveHelper responsive) {
    final padding = responsive.getResponsivePadding(
      portraitPadding: 10,
      landscapePadding: 20,
    );
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF5E8C52),
              ),
            )
          : _errorMessage != null
              ? _buildErrorWidget()
              : _getFilteredProducts().isEmpty
                  ? _buildEmptyWidget()
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsive.getProductGridColumns(),
                        crossAxisSpacing: responsive.getResponsiveSpacing(
                          portraitSpacing: 10,
                          landscapeSpacing: 20,
                        ),
                        mainAxisSpacing: responsive.getResponsiveSpacing(
                          portraitSpacing: 10,
                          landscapeSpacing: 20,
                        ),
                        childAspectRatio: responsive.getCardAspectRatio(),
                      ),
                      itemCount: _getFilteredProducts().length,
                      itemBuilder: (context, index) {
                        final product = _getFilteredProducts()[index];
                        return _buildProductCard(product);
                      },
                    ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E8C52),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty widget
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build cart area (landscape mode)
  Widget _buildCartArea(
    AsyncValue<cart_entity.Cart> cartState,
    CartNotifier cartNotifier,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cart header
          _buildCartHeader(cartState),
          // Cart items
          Expanded(
            child: _buildCartItems(cartState),
          ),
          // Cart summary
          if (cartState.value != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CartSummaryWidget(
                cart: cartState.value!,
                onCheckout: () {
                  if (cartState.value != null && cartState.value!.items.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  }
                },
                onClear: cartNotifier.clearCart,
              ),
            ),
        ],
      ),
    );
  }

  /// Build cart header
  Widget _buildCartHeader(AsyncValue<cart_entity.Cart> cartState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${cartState.value?.items.length ?? 0} items',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build cart items list
  Widget _buildCartItems(AsyncValue<cart_entity.Cart> cartState) {
    return cartState.isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5E8C52),
            ),
          )
        : cartState.value == null || cartState.value!.items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cart is empty',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartState.value!.items.length,
                itemBuilder: (context, index) {
                  final item = cartState.value!.items[index];
                  return _buildCartItem(item);
                },
              );
  }

  /// Build cart button with badge
  Widget _buildCartButton(AsyncValue<cart_entity.Cart> cartState) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            tooltip: 'Cart',
          ),
          if (cartState.value?.items.isNotEmpty ?? false)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${cartState.value?.items.length ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build app bar button
  Widget _buildAppBarButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  /// Build product card
  Widget _buildProductCard(Product product) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.98),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E8C52).withOpacity(0.15),
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
          color: const Color(0xFF5E8C52).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ProductCustomizationDialog(
                product: product,
                onAddToCart: () {
                  // Show toast notification when product is added to cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      backgroundColor: const Color(0xFF5E8C52),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          splashColor: const Color(0xFF5E8C52).withOpacity(0.1),
          highlightColor: const Color(0xFF5E8C52).withOpacity(0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Area
              Expanded(
                flex: 2,
                child: _buildProductImageArea(),
              ),
              // Product Info
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF1A1A2A),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description ?? 'No description',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Rp ${_formatPrice(product.price)}',
                              style: const TextStyle(
                                color: Color(0xFF5E8C52),
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF5E8C52).withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build product image area
  Widget _buildProductImageArea() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF5E8C52).withOpacity(0.15),
                const Color(0xFFA1B986).withOpacity(0.1),
                const Color(0xFF5E8C52).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          // Decorative circles
          child: Stack(
            children: [
              Positioned(
                left: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5E8C52).withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: -10,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFA1B986).withOpacity(0.15),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Product Icon
        Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5E8C52).withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_cafe,
              size: 52,
              color: Color(0xFF5E8C52),
            ),
          ),
        ),
      ],
    );
  }

  /// Build cart item
  Widget _buildCartItem(cart_entity.CartItem item) {
    return FutureBuilder<Product?>(
      future: ref.read(productDaoProvider).getProductById(item.productId),
      builder: (context, snapshot) {
        final product = snapshot.data;
        final productName = product?.name ?? 'Product ${item.productId}';
        
        // Parse notes JSON if available
        Map<String, dynamic>? notesData;
        if (item.notes != null && item.notes!.isNotEmpty) {
          try {
            notesData = jsonDecode(item.notes!) as Map<String, dynamic>;
          } catch (e) {
            // If parsing fails, notesData remains null
          }
        }
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color(0xFF5E8C52).withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5E8C52).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
            border: Border.all(
              color: const Color(0xFF5E8C52).withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image/Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF5E8C52).withOpacity(0.15),
                        const Color(0xFFA1B986).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.local_cafe,
                    size: 32,
                    color: Color(0xFF5E8C52),
                  ),
                ),
                const SizedBox(width: 16),
                // Product Info
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1A1A2A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Display variant if exists
                      if (item.variantId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E8C52).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Variant ${item.variantId}',
                            style: const TextStyle(
                              color: Color(0xFF5E8C52),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      // Display options if available - show formatted string
                      if (notesData != null && notesData.containsKey('options'))
                        _buildOptionsDisplay(item.productId, notesData['options'] as Map<String, dynamic>),
                      // Display custom notes if available
                      if (notesData != null && notesData.containsKey('customNotes'))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notesData['customNotes'] as String,
                            style: const TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Rp ${_formatPrice(item.totalPrice.toInt())}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Quantity Controls
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF5E8C52).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove_rounded,
                        onPressed: () {
                          ref.read(cartProvider.notifier).updateQuantity(
                            item.id,
                            item.quantity - 1,
                          );
                        },
                      ),
                      Container(
                        width: 45,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5E8C52).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add_rounded,
                        onPressed: () {
                          ref.read(cartProvider.notifier).updateQuantity(
                            item.id,
                            item.quantity + 1,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build options display widget with actual names
  Widget _buildOptionsDisplay(int productId, Map<String, dynamic> options) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getOptionDetails(productId, options),
      builder: (context, snapshot) {
        final optionDetails = snapshot.data ?? [];
        
        if (optionDetails.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Format options to display nicely
        final optionsList = <String>[];
        for (final detail in optionDetails) {
          final optionName = detail['optionName'] as String;
          final valueName = detail['valueName'] as String;
          optionsList.add('$optionName: $valueName');
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFA1B986).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Options: ${optionsList.join('; ')}',
            style: const TextStyle(
              color: Color(0xFF5E8C52),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        );
      },
    );
  }

  /// Get option details from database
  Future<List<Map<String, dynamic>>> _getOptionDetails(int productId, Map<String, dynamic> options) async {
    final optionDao = ref.read(productOptionDaoProvider);
    final details = <Map<String, dynamic>>[];
    
    for (final entry in options.entries) {
      final optionId = int.tryParse(entry.key);
      final valueIds = entry.value;
      
      if (optionId != null && valueIds is List) {
        final values = valueIds as List;
        for (final valueId in values) {
          final intValueId = valueId is int ? valueId : int.tryParse(valueId.toString());
          if (intValueId != null) continue;
          
          // Get option and value details
          final optionDataList = await optionDao.getProductOptionsWithValues(productId);
          Map<String, dynamic>? optionData;
          
          for (final data in optionDataList) {
            final option = data['option'] as ProductOption;
            if (option.id == optionId) {
              optionData = data;
              break;
            }
          }
          
          if (optionData != null) {
            final option = optionData['option'] as ProductOption;
            final valuesList = optionData['values'] as List<ProductOptionValue>;
            ProductOptionValue? value;
            
            for (final v in valuesList) {
              if (v.id == intValueId) {
                value = v;
                break;
              }
            }
            
            if (value != null) {
              details.add({
                'optionName': option.name,
                'valueName': value.name,
              });
            }
          }
        }
      }
    }
    
    return details;
  }

  /// Build quantity button
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: const Color(0xFF5E8C52).withOpacity(0.1),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 22,
            color: const Color(0xFF5E8C52),
          ),
        ),
      ),
    );
  }

  // ==================== Helper Methods ====================

  /// Get category dropdown items
  List<DropdownMenuItem<String>> _getCategoryDropdownItems() {
    return _getCategoryNames().map((String category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Row(
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 20,
              color: const Color(0xFF5E8C52),
            ),
            const SizedBox(width: 12),
            Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF1A1A2A),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Get category names including "All"
  List<String> _getCategoryNames() {
    final names = _categories.map((c) => c.name).toList();
    names.insert(0, 'All');
    return names;
  }

  /// Get category icon based on category name or icon field
  IconData _getCategoryIcon(String? category) {
    if (category == 'All') {
      return Icons.dashboard;
    }
    
    // Find category by name
    Category? cat;
    try {
      cat = _categories.firstWhere((c) => c.name == category);
    } catch (e) {
      cat = null;
    }
    
    if (cat == null) return Icons.dashboard;
    
    // Map icon string to IconData
    switch (cat.icon) {
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

  /// Get product count for a category
  int _getCategoryCount(String? category) {
    if (category == 'All') {
      return _products.length;
    }
    
    // Find category by name
    Category? cat;
    try {
      cat = _categories.firstWhere((c) => c.name == category);
    } catch (e) {
      cat = null;
    }
    
    if (cat == null) return 0;
    
    // Count products in this category
    return _products.where((p) => p.categoryId == cat!.id).length;
  }

  /// Format price with thousands separator (Indonesian format)
  String _formatPrice(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price);
  }

  /// Get filtered products based on category and search query
  List<Product> _getFilteredProducts() {
    List<Product> products = List.from(_products);
    
    // Filter by category
    if (_selectedCategory != null) {
      // Find category by name
      Category? cat;
      try {
        cat = _categories.firstWhere((c) => c.name == _selectedCategory);
      } catch (e) {
        cat = null;
      }
      
      if (cat != null) {
        products = products.where((p) => p.categoryId == cat!.id).toList();
      } else {
        products = [];
      }
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((p) {
        final name = p.name.toLowerCase();
        final sku = p.sku.toLowerCase();
        final barcode = (p.barcode ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || sku.contains(query) || barcode.contains(query);
      }).toList();
    }
    
    return products;
  }
}
