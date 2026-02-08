import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/cart.dart' as cart_entity;
import '../../domain/entities/order.dart' as order_entity;
import '../../domain/entities/business_settings.dart';
import '../../domain/entities/printer_settings.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/cart_provider.dart';
import '../providers/global_providers.dart';
import '../providers/domain_providers.dart';
import '../providers/business_settings_provider.dart';
import '../providers/printer_settings_provider.dart';
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
      // Load business settings proactively
      ref.read(businessSettingsProvider.notifier).loadBusinessSettings();
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
      final cartValue = cartState.value;
      print('DEBUG POS SCREEN: Cart ID: ${cartValue?.id}, Items count: ${cartValue?.items.length}');
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
          
          // Debug logging for flexRatios
          print('DEBUG POS SCREEN: flexRatios keys: ${flexRatios.keys.toList()}');
          print('DEBUG POS SCREEN: flexRatios values: $flexRatios');
          print('DEBUG POS SCREEN: has productArea key: ${flexRatios.containsKey('productArea')}');
          print('DEBUG POS SCREEN: has cartArea key: ${flexRatios.containsKey('cartArea')}');
          
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
  /// In portrait mode, only show product grid (full screen)
  /// Cart is accessible via separate screen through the cart button in app bar
  Widget _buildPortraitLayout(
    AsyncValue<cart_entity.Cart> cartState,
    CartNotifier cartNotifier,
    ResponsiveHelper responsive,
    Map<String, int> flexRatios,
  ) {
    final productAreaFlex = flexRatios['productArea'] ?? 1;
    print('DEBUG POS SCREEN: _buildPortraitLayout - productAreaFlex: $productAreaFlex (full screen products only)');
    
    return Column(
      children: [
        // Product area takes full screen
        Expanded(
          flex: productAreaFlex,
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
    final productAreaFlex = flexRatios['productArea'] ?? 2;
    final cartAreaFlex = flexRatios['cartArea'] ?? 1;
    print('DEBUG POS SCREEN: _buildLandscapeLayout - productAreaFlex: $productAreaFlex, cartAreaFlex: $cartAreaFlex');
    
    return Row(
      children: [
        // Product selection area
        Expanded(
          flex: productAreaFlex,
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
          flex: cartAreaFlex,
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
    final responsive = ResponsiveHelper(context);
    final isHorizontalLayout = !responsive.useColumnLayout;
    
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
                cart: cartState.value ?? cart_entity.Cart(
                  id: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
                onCheckout: () {
                  final cartValue = cartState.value;
                  if (cartValue != null && cartValue.items.isNotEmpty) {
                    if (isHorizontalLayout) {
                      // Show dialog popup in horizontal layout
                      _showCartDialog(cartValue);
                    } else {
                      // Navigate to cart screen in vertical layout
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    }
                  }
                },
                onClear: cartNotifier.clearCart,
              ),
            ),
        ],
      ),
    );
  }

  /// Show cart dialog popup (for horizontal layout)
  void _showCartDialog(cart_entity.Cart cart) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 700,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  const Color(0xFF5E8C52).withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Cart Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                // Cart Items
                Expanded(
                  child: cart.items.isEmpty
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
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return _buildCartItemForDialog(item);
                          },
                        ),
                ),
                // Cart Summary
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Summary Rows
                      _buildDialogSummaryRow(
                        label: 'Subtotal',
                        value: _formatPrice(cart.subtotal.toInt()),
                      ),
                      const SizedBox(height: 8),
                      _buildDialogSummaryRow(
                        label: 'Tax',
                        value: _formatPrice(cart.taxAmount.toInt()),
                      ),
                      const SizedBox(height: 8),
                      _buildDialogSummaryRow(
                        label: 'Discount',
                        value: _formatPrice(cart.discountAmount.toInt()),
                        isDiscount: true,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF5E8C52).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2A),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF5E8C52).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              _formatPrice(cart.totalAmount.toInt()),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Pay Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: cart.items.isEmpty
                              ? null
                              : () {
                                  Navigator.of(dialogContext).pop();
                                  _processPayment(cart);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cart.items.isEmpty
                                ? Colors.grey[300]
                                : null,
                            disabledBackgroundColor: Colors.grey[300],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: cart.items.isEmpty
                              ? const Text(
                                  'Bayar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.payment_rounded,
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Bayar',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
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

  /// Build cart item for dialog
  Widget _buildCartItemForDialog(cart_entity.CartItem item) {
    return FutureBuilder<Product?>(
      future: ref.read(productDaoProvider).getProductById(item.productId),
      builder: (context, snapshot) {
        final product = snapshot.data;
        final productName = product?.name ?? 'Product ${item.productId}';
        
        // Parse notes JSON if available
        Map<String, dynamic>? notesData;
        if (item.notes != null && item.notes!.isNotEmpty) {
          try {
            final notesValue = item.notes;
            if (notesValue != null) {
              notesData = jsonDecode(notesValue) as Map<String, dynamic>;
            }
          } catch (e) {
            // If parsing fails, notesData remains null
          }
        }
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                color: const Color(0xFF5E8C52).withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: const Color(0xFF5E8C52).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Product Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5E8C52).withOpacity(0.15),
                      const Color(0xFFA1B986).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_cafe,
                  size: 28,
                  color: Color(0xFF5E8C52),
                ),
              ),
              const SizedBox(width: 12),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1A1A2A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Display variant if exists
                    if (item.variantId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E8C52).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Variant ${item.variantId}',
                          style: const TextStyle(
                            color: Color(0xFF5E8C52),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    // Display options if available
                    if (notesData != null && notesData.containsKey('options'))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA1B986).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Options: ${_formatOptions(notesData['options'] as Map<String, dynamic>)}',
                          style: const TextStyle(
                            color: Color(0xFF5E8C52),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${item.quantity}x',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF5E8C52),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatPrice(item.totalPrice.toInt()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1A1A2A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Format options for display
  String _formatOptions(Map<String, dynamic> options) {
    final optionsList = <String>[];
    for (final entry in options.entries) {
      final valueIds = entry.value;
      if (valueIds is List && valueIds.isNotEmpty) {
        optionsList.add('${valueIds.length} option(s)');
      }
    }
    return optionsList.join(', ');
  }

  /// Build summary row for dialog
  Widget _buildDialogSummaryRow({
    required String label,
    required String value,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDiscount
                ? const Color(0xFFFF6B6B)
                : const Color(0xFF1A1A2A),
          ),
        ),
      ],
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
        : cartState.value == null || (cartState.value?.items.isEmpty ?? true)
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
                itemCount: cartState.value?.items.length ?? 0,
                itemBuilder: (context, index) {
                  final cartValue = cartState.value;
                  if (cartValue == null || index >= cartValue.items.length) {
                    return const SizedBox.shrink();
                  }
                  final item = cartValue.items[index];
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
      duration: Duration.zero,
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
                  CustomToast.success(
                    context,
                    '${product.name} added to cart',
                    duration: const Duration(seconds: 2),
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
                              _formatPrice(product.price),
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
            final notesValue = item.notes;
            if (notesValue != null) {
              notesData = jsonDecode(notesValue) as Map<String, dynamic>;
            }
          } catch (e) {
            // If parsing fails, notesData remains null
          }
        }
        
        return AnimatedContainer(
          duration: Duration.zero,
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
                              _formatPrice(item.totalPrice.toInt()),
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
    final categoryId = cat?.id;
    if (categoryId == null) return 0;
    return _products.where((p) => p.categoryId == categoryId).length;
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
        final categoryId = cat.id;
        products = products.where((p) => p.categoryId == categoryId).toList();
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
  
    /// Process payment for the cart
    Future<void> _processPayment(cart_entity.Cart cart) async {
      if (cart.items.isEmpty) {
        CustomToast.show(
          context,
          message: 'Cart is empty',
          backgroundColor: const Color(0xFFFF6B6B),
          textColor: Colors.white,
          icon: Icons.error_outline,
        );
        return;
      }
  
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext loadingContext) {
          return const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF5E8C52),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Processing payment...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  
      try {
        // Process the checkout
        await ref.read(cartProvider.notifier).checkout();
  
        // Close loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
  
        // Show success dialog with receipt options
        if (context.mounted) {
          _showPaymentSuccessDialog(cart);
        }
      } catch (e) {
        // Close loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
  
        // Show error message
        if (context.mounted) {
          CustomToast.show(
            context,
            message: 'Payment failed: ${e.toString()}',
            backgroundColor: const Color(0xFFFF6B6B),
            textColor: Colors.white,
            icon: Icons.error_outline,
          );
        }
      }
    }
  
    /// Show payment success dialog with share and print options
    void _showPaymentSuccessDialog(cart_entity.Cart cart) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    const Color(0xFF5E8C52).withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Pembayaran Berhasil!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${_formatPrice(cart.totalAmount.toInt())}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        // Share Nota Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _shareReceipt(cart);
                            },
                            icon: const Icon(Icons.share_rounded, size: 24),
                            label: const Text(
                              'Share Nota',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5E8C52),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Print Nota Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _printReceipt(cart);
                            },
                            icon: const Icon(Icons.print_rounded, size: 24),
                            label: const Text(
                              'Print Nota',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF5E8C52),
                              elevation: 0,
                              side: const BorderSide(
                                color: Color(0xFF5E8C52),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Close Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[600],
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Tutup',
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
                ],
              ),
            ),
          );
        },
      );
    }
  
    /// Share receipt
    Future<void> _shareReceipt(cart_entity.Cart cart) async {
      try {
        print('DEBUG: Starting share receipt process for cart ID: ${cart.id}');
        
        // Generate receipt content
        final receiptService = ref.read(receiptServiceProvider);
        final productDao = ref.read(productDaoProvider);
        
        // Create a mock order for receipt generation
        print('DEBUG: Creating order for receipt generation');
        final order = order_entity.Order(
          id: 0,
          uuid: 'temp-uuid',
          orderNumber: 'POS-${DateTime.now().millisecondsSinceEpoch}',
          subtotal: cart.subtotal.toInt(),
          taxAmount: cart.taxAmount.toInt(),
          discountAmount: cart.discountAmount.toInt(),
          totalAmount: cart.totalAmount.toInt(),
          paidAmount: cart.totalAmount.toInt(),
          changeAmount: 0,
          status: 'paid',
          paymentStatus: 'paid',
          paymentMethod: 'cash',
          orderDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
          syncStatus: 'pending',
          items: await Future.wait(cart.items.map((item) async {
            final product = await productDao.getProductById(item.productId);
            return order_entity.OrderItem(
              id: 0,
              uuid: 'temp-item-uuid',
              orderId: 0,
              productId: item.productId,
              productName: product?.name ?? 'Product ${item.productId}',
              quantity: item.quantity,
              unitPrice: item.unitPrice.toInt(),
              totalPrice: item.totalPrice.toInt(),
              discountAmount: 0,
              notes: item.notes,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: false,
              syncStatus: 'pending',
            );
          }).toList()),
        );
  
        // Ensure business settings are loaded
        final businessSettingsState = ref.read(businessSettingsProvider);
        print('DEBUG RECEIPT: businessSettingsState.settings.isEmpty: ${businessSettingsState.settings.isEmpty}');
        print('DEBUG RECEIPT: businessSettingsState.isLoading: ${businessSettingsState.isLoading}');
        print('DEBUG RECEIPT: businessSettingsState.settings.length: ${businessSettingsState.settings.length}');
        if (businessSettingsState.settings.isEmpty && !businessSettingsState.isLoading) {
          print('DEBUG RECEIPT: Loading business settings...');
          await ref.read(businessSettingsProvider.notifier).loadBusinessSettings();
          print('DEBUG RECEIPT: Business settings loaded');
        }
        final businessSettings = ref.read(businessSettingsProvider).settings.firstOrNull;
        print('DEBUG RECEIPT: businessSettings is null: ${businessSettings == null}');
        if (businessSettings != null) {
          print('DEBUG RECEIPT: businessSettings.storeName: ${businessSettings.storeName}');
          print('DEBUG RECEIPT: businessSettings.address: ${businessSettings.address}');
          print('DEBUG RECEIPT: businessSettings.phoneNumber: ${businessSettings.phoneNumber}');
        }

        // Ensure printer settings are loaded
        final printerSettingsState = ref.read(printerSettingsProvider);
        if (printerSettingsState.settings.isEmpty && !printerSettingsState.isLoading) {
          await ref.read(printerSettingsProvider.notifier).loadPrinterSettings();
        }
        final printerSettings = ref.read(printerSettingsProvider).settings.firstOrNull;
        final receiptContent = await receiptService.generateReceipt(
          order: order,
          businessSettings: businessSettings,
          printerSettings: printerSettings,
        );
        print('DEBUG: Receipt content generated');
        
        // Generate PDF
        print('DEBUG: Generating PDF...');
        final pdfFile = await _generateReceiptPdf(order, receiptContent, businessSettings);
        print('DEBUG: PDF generated at: ${pdfFile.path}');
        
        // Share via WhatsApp
        await _shareViaWhatsApp(pdfFile);
        
        print('DEBUG: Share receipt process completed successfully');
        if (context.mounted) {
          CustomToast.show(
            context,
            message: 'Receipt shared successfully',
            backgroundColor: const Color(0xFF5E8C52),
            textColor: Colors.white,
            icon: Icons.check_circle_outline,
          );
        }
      } catch (e) {
        print('ERROR: Failed to share receipt: ${e.toString()}');
        print('ERROR: Stack trace: ${StackTrace.current}');
        if (context.mounted) {
          CustomToast.show(
            context,
            message: 'Failed to share receipt: ${e.toString()}',
            backgroundColor: const Color(0xFFFF6B6B),
            textColor: Colors.white,
            icon: Icons.error_outline,
          );
        }
      }
    }
    
    /// Generate PDF from receipt
    Future<File> _generateReceiptPdf(order_entity.Order order, String receiptContent, BusinessSettings? businessSettings) async {
      final pdf = pw.Document();
      
      // Parse receipt content to extract information
      final lines = receiptContent.split('\n');
      
      // Create PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 2),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        businessSettings != null ? businessSettings.storeName.toUpperCase() : 'SENTOSA POS',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Receipt',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                
                // Business Info
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        businessSettings != null ? businessSettings.storeName : 'Sentosa Cafe',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(businessSettings != null ? businessSettings.address : '123 Main Street, Jakarta'),
                      pw.Text(businessSettings != null ? 'Phone: ${businessSettings.phoneNumber}' : 'Phone: +62 812 3456'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                
                // Order Info
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Order #:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(order.orderNumber),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Date:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(_formatDate(order.orderDate)),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Time:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(_formatTime(order.orderDate)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                
                // Items
                pw.Container(
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300, width: 1),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: const pw.BorderRadius.only(
                            topLeft: pw.Radius.circular(8),
                            topRight: pw.Radius.circular(8),
                          ),
                        ),
                        child: pw.Text(
                          'Items',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12),
                        child: pw.Column(
                          children: (order.items ?? []).map((item) {
                            return pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 12),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Expanded(
                                        child: pw.Text(
                                          '${item.quantity}x ${item.productName}',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Text(
                                        '\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.variantName != null) ...[
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      '  Variant: ${item.variantName}',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey700,
                                      ),
                                    ),
                                  ],
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    '  Price: \$${item.unitPrice.toStringAsFixed(2)} each',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.grey700,
                                    ),
                                  ),
                                  if (item.notes != null && item.notes!.isNotEmpty) ...[
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      '  Notes: ${item.notes}',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                
                // Totals
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 2),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Subtotal:'),
                          pw.Text('\$${order.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Tax (10%):'),
                          pw.Text('\$${order.taxAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Discount:'),
                          pw.Text('\$${order.discountAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      pw.Divider(),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total:',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                
                // Payment Info
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Payment Information',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Payment Method:'),
                          pw.Text(order.paymentMethod?.toUpperCase() ?? 'CASH'),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Paid:'),
                          pw.Text('\$${order.paidAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Change:'),
                          pw.Text('\$${(order.paidAmount - order.totalAmount).toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),
                
                // Footer
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 2),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Thank you for your purchase!',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text('Please come again soon.'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
      
      // Save PDF to file
      // Use getApplicationDocumentsDirectory() instead of getTemporaryDirectory()
      // because the temporary directory is app-private and not accessible by other apps
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/receipt_${order.orderNumber}.pdf');
      
      print('DEBUG: Saving PDF to: ${file.path}');
      await file.writeAsBytes(await pdf.save());
      
      // Verify file was created successfully
      if (!await file.exists()) {
        throw Exception('PDF file was not created successfully');
      }
      
      print('DEBUG: PDF created successfully, size: ${await file.length()} bytes');
      return file;
    }
    
    /// Share PDF via WhatsApp
    Future<void> _shareViaWhatsApp(File pdfFile) async {
      try {
        print('DEBUG: Starting share process for file: ${pdfFile.path}');
        
        // Verify file exists before sharing
        if (!await pdfFile.exists()) {
          print('ERROR: File does not exist: ${pdfFile.path}');
          throw Exception('PDF file does not exist at: ${pdfFile.path}');
        }
        
        final fileSize = await pdfFile.length();
        print('DEBUG: File exists, size: $fileSize bytes');
        
        if (fileSize == 0) {
          print('ERROR: File is empty: ${pdfFile.path}');
          throw Exception('PDF file is empty');
        }
        
        // Use share_plus to share the PDF file
        // This will open the share sheet where user can select WhatsApp
        print('DEBUG: Calling Share.shareXFiles...');
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          text: 'Here is your receipt from Sentosa Cafe',
          subject: 'Receipt - Sentosa Cafe',
        );
        
        print('DEBUG: Share completed successfully');
      } catch (e) {
        print('ERROR: Failed to share via WhatsApp: ${e.toString()}');
        print('ERROR: Stack trace: ${StackTrace.current}');
        throw Exception('Failed to share via WhatsApp: ${e.toString()}');
      }
    }
    
    /// Format date for display
    String _formatDate(DateTime date) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
    
    /// Format time for display
    String _formatTime(DateTime date) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      final second = date.second.toString().padLeft(2, '0');
      return '$hour:$minute:$second';
    }
  
    /// Print receipt
    Future<void> _printReceipt(cart_entity.Cart cart) async {
      try {
        // Generate receipt content
        final receiptService = ref.read(receiptServiceProvider);
        final productDao = ref.read(productDaoProvider);
        
        // Create a mock order for receipt generation
        final order = order_entity.Order(
          id: 0,
          uuid: 'temp-uuid',
          orderNumber: 'POS-${DateTime.now().millisecondsSinceEpoch}',
          subtotal: cart.subtotal.toInt(),
          taxAmount: cart.taxAmount.toInt(),
          discountAmount: cart.discountAmount.toInt(),
          totalAmount: cart.totalAmount.toInt(),
          paidAmount: cart.totalAmount.toInt(),
          changeAmount: 0,
          status: 'paid',
          paymentStatus: 'paid',
          paymentMethod: 'cash',
          orderDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
          syncStatus: 'pending',
          items: await Future.wait(cart.items.map((item) async {
            final product = await productDao.getProductById(item.productId);
            return order_entity.OrderItem(
              id: 0,
              uuid: 'temp-item-uuid',
              orderId: 0,
              productId: item.productId,
              productName: product?.name ?? 'Product ${item.productId}',
              quantity: item.quantity,
              unitPrice: item.unitPrice.toInt(),
              totalPrice: item.totalPrice.toInt(),
              discountAmount: 0,
              notes: item.notes,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: false,
              syncStatus: 'pending',
            );
          }).toList()),
        );
  
        // Ensure business settings are loaded
        final businessSettingsState = ref.read(businessSettingsProvider);
        print('DEBUG RECEIPT (PRINT): businessSettingsState.settings.isEmpty: ${businessSettingsState.settings.isEmpty}');
        print('DEBUG RECEIPT (PRINT): businessSettingsState.isLoading: ${businessSettingsState.isLoading}');
        print('DEBUG RECEIPT (PRINT): businessSettingsState.settings.length: ${businessSettingsState.settings.length}');
        if (businessSettingsState.settings.isEmpty && !businessSettingsState.isLoading) {
          print('DEBUG RECEIPT (PRINT): Loading business settings...');
          await ref.read(businessSettingsProvider.notifier).loadBusinessSettings();
          print('DEBUG RECEIPT (PRINT): Business settings loaded');
        }
        final businessSettings = ref.read(businessSettingsProvider).settings.firstOrNull;
        print('DEBUG RECEIPT (PRINT): businessSettings is null: ${businessSettings == null}');
        if (businessSettings != null) {
          print('DEBUG RECEIPT (PRINT): businessSettings.storeName: ${businessSettings.storeName}');
          print('DEBUG RECEIPT (PRINT): businessSettings.address: ${businessSettings.address}');
          print('DEBUG RECEIPT (PRINT): businessSettings.phoneNumber: ${businessSettings.phoneNumber}');
        }

        // Ensure printer settings are loaded
        final printerSettingsState = ref.read(printerSettingsProvider);
        if (printerSettingsState.settings.isEmpty && !printerSettingsState.isLoading) {
          await ref.read(printerSettingsProvider.notifier).loadPrinterSettings();
        }
        final printerSettings = ref.read(printerSettingsProvider).settings.firstOrNull;
        final receiptContent = await receiptService.generateReceipt(
          order: order,
          businessSettings: businessSettings,
          printerSettings: printerSettings,
        );
  
        // Show toast notification (placeholder for actual print functionality)
        if (context.mounted) {
          CustomToast.show(
            context,
            message: 'Printing receipt...',
            backgroundColor: const Color(0xFF5E8C52),
            textColor: Colors.white,
            icon: Icons.check_circle_outline,
          );
          
          // Show a dialog indicating print was initiated
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E8C52).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.print_rounded,
                        color: Color(0xFF5E8C52),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Printing Receipt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Receipt is being sent to the printer',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E8C52),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          CustomToast.show(
            context,
            message: 'Failed to print receipt: ${e.toString()}',
            backgroundColor: const Color(0xFFFF6B6B),
            textColor: Colors.white,
            icon: Icons.error_outline,
          );
        }
      }
    }
  }
