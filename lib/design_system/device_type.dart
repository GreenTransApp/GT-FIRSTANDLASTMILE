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

    if (width < 500) return DeviceType.smallPhone;
    if (width < 600) return DeviceType.mediumPhone;
    if (width <= 1024) return DeviceType.largePhone;
    // if (width > 1024) return DeviceType.largePhone;
    return DeviceType.tablet; // Tablets only
  }

  static bool isTablet(BuildContext context) =>
      getType(context) == DeviceType.tablet;
}
