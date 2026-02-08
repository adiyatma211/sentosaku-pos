import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/cart.dart' as cart_entity;
import '../../core/utils/responsive_helper.dart';
import '../providers/cart_provider.dart';
import '../providers/global_providers.dart';
import '../widgets/custom_toast.dart';

/// Shopping Cart Screen
/// Dedicated screen for viewing cart items and checkout
/// Fully responsive for vertical/portrait mode
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Load the cart when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
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
          // Clear cart button
          if (cartState.value?.items.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _showClearCartDialog(cartNotifier),
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cart items list
            Expanded(
              child: _buildCartItems(cartState, responsive),
            ),
            // Cart summary and checkout button
            if (cartState.value != null)
              _buildCartSummary(cartState, cartNotifier),
          ],
        ),
      ),
    );
  }

  /// Build cart items list
  Widget _buildCartItems(
    AsyncValue<cart_entity.Cart> cartState,
    ResponsiveHelper responsive,
  ) {
    return cartState.isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5E8C52),
            ),
          )
        : cartState.value == null || (cartState.value?.items.isEmpty ?? true)
            ? _buildEmptyCart()
            : ListView.builder(
                padding: EdgeInsets.all(responsive.getResponsivePadding(
                  portraitPadding: 16,
                  landscapePadding: 20,
                )),
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

  /// Build empty cart widget
  Widget _buildEmptyCart() {
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
              Icons.shopping_cart_outlined,
              size: 80,
              color: Color(0xFF5E8C52),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from the POS screen',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E8C52),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build cart item
  Widget _buildCartItem(cart_entity.CartItem item) {
    return FutureBuilder(
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
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
            ],
            border: Border.all(
              color: const Color(0xFF5E8C52).withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Product Image/Icon
              Container(
                width: 70,
                height: 70,
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
                  size: 36,
                  color: Color(0xFF5E8C52),
                ),
              ),
              const SizedBox(width: 16),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF1A1A2A),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    // Display options if available
                    if (notesData != null && notesData.containsKey('options'))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA1B986).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Options: ${_formatOptions(notesData['options'] as Map<String, dynamic>)}',
                          style: const TextStyle(
                            color: Color(0xFF5E8C52),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                        Flexible(
                          child: Container(
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
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _formatPrice(item.totalPrice.toInt()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
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
              const SizedBox(width: 8),
              // Remove button
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF6B6B),
                ),
                onPressed: () {
                  ref.read(cartProvider.notifier).removeFromCart(item.id);
                },
                tooltip: 'Remove item',
              ),
            ],
          ),
        );
      },
    );
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

  /// Build cart summary section
  Widget _buildCartSummary(
    AsyncValue<cart_entity.Cart> cartState,
    CartNotifier cartNotifier,
  ) {
    final cart = cartState.value;
    if (cart == null) return const SizedBox.shrink();

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary rows
          _buildSummaryRow(
            label: 'Subtotal',
            value: _formatPrice(cart.subtotal.toInt()),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            label: 'Tax',
            value: _formatPrice(cart.taxAmount.toInt()),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            label: 'Discount',
            value: _formatPrice(cart.discountAmount.toInt()),
            isDiscount: true,
          ),
          const SizedBox(height: 12),
          // Divider
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
          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: cart.items.isEmpty ? null : () => _processCheckout(cart),
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
                      'Checkout',
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
                            'Checkout',
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
    );
  }

  /// Build summary row
  Widget _buildSummaryRow({
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

  /// Show clear cart confirmation dialog
  void _showClearCartDialog(CartNotifier cartNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Clear Cart',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2A),
            ),
          ),
          content: const Text(
            'Are you sure you want to clear all items from your cart?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cartNotifier.clearCart();
                CustomToast.show(
                  context,
                  message: 'Cart cleared',
                  backgroundColor: const Color(0xFF5E8C52),
                  textColor: Colors.white,
                  icon: Icons.check_circle_outline,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Process checkout
  Future<void> _processCheckout(cart_entity.Cart cart) async {
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
      // Process checkout
      await ref.read(cartProvider.notifier).checkout();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message and navigate back
      if (context.mounted) {
        CustomToast.show(
          context,
          message: 'Payment successful!',
          backgroundColor: const Color(0xFF5E8C52),
          textColor: Colors.white,
          icon: Icons.check_circle_outline,
        );
        Navigator.of(context).pop();
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

  /// Format price with thousands separator (Indonesian format)
  String _formatPrice(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(price);
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
}
