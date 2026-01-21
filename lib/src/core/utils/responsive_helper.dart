import 'package:flutter/material.dart';

/// Responsive design utility helper for consistent sizing across the app
/// Supports both portrait and landscape orientations for iPhone devices (X to 17)
class ResponsiveHelper {
  ResponsiveHelper(this.context);

  final BuildContext context;

  /// Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Get orientation
  Orientation get orientation => MediaQuery.of(context).orientation;

  /// Check if device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// Check if device is a small screen (iPhone X, SE, etc.)
  bool get isSmallScreen => screenWidth < 375;

  /// Check if device is a medium screen (iPhone 11, 12, 13, etc.)
  bool get isMediumScreen => screenWidth >= 375 && screenWidth < 414;

  /// Check if device is a large screen (iPhone 14 Pro Max, 15 Pro Max, 16/17 Plus)
  bool get isLargeScreen => screenWidth >= 414;

  /// Get responsive grid columns based on screen width and orientation
  int getGridColumns({
    int portraitColumns = 2,
    int landscapeColumns = 4,
  }) {
    if (isPortrait) {
      if (isSmallScreen) {
        return portraitColumns > 1 ? portraitColumns - 1 : 1;
      }
      return portraitColumns;
    } else {
      return landscapeColumns;
    }
  }

  /// Get responsive grid columns for product cards
  int getProductGridColumns() {
    if (isPortrait) {
      if (isSmallScreen) {
        return 2;
      } else if (isMediumScreen) {
        return 2;
      } else {
        return 2;
      }
    } else {
      return 3;
    }
  }

  /// Get responsive grid columns for dashboard menu
  int getDashboardGridColumns() {
    if (isPortrait) {
      if (isSmallScreen) {
        return 2;
      } else if (isMediumScreen) {
        return 2;
      } else {
        return 2;
      }
    } else {
      return 4;
    }
  }

  /// Get responsive grid columns for category cards
  int getCategoryGridColumns() {
    if (isPortrait) {
      if (isSmallScreen) {
        return 1;
      } else if (isMediumScreen) {
        return 2;
      } else {
        return 2;
      }
    } else {
      return 2;
    }
  }

  /// Get responsive padding
  double getResponsivePadding({
    double portraitPadding = 16.0,
    double landscapePadding = 20.0,
  }) {
    return isPortrait ? portraitPadding : landscapePadding;
  }

  /// Get responsive font size
  double getResponsiveFontSize({
    double portraitSize = 14.0,
    double landscapeSize = 16.0,
  }) {
    if (isSmallScreen) {
      return portraitSize * 0.9;
    }
    return isPortrait ? portraitSize : landscapeSize;
  }

  /// Get responsive spacing
  double getResponsiveSpacing({
    double portraitSpacing = 8.0,
    double landscapeSpacing = 12.0,
  }) {
    return isPortrait ? portraitSpacing : landscapeSpacing;
  }

  /// Get responsive card aspect ratio
  double getCardAspectRatio() {
    if (isPortrait) {
      // Increased from 0.92 to 0.78 to provide more height and prevent 43px overflow
      return 0.78;
    } else {
      return 0.95;
    }
  }

  /// Get responsive flex ratio for POS screen layout
  Map<String, int> getPOSFlexRatios() {
    if (isPortrait) {
      // In portrait, cart takes more space at bottom
      return {
        'productArea': 1,
        'cartArea': 1,
      };
    } else {
      // In landscape, product area takes more space
      return {
        'productArea': 2,
        'cartArea': 1,
      };
    }
  }

  /// Check if should use column layout instead of row
  bool get useColumnLayout => isPortrait;

  /// Get responsive icon size
  double getResponsiveIconSize({
    double portraitSize = 24.0,
    double landscapeSize = 28.0,
  }) {
    if (isSmallScreen) {
      return portraitSize * 0.9;
    }
    return isPortrait ? portraitSize : landscapeSize;
  }

  /// Get responsive border radius
  double getResponsiveBorderRadius({
    double portraitRadius = 12.0,
    double landscapeRadius = 16.0,
  }) {
    return isPortrait ? portraitRadius : landscapeRadius;
  }

  /// Get responsive elevation
  double getResponsiveElevation({
    double portraitElevation = 4.0,
    double landscapeElevation = 6.0,
  }) {
    return isPortrait ? portraitElevation : landscapeElevation;
  }
}
