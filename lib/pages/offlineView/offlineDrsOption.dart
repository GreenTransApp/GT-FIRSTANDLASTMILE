import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/podEntry_offline.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/unDelivery_offline.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui'; // Needed for ImageFilter

class OfflineDrsOption extends StatefulWidget {
  const OfflineDrsOption({super.key});

  @override
  State<OfflineDrsOption> createState() => _OfflineDrsOptionState();
}

class _OfflineDrsOptionState extends State<OfflineDrsOption>
    with SingleTickerProviderStateMixin {
  Offlinedrsoption? _hoveredOption;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOptionSelected(Offlinedrsoption option) {
    switch (option) {
      case Offlinedrsoption.POD:
        Get.to(() => const PodEntryOffline());
        break;
      case Offlinedrsoption.UNDELIVERY:
        Get.to(() => const UndeliveryOffline());
        break;
    }
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData iconData,
    required Color iconColor,
    required Color backgroundColor,
    required Offlinedrsoption option,
    required String lottieAsset,
  }) {
    final isHovered = _hoveredOption == option;

    return GestureDetector(
      onTap: () => _handleOptionSelected(option),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredOption = option),
        onExit: (_) => setState(() => _hoveredOption = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, isHovered ? -5 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeConfig.extraLargeRadius),
            border: Border.all(
              color: isHovered
                  ? iconColor
                  : Colors.grey.withAlpha((0.2 * 255).round()),
              width: isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withAlpha(((isHovered ? 0.1 : 0.05).round())),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalPadding,
              vertical: SizeConfig.verticalPadding),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconData,
                      color: iconColor,
                      size: SizeConfig.largeIconSize,
                    ),
                  ),
                  SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: SizeConfig.largeTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: SizeConfig.smallVerticalSpacing),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: SizeConfig.smallTextSize,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_forward,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.mediumVerticalSpacing),
              SizedBox(
                height: 120,
                width: 120,
                child: Lottie.asset(
                  lottieAsset,
                  // animate: isHovered,
                  // repeat: isHovered,
                  // controller: isHovered ? _animationController : null,
                  // onLoaded: (composition) {
                  //   if (isHovered) {
                  //     _animationController
                  //       ..duration = composition.duration
                  //       ..forward();
                  //   }
                  // },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Delivery Action',
          style: TextStyle(
            fontSize: SizeConfig.largeTextSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        // centerTitle: true,
        elevation: 0,
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalPadding,
              vertical: SizeConfig.verticalPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptionCard(
                    title: 'Proof of Delivery',
                    description:
                        'Confirm successful delivery with signature or photo evidence',
                    iconData: Icons.check_circle_outline,
                    iconColor: Colors.green,
                    backgroundColor:
                        Colors.green.withAlpha((0.1 * 255).round()),
                    option: Offlinedrsoption.POD,
                    lottieAsset: 'assets/delivery.json',
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),
                  _buildOptionCard(
                    title: 'Undelivery',
                    description:
                        'Report an issue preventing successful delivery',
                    iconData: Icons.cancel_outlined,
                    iconColor: Colors.amber,
                    backgroundColor:
                        Colors.amber.withAlpha((0.1 * 255).round()),
                    option: Offlinedrsoption.UNDELIVERY,
                    lottieAsset: 'assets/emptyDelivery.json',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Offlinedrsoption { POD, UNDELIVERY }
