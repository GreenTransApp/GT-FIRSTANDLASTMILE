import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/GrListModel.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/stickerListPage.dart';
import 'package:gtlmd/pages/grList_old/grList_old.dart';

class GrListTile extends StatelessWidget {
  final GrListModel grModel;
  const GrListTile({super.key, required this.grModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(StickerListPage(
          grModel: grModel,
        ))?.then((_) => {});
      },
      child: Card(
        elevation: 6,
        shadowColor: CommonColors.appBarColor.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: CommonColors.primaryColorShade!.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                CommonColors.white!,
                CommonColors.blue50!.withOpacity(0.45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.verticalPadding,
              horizontal: SizeConfig.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Accent strip + Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 52,
                    decoration: BoxDecoration(
                      color: CommonColors.primaryColorShade,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _iconInfo(
                          icon: Icons.confirmation_number,
                          label: 'GR No',
                          value: grModel.grno.toString(),
                        ),
                        const SizedBox(height: 8),

                        /// Booking Date as Chip (small screen safe)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.verticalPadding,
                              horizontal: SizeConfig.horizontalPadding),
                          decoration: BoxDecoration(
                            color: CommonColors.primaryColorShade!
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.event,
                                  size: 16,
                                  color: CommonColors.primaryColorShade),
                              const SizedBox(width: 6),
                              Text(
                                grModel.bookingdt.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: CommonColors.primaryColorShade,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Consignor
              _iconInfo(
                icon: Icons.person_outline,
                label: 'Consignor',
                value: grModel.cngrname.toString(),
                maxLines: 2,
              ),

              const SizedBox(height: 10),

              /// Consignee
              _iconInfo(
                icon: Icons.person,
                label: 'Consignee',
                value: grModel.cngename.toString(),
                maxLines: 2,
              ),

              const SizedBox(height: 14),
              Divider(color: CommonColors.blueGrey!.withOpacity(0.3)),

              const SizedBox(height: 12),

              /// Origin & Destination
              Row(
                children: [
                  Expanded(
                    child: _iconInfo(
                      icon: Icons.location_on_outlined,
                      label: 'Origin',
                      value: grModel.orgname.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _iconInfo(
                      icon: Icons.flag_outlined,
                      label: 'Destination',
                      value: grModel.destname.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Packages badge
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.verticalPadding,
                      horizontal: SizeConfig.horizontalPadding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CommonColors.primaryColorShade!.withOpacity(0.15),
                        CommonColors.primaryColorShade!.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2,
                          size: 18, color: CommonColors.primaryColorShade),
                      const SizedBox(width: 6),
                      Text(
                        '${grModel.pckgs!.toInt()} Pkgs',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: CommonColors.primaryColorShade,
                        ),
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

  Widget _iconInfo({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: CommonColors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: CommonColors.blueGrey600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
