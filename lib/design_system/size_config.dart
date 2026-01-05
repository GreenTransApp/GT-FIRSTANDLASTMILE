import 'package:flutter/widgets.dart';
import 'package:gtlmd/design_system/app_spacing.dart';
import 'package:gtlmd/design_system/app_text_sizes.dart';
import 'package:gtlmd/design_system/icons_sizes.dart';
import 'package:gtlmd/design_system/radius_sizes.dart';
import 'device_type.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late DeviceType deviceType;
  static double extraSmallHorizontalPadding = 0;
  static double extraSmallVerticalPadding = 0;
  static double smallHorizontalPadding = 0;
  static double smallVerticalPadding = 0;
  static double horizontalPadding = 0;
  static double verticalPadding = 0;
  static double largeHorizontalPadding = 0;
  static double largeVerticalPadding = 0;
  static double extraLargeHorizontalPadding = 0;
  static double extraLargeVerticalPadding = 0;

  static double extraSmallTextSize = 0;
  static double smallTextSize = 0;
  static double mediumTextSize = 0;
  static double largeTextSize = 0;

  static double extraSmallVerticalSpacing = 0;
  static double smallVerticalSpacing = 0;
  static double mediumVerticalSpacing = 0;
  static double largeVerticalSpacing = 0;

  static double extraSmallHorizontalSpacing = 0;
  static double smallHorizontalSpacing = 0;
  static double mediumHorizontalSpacing = 0;
  static double largeHorizontalSpacing = 0;

  static double extraSmallIconSize = 0;
  static double smallIconSize = 0;
  static double mediumIconSize = 0;
  static double largeIconSize = 0;
  static double extraLargeIconSize = 0;

  static double smallRadius = 0;
  static double mediumRadius = 0;
  static double largeRadius = 0;
  static double extraLargeRadius = 0;
  static double extraExtraLargeRadius = 0;

  static void init(BuildContext context) {
    final media = MediaQuery.of(context);

    screenWidth = media.size.width;
    screenHeight = media.size.height;
    deviceType = DeviceInfo.getType(context);
    debugPrint("Device Type: $deviceType");
    extraSmallHorizontalPadding = getExtraSmallHorizontalPadding();
    extraSmallVerticalPadding = getExtraSmallVerticalPadding();
    smallHorizontalPadding = getSmallHorizontalPadding();
    smallVerticalPadding = getSmallVerticalPadding();
    horizontalPadding = getHorizontalPadding();
    verticalPadding = getVerticalPadding();
    largeHorizontalPadding = getLargeHorizontalPadding();
    largeVerticalPadding = getLargeVerticalPadding();
    extraLargeHorizontalPadding = getExtraLargeHorizontalPadding();
    extraLargeVerticalPadding = getExtraLargeVerticalPadding();
    extraSmallTextSize = getTextSizeExtraSmall();
    smallTextSize = getTextSizeSmall();
    mediumTextSize = getTextSizeMedium();
    largeTextSize = getTextSizeLarge();
    extraSmallVerticalSpacing = getExtraSmallVerticalSpacing();
    smallVerticalSpacing = getSmallVerticalSpacing();
    mediumVerticalSpacing = getMediumVerticalSpacing();
    largeVerticalSpacing = getLargeVerticalSpacing();
    extraSmallHorizontalSpacing = getExtraSmallHorizontalSpacing();
    smallHorizontalSpacing = getSmallHorizontalSpacing();
    mediumHorizontalSpacing = getMediumHorizontalSpacing();
    largeHorizontalSpacing = getLargeHorizontalSpacing();
    extraSmallIconSize = getExtraSmallIconSize();
    smallIconSize = getSmallIconSize();
    mediumIconSize = getMediumIconSize();
    largeIconSize = getLargeIconSize();
    extraLargeIconSize = getExtraLargeIconSize();

    smallRadius = getSmallRadius();
    mediumRadius = getMediumRadius();
    largeRadius = getLargeRadius();
    extraLargeRadius = getExtraExtraLargeRadius();
  }

  /// Base scale only for mobile devices
  static double scale(double size) {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return size * 0.9;
      case DeviceType.mediumPhone:
        return size;
      case DeviceType.largePhone:
        return size * 1.1;
      case DeviceType.tablet:
        return size * 1.25;
    }
  }

  static double getExtraSmallHorizontalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.two;
      case DeviceType.mediumPhone:
        return AppSpacing.four;
      case DeviceType.largePhone:
        return AppSpacing.eight;
      case DeviceType.tablet:
        return AppSpacing.ten;
    }
  }

  static double getExtraSmallVerticalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.two;
      case DeviceType.mediumPhone:
        return AppSpacing.four;
      case DeviceType.largePhone:
        return AppSpacing.eight;
      case DeviceType.tablet:
        return AppSpacing.ten;
    }
  }

  static double getSmallHorizontalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.four;
      case DeviceType.mediumPhone:
        return AppSpacing.eight;
      case DeviceType.largePhone:
        return AppSpacing.twelve;
      case DeviceType.tablet:
        return AppSpacing.sixteen;
    }
  }

  static double getSmallVerticalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.four;
      case DeviceType.mediumPhone:
        return AppSpacing.eight;
      case DeviceType.largePhone:
        return AppSpacing.twelve;
      case DeviceType.tablet:
        return AppSpacing.sixteen;
    }
  }

  static double getHorizontalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.eight;
      case DeviceType.mediumPhone:
        return AppSpacing.twelve;
      case DeviceType.largePhone:
        return AppSpacing.sixteen;
      case DeviceType.tablet:
        return AppSpacing.twentyFour;
    }
  }

  static double getVerticalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.eight;
      case DeviceType.mediumPhone:
        return AppSpacing.twelve;
      case DeviceType.largePhone:
        return AppSpacing.sixteen;
      case DeviceType.tablet:
        return AppSpacing.twentyFour;
    }
  }

  static double getLargeHorizontalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twelve;
      case DeviceType.mediumPhone:
        return AppSpacing.twentyFour;
      case DeviceType.largePhone:
        return AppSpacing.thirtyTwo;
      case DeviceType.tablet:
        return AppSpacing.sixtyFour;
    }
  }

  static double getLargeVerticalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twelve;
      case DeviceType.mediumPhone:
        return AppSpacing.twentyFour;
      case DeviceType.largePhone:
        return AppSpacing.thirtyTwo;
      case DeviceType.tablet:
        return AppSpacing.sixtyFour;
    }
  }

  static double getExtraLargeHorizontalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twentyFour;
      case DeviceType.mediumPhone:
        return AppSpacing.thirtyTwo;
      case DeviceType.largePhone:
        return AppSpacing.fortyEight;
      case DeviceType.tablet:
        return AppSpacing.ninetySix;
    }
  }

  static double getExtraLargeVerticalPadding() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twentyFour;
      case DeviceType.mediumPhone:
        return AppSpacing.thirtyTwo;
      case DeviceType.largePhone:
        return AppSpacing.fortyEight;
      case DeviceType.tablet:
        return AppSpacing.ninetySix;
    }
  }

  static double getTextSizeExtraSmall() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppTextSizes.ten;
      case DeviceType.mediumPhone:
        return AppTextSizes.twelve;
      case DeviceType.largePhone:
        return AppTextSizes.fourteen;
      case DeviceType.tablet:
        return AppSpacing.sixteen;
    }
  }

  static double getTextSizeSmall() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppTextSizes.twelve;
      case DeviceType.mediumPhone:
        return AppTextSizes.fourteen;
      case DeviceType.largePhone:
        return AppTextSizes.sixteen;
      case DeviceType.tablet:
        return AppTextSizes.eighteen;
    }
  }

  static double getTextSizeMedium() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppTextSizes.fourteen;
      case DeviceType.mediumPhone:
        return AppTextSizes.sixteen;
      case DeviceType.largePhone:
        return AppTextSizes.eighteen;
      case DeviceType.tablet:
        return AppTextSizes.twenty;
    }
  }

  static double getTextSizeLarge() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppTextSizes.sixteen;
      case DeviceType.mediumPhone:
        return AppTextSizes.eighteen;
      case DeviceType.largePhone:
        return AppTextSizes.twenty;
      case DeviceType.tablet:
        return AppTextSizes.twentyFour;
    }
  }

  static double getExtraSmallVerticalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.four;
      case DeviceType.mediumPhone:
        return AppSpacing.eight;
      case DeviceType.largePhone:
        return AppSpacing.twelve;
      case DeviceType.tablet:
        return AppSpacing.sixteen;
    }
  }

  static double getSmallVerticalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.eight;
      case DeviceType.mediumPhone:
        return AppSpacing.twelve;
      case DeviceType.largePhone:
        return AppSpacing.sixteen;
      case DeviceType.tablet:
        return AppSpacing.twentyFour;
    }
  }

  static double getMediumVerticalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twelve;
      case DeviceType.mediumPhone:
        return AppSpacing.sixteen;
      case DeviceType.largePhone:
        return AppSpacing.twentyFour;
      case DeviceType.tablet:
        return AppSpacing.thirtyTwo;
    }
  }

  static double getLargeVerticalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twentyFour;
      case DeviceType.mediumPhone:
        return AppSpacing.thirtyTwo;
      case DeviceType.largePhone:
        return AppSpacing.forty;
      case DeviceType.tablet:
        return AppSpacing.sixtyFour;
    }
  }

  static double getExtraSmallHorizontalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.four;
      case DeviceType.mediumPhone:
        return AppSpacing.eight;
      case DeviceType.largePhone:
        return AppSpacing.twelve;
      case DeviceType.tablet:
        return AppSpacing.sixteen;
    }
  }

  static double getSmallHorizontalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.eight;
      case DeviceType.mediumPhone:
        return AppSpacing.twelve;
      case DeviceType.largePhone:
        return AppSpacing.sixteen;
      case DeviceType.tablet:
        return AppSpacing.twentyFour;
    }
  }

  static double getMediumHorizontalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twelve;
      case DeviceType.mediumPhone:
        return AppSpacing.sixteen;
      case DeviceType.largePhone:
        return AppSpacing.twentyFour;
      case DeviceType.tablet:
        return AppSpacing.thirtyTwo;
    }
  }

  static double getLargeHorizontalSpacing() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return AppSpacing.twentyFour;
      case DeviceType.mediumPhone:
        return AppSpacing.thirtyTwo;
      case DeviceType.largePhone:
        return AppSpacing.forty;
      case DeviceType.tablet:
        return AppSpacing.sixtyFour;
    }
  }

  static double getExtraSmallIconSize() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return IconSizes.ten;
      case DeviceType.mediumPhone:
        return IconSizes.twelve;
      case DeviceType.largePhone:
        return IconSizes.fourteen;
      case DeviceType.tablet:
        return IconSizes.sixteen;
    }
  }

  static double getSmallIconSize() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return IconSizes.twelve;
      case DeviceType.mediumPhone:
        return IconSizes.fourteen;
      case DeviceType.largePhone:
        return IconSizes.sixteen;
      case DeviceType.tablet:
        return IconSizes.eighteen;
    }
  }

  static double getMediumIconSize() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return IconSizes.fourteen;
      case DeviceType.mediumPhone:
        return IconSizes.sixteen;
      case DeviceType.largePhone:
        return IconSizes.eighteen;
      case DeviceType.tablet:
        return IconSizes.twenty;
    }
  }

  static double getLargeIconSize() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return IconSizes.sixteen;
      case DeviceType.mediumPhone:
        return IconSizes.eighteen;
      case DeviceType.largePhone:
        return IconSizes.twenty;
      case DeviceType.tablet:
        return IconSizes.twentyFour;
    }
  }

  static double getExtraLargeIconSize() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return IconSizes.eighteen;
      case DeviceType.mediumPhone:
        return IconSizes.twenty;
      case DeviceType.largePhone:
        return IconSizes.twentyTwo;
      case DeviceType.tablet:
        return IconSizes.twentyFour;
    }
  }

  static double getSmallRadius() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return RadiusSizes.two;
      case DeviceType.mediumPhone:
        return RadiusSizes.four;
      case DeviceType.largePhone:
        return RadiusSizes.six;
      case DeviceType.tablet:
        return RadiusSizes.eight;
    }
  }

  static double getMediumRadius() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return RadiusSizes.four;
      case DeviceType.mediumPhone:
        return RadiusSizes.eight;
      case DeviceType.largePhone:
        return RadiusSizes.twelve;
      case DeviceType.tablet:
        return RadiusSizes.sixteen;
    }
  }

  static double getLargeRadius() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return RadiusSizes.six;
      case DeviceType.mediumPhone:
        return RadiusSizes.twelve;
      case DeviceType.largePhone:
        return RadiusSizes.twenty;
      case DeviceType.tablet:
        return RadiusSizes.twentyFour;
    }
  }

  static double getExtraLargeRadius() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return RadiusSizes.twelve;
      case DeviceType.mediumPhone:
        return RadiusSizes.sixteen;
      case DeviceType.largePhone:
        return RadiusSizes.twentyFour;
      case DeviceType.tablet:
        return RadiusSizes.thirtyTwo;
    }
  }

  static double getExtraExtraLargeRadius() {
    switch (deviceType) {
      case DeviceType.smallPhone:
        return RadiusSizes.twentyFour;
      case DeviceType.mediumPhone:
        return RadiusSizes.twentyEight;
      case DeviceType.largePhone:
        return RadiusSizes.thirtyTwo;
      case DeviceType.tablet:
        return RadiusSizes.thirtySix;
    }
  }
}
