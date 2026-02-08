import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import '../providers/global_providers.dart';
import '../providers/cart_provider.dart';

/// Dialog for customizing product quantity and ingredients before adding to cart
class ProductCustomizationDialog extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCustomizationDialog({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  ConsumerState<ProductCustomizationDialog> createState() =>
      _ProductCustomizationDialogState();
}

class _ProductCustomizationDialogState
    extends ConsumerState<ProductCustomizationDialog> {
  int _quantity = 1;
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> _productOptions = []; // Product options with values
  bool _isLoading = true;
  Map<int, Set<String>> _ingredientOptions = {}; // Store selected options for each ingredient (multiple selection allowed)
  Map<int, Set<int>> _selectedOptionValues = {}; // Store selected values for each option (supports both single and multiple selection)
  final TextEditingController _notesController = TextEditingController();
  
  // Hover state tracking
  Set<String> _hoveredProductOptions = {}; // Track hovered product option values (format: "optionId_valueId")
  Set<String> _hoveredIngredientOptions = {}; // Track hovered ingredient options (format: "ingredientId_optionName")
  
  // Preset options for ingredients
  static const Map<String, double> _presetOptions = {
    'Less Sugar': 0.5,
    'Normal': 1.0,
    'No Sugar': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipeDao = ref.read(recipeDaoProvider);
      final productOptionDao = ref.read(productOptionDaoProvider);
      
      // Load recipes
      final recipes = await recipeDao.getRecipesWithIngredients(widget.product.id);
      
      // Load product options with their values
      final options = await productOptionDao.getProductOptionsWithValues(widget.product.id);
      
      setState(() {
        _recipes = recipes;
        _productOptions = options;
        _isLoading = false;
        // Initialize ingredient options with default values
        for (var recipe in recipes) {
          final recipeData = recipe['recipe'] as Recipe;
          _ingredientOptions[recipeData.ingredientId] = {'Normal'};
        }
        // Product options are NOT initialized with default values - users must explicitly select them
        // This ensures all options are unchecked by default when the dialog opens
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _updateIngredientOption(int ingredientId, String option) {
    setState(() {
      final currentOptions = _ingredientOptions[ingredientId] ?? <String>{};
      if (currentOptions.contains(option)) {
        // Remove option if already selected (toggle off)
        currentOptions.remove(option);
      } else {
        // Add option if not selected (toggle on)
        currentOptions.add(option);
      }
      _ingredientOptions[ingredientId] = currentOptions;
    });
  }

  void _updateProductOption(int optionId, int valueId) {
    setState(() {
      // Get the current selected values for this option
      final currentValues = _selectedOptionValues[optionId] ?? <int>{};
      
      // Check if this value is already selected
      if (currentValues.contains(valueId)) {
        // Remove the value (deselect)
        currentValues.remove(valueId);
        _selectedOptionValues[optionId] = currentValues;
      } else {
        // Add the value (select)
        currentValues.add(valueId);
        _selectedOptionValues[optionId] = currentValues;
      }
    });
  }

  void _addToCart() {
    print('DEBUG DIALOG: _addToCart() called - Product: ${widget.product.name}, Quantity: $_quantity');
    
    // Build notes data combining ingredient options, product options, and custom notes
    Map<String, dynamic> notesData = {};
    
    // Add ingredient options if any
    if (_ingredientOptions.isNotEmpty) {
      final ingredientData = <String, dynamic>{};
      _ingredientOptions.forEach((ingredientId, options) {
        for (var option in options) {
          ingredientData['${ingredientId}_$option'] = _presetOptions[option] ?? 1.0;
        }
      });
      notesData['ingredients'] = ingredientData;
    }
    
    // Add product options if any
    if (_selectedOptionValues.isNotEmpty) {
      final optionData = <String, dynamic>{};
      _selectedOptionValues.forEach((optionId, valueIds) {
        if (valueIds.isNotEmpty) {
          // Store all selected value IDs as a list
          optionData['$optionId'] = valueIds.toList();
        }
      });
      notesData['options'] = optionData;
    }
    
    // Add custom notes if user entered any
    if (_notesController.text.trim().isNotEmpty) {
      notesData['customNotes'] = _notesController.text.trim();
    }
    
    // Convert to JSON string only if there's data
    String? notes;
    if (notesData.isNotEmpty) {
      notes = jsonEncode(notesData);
    }
    
    print('DEBUG DIALOG: Calling cartProvider.addToCart() - Product ID: ${widget.product.id}, Quantity: $_quantity, Notes: $notes');
    
    // Add to cart with custom quantity, ingredients, options, and notes
    ref.read(cartProvider.notifier).addToCart(
      productId: widget.product.id,
      quantity: _quantity,
      notes: notes,
    );
    
    print('DEBUG DIALOG: cartProvider.addToCart() called (NOT awaited)');
    print('DEBUG DIALOG: Calling widget.onAddToCart()');
    widget.onAddToCart();
    print('DEBUG DIALOG: Closing dialog with Navigator.pop()');
    Navigator.pop(context);
    print('DEBUG DIALOG: Dialog closed');
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  int _calculateTotalPrice() {
    int basePrice = widget.product.price;
    
    // Add price adjustments from selected product options
    for (var optionData in _productOptions) {
      final option = optionData['option'] as ProductOption;
      final selectedValues = _selectedOptionValues[option.id] ?? <int>{};
      if (selectedValues.isNotEmpty) {
        final values = optionData['values'] as List<ProductOptionValue>;
        for (var selectedValueId in selectedValues) {
          final selectedValue = values.firstWhere(
            (v) => v.id == selectedValueId,
            orElse: () => values.first,
          );
          basePrice += selectedValue.priceAdjustment;
        }
      }
    }
    
    return basePrice * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info
                    _buildProductInfo(),
                    const SizedBox(height: 24),
                    
                    // Quantity Selector
                    _buildQuantitySelector(),
                    const SizedBox(height: 24),
                    
                    // Product Options Section - Only show if options exist
                    if (_productOptions.isNotEmpty) ...[
                      _buildProductOptionsSection(),
                      const SizedBox(height: 24),
                    ],
                    
                    // Ingredients Section - Only show if recipes exist
                    if (_recipes.isNotEmpty) ...[
                      _buildIngredientsSection(),
                      const SizedBox(height: 24),
                    ],
                    
                    // Keterangan (Custom Notes) Section
                    _buildNotesSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Footer with Add to Cart button
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Expanded(
            child: Text(
              'Customize Product',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5E8C52).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_cafe,
              size: 32,
              color: Color(0xFF5E8C52),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF1A1A2A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product.description ?? 'No description',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatPrice(widget.product.price)}',
                  style: const TextStyle(
                    color: Color(0xFF5E8C52),
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Quantity',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1A1A2A),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F0),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 6,
                    offset: const Offset(-2, -2),
                  ),
                  BoxShadow(
                    color: const Color(0xFFD1D9D1).withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                '$_quantity item${_quantity > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF5E8C52),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE0E8E0).withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD1D9D1).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNeumorphicButton(
                icon: Icons.remove_rounded,
                onPressed: _decrementQuantity,
                isEnabled: _quantity > 1,
              ),
              const SizedBox(width: 20),
              Container(
                width: 80,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5E8C52).withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD1D9D1).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Color(0xFF1A1A2A),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _buildNeumorphicButton(
                icon: Icons.add_rounded,
                onPressed: _incrementQuantity,
                isEnabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNeumorphicButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        splashColor: isEnabled
            ? const Color(0xFF5E8C52).withValues(alpha: 0.15)
            : Colors.transparent,
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEnabled
                  ? const Color(0xFF5E8C52).withValues(alpha: 0.3)
                  : const Color(0xFFB0B8B0).withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD1D9D1).withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 30,
            color: isEnabled
                ? const Color(0xFF5E8C52)
                : const Color(0xFFB0B8B0),
          ),
        ),
      ),
    );
  }

  Widget _buildProductOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Options',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF1A1A2A),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5E8C52),
            ),
          )
        else if (_productOptions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF5E8C52).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'No product options available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ..._productOptions.map((optionData) {
            final option = optionData['option'] as ProductOption;
            final values = optionData['values'] as List<ProductOptionValue>;
            final selectedValues = _selectedOptionValues[option.id] ?? <int>{};
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF5E8C52).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF5E8C52).withOpacity(0.15),
                              const Color(0xFFA1B986).withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune,
                          size: 20,
                          color: Color(0xFF5E8C52),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF1A1A2A),
                              ),
                            ),
                            Text(
                              option.selectionType == 'single' ? 'Select one option' : 'Select multiple options',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Option values (checkboxes or radio buttons based on selection type)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: values.map((value) {
                      final isSelected = selectedValues.contains(value.id);
                      final priceText = value.priceAdjustment != 0
                          ? (value.priceAdjustment > 0 ? '+Rp ${_formatPrice(value.priceAdjustment)}' : '-Rp ${_formatPrice(value.priceAdjustment.abs())}')
                          : '';
                      final hoverKey = '${option.id}_${value.id}';
                      final isHovered = _hoveredProductOptions.contains(hoverKey);
                       
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            _hoveredProductOptions.add(hoverKey);
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _hoveredProductOptions.remove(hoverKey);
                          });
                        },
                        child: GestureDetector(
                          onTap: () => _updateProductOption(option.id, value.id),
                          child: AnimatedContainer(
                            duration: Duration.zero,
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                  : (isHovered
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xFF5E8C52).withOpacity(0.1),
                                            const Color(0xFFA1B986).withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null),
                              color: isSelected
                                ? null
                                : (isHovered ? const Color(0xFFE8F0E8) : const Color(0xFFF5F7FA)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : (isHovered
                                        ? const Color(0xFF5E8C52).withOpacity(0.5)
                                        : const Color(0xFF5E8C52).withOpacity(0.2)),
                                width: isSelected ? 0 : (isHovered ? 2 : 1.5),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF5E8C52).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : (isHovered
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF5E8C52).withOpacity(0.15),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.03),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]),
                            ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (option.selectionType == 'single') ...[
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: isSelected ? Colors.white : const Color(0xFF5E8C52),
                                  size: 20,
                                ),
                              ] else ...[
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _updateProductOption(option.id, value.id),
                                  activeColor: Colors.white,
                                  checkColor: Colors.white,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  value.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : const Color(0xFF1A1A2A),
                                  ),
                                ),
                              ),
                              if (priceText.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                              : (isHovered
                                                  ? Colors.green.withOpacity(0.15)
                                                  : ((value.priceAdjustment ?? 0) > 0
                                                      ? Colors.green.withOpacity(0.1)
                                                      : Colors.red.withOpacity(0.1))),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    priceText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: isSelected ? Colors.white : const Color(0xFF5E8C52),
                                    ),
                                  ),
                                ),
                              ],
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  ),
                ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF1A1A2A),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5E8C52),
            ),
          )
        else if (_recipes.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF5E8C52).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'No custom ingredients available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ..._recipes.map((recipeData) {
            final ingredient = recipeData['ingredient'] as Ingredient;
            final currentOptions = _ingredientOptions[ingredient.id] ?? <String>{};
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF5E8C52).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF5E8C52).withOpacity(0.15),
                              const Color(0xFFA1B986).withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          size: 20,
                          color: Color(0xFF5E8C52),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ingredient.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF1A1A2A),
                              ),
                            ),
                            if (ingredient.description != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                ingredient.description!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Preset options (checkboxes for multiple selection)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presetOptions.entries.map((entry) {
                      final isSelected = currentOptions.contains(entry.key);
                      final hoverKey = '${ingredient.id}_${entry.key}';
                      final isHovered = _hoveredIngredientOptions.contains(hoverKey);
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            _hoveredIngredientOptions.add(hoverKey);
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _hoveredIngredientOptions.remove(hoverKey);
                          });
                        },
                        child: GestureDetector(
                          onTap: () => _updateIngredientOption(ingredient.id, entry.key),
                          child: AnimatedContainer(
                            duration: Duration.zero,
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                    ? const LinearGradient(
                                      colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : (isHovered
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xFF5E8C52).withOpacity(0.1),
                                            const Color(0xFFA1B986).withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null),
                              color: isSelected
                                  ? null
                                  : (isHovered ? const Color(0xFFE8F0E8) : const Color(0xFFF5F7FA)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : (isHovered
                                        ? const Color(0xFF5E8C52).withOpacity(0.5)
                                        : const Color(0xFF5E8C52).withOpacity(0.2)),
                                width: isSelected ? 0 : (isHovered ? 2 : 1.5),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF5E8C52).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : (isHovered
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF5E8C52).withOpacity(0.15),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.03),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]),
                            ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) => _updateIngredientOption(ingredient.id, entry.key),
                                activeColor: Colors.white,
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.key,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isSelected ? Colors.white : const Color(0xFF1A1A2A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Keterangan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF1A1A2A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF5E8C52).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 3,
            maxLength: 200,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1A1A2A),
            ),
            decoration: InputDecoration(
              hintText: 'Tambahkan keterangan kustom...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Rp ${_formatPrice(_calculateTotalPrice())}',
                    style: const TextStyle(
                      color: Color(0xFF5E8C52),
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E8C52),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

