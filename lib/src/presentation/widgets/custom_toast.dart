import 'package:flutter/material.dart';

class CustomToast {
  static void show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.bottom,
  }) {
    final overlay = Overlay.of(context);
    
    final overlayEntry = OverlayEntry(
      builder: (context) => _buildToast(
        context,
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
        gravity: gravity,
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  /// Show a success toast with green styling
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.bottom,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      icon: Icons.check_circle,
      duration: duration,
      gravity: gravity,
    );
  }

  /// Show an error toast with red styling
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.bottom,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFE53935),
      textColor: Colors.white,
      icon: Icons.error,
      duration: duration,
      gravity: gravity,
    );
  }

  /// Show a warning toast with orange styling
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.bottom,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFFF9800),
      textColor: Colors.white,
      icon: Icons.warning,
      duration: duration,
      gravity: gravity,
    );
  }

  /// Show an info toast with blue styling
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.bottom,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF2196F3),
      textColor: Colors.white,
      icon: Icons.info,
      duration: duration,
      gravity: gravity,
    );
  }

  static Widget _buildToast(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required ToastGravity gravity,
  }) {
    double top = 0;
    double bottom = 0;
    
    switch (gravity) {
      case ToastGravity.top:
        top = 80;
        break;
      case ToastGravity.bottom:
        bottom = 80;
        break;
      case ToastGravity.center:
        // Center positioning handled by alignment
        break;
    }

    if (gravity == ToastGravity.center) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration.zero,
            curve: Curves.easeOutCubic,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: Opacity(
                  opacity: animationValue,
                  child: _buildToastContent(
                    message: message,
                    backgroundColor: backgroundColor,
                    textColor: textColor,
                    icon: icon,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Positioned(
      top: top > 0 ? top : null,
      bottom: bottom > 0 ? bottom : null,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration.zero,
          curve: Curves.easeOutCubic,
          builder: (context, animationValue, child) {
            return Transform.translate(
              offset: Offset(0, gravity == ToastGravity.top 
                  ? -50 * (1 - animationValue) 
                  : 50 * (1 - animationValue)),
              child: Opacity(
                opacity: animationValue,
                child: _buildToastContent(
                  message: message,
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                  icon: icon,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildToastContent({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

enum ToastGravity {
  top,
  bottom,
  center,
}
