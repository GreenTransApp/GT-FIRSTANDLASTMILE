import 'package:flutter/widgets.dart';

enum DeviceType {
  smallPhone,
  mediumPhone,
  largePhone,
  tablet,
}

class DeviceInfo {
  static DeviceType getType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    debugPrint('Device Width: $width');
    debugPrint('Device Height: ${MediaQuery.of(context).size.height}');

     final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;

    debugPrint('Width: ${size.width}');
    debugPrint('Height: ${size.height}');
    debugPrint('ShortestSide: $shortestSide');

    // if (width < 500) return DeviceType.smallPhone;
    // if (width < 600) return DeviceType.mediumPhone;
    // if (width <= 1024) return DeviceType.largePhone;
    // // if (width > 1024) return DeviceType.largePhone;
    // return DeviceType.tablet; // Tablets only
    if (shortestSide >= 600) {
      return DeviceType.tablet;
    }

    if (shortestSide < 360) {
      return DeviceType.smallPhone;
    }

    if (shortestSide < 400) {
      return DeviceType.mediumPhone;
    }

    return DeviceType.largePhone;
  
  }

  static bool isTablet(BuildContext context) =>
      getType(context) == DeviceType.tablet;
}
