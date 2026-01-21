import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cart.dart';

class CartSummaryWidget extends StatelessWidget {
  final Cart cart;
  final VoidCallback? onCheckout;
  final VoidCallback? onClear;

  const CartSummaryWidget({
    super.key,
    required this.cart,
    this.onCheckout,
    this.onClear
  });

  @override
  Widget build(BuildContext context) {
    print('DEBUG CART SUMMARY: Building cart summary widget');
    print('DEBUG CART SUMMARY: Subtotal: ${cart.subtotal}, Tax: ${cart.taxAmount}, Discount: ${cart.discountAmount}, Total: ${cart.totalAmount}');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFF5E8C52).withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E8C52).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF5E8C52).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cart Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Summary Items
            _buildSummaryRow(
              label: 'Items',
              value: '${cart.items.length}',
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              label: 'Subtotal',
              value: NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 2,
              ).format(cart.subtotal),
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              label: 'Tax',
              value: NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 2,
              ).format(cart.taxAmount),
              icon: Icons.percent,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              label: 'Discount',
              value: NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 2,
              ).format(cart.discountAmount),
              icon: Icons.local_offer,
              isDiscount: true,
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            // Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF5E8C52).withOpacity(0.1),
                    const Color(0xFFA1B986).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF5E8C52).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
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
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp',
                        decimalDigits: 2,
                      ).format(cart.totalAmount),
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
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    onPressed: onClear,
                    label: 'Clear',
                    icon: Icons.delete_outline,
                    isSecondary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    onPressed: onCheckout,
                    label: 'Checkout',
                    icon: Icons.shopping_cart_checkout,
                    isSecondary: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required IconData icon,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDiscount
                    ? const Color(0xFFFF6B6B).withOpacity(0.1)
                    : const Color(0xFF5E8C52).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isDiscount
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF5E8C52),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
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

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    required bool isSecondary,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSecondary
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF5E8C52).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: isSecondary
              ? Colors.grey.withOpacity(0.1)
              : const Color(0xFF5E8C52).withOpacity(0.2),
          highlightColor: isSecondary
              ? Colors.grey.withOpacity(0.05)
              : const Color(0xFF5E8C52).withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              gradient: isSecondary
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFF5E8C52), Color(0xFFA1B986)],
                    ),
              color: isSecondary ? Colors.white : null,
              borderRadius: BorderRadius.circular(16),
              border: isSecondary
                  ? Border.all(
                      color: const Color(0xFF5E8C52).withOpacity(0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSecondary
                      ? const Color(0xFF5E8C52)
                      : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isSecondary
                        ? const Color(0xFF5E8C52)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}