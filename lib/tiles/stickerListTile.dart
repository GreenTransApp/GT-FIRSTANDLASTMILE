import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/StickerModel.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/stickerProvider.dart';
import 'package:provider/provider.dart';

class StickerListTile extends StatelessWidget {
  final StickerListModel stickerModel;
  final int index;
  const StickerListTile(
      {super.key, required this.stickerModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: CommonColors.primaryColorShade!.withOpacity(0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          /// MAIN CONTENT
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
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
              horizontal: SizeConfig.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// STICKER NO (Hero element)
                _heroTag(
                  icon: Icons.qr_code,
                  label: 'Sticker No',
                  value: stickerModel.stickerno ?? '-',
                ),

                const SizedBox(height: 12),

                /// PACKAGE ID & DATE (Dynamic height)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _dynamicInfoTile(
                        icon: Icons.inventory_2_outlined,
                        label: 'Package ID',
                        value: stickerModel.packageid?.toString() ?? '-',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dynamicInfoTile(
                        icon: Icons.event,
                        label: 'Booking Date',
                        value: stickerModel.bookingdt.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// CUSTOMER (dynamic height)
                _dynamicInfoTile(
                  icon: Icons.business,
                  label: 'Customer',
                  value: stickerModel.customer.toString(),
                ),

                const SizedBox(height: 10),

                /// ORIGIN & DESTINATION (dynamic height, uneven is fine)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _dynamicInfoTile(
                        icon: Icons.location_on_outlined,
                        label: 'Origin',
                        value: stickerModel.originname.toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dynamicInfoTile(
                        icon: Icons.flag_outlined,
                        label: 'Destination',
                        value: stickerModel.destinationname.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                Divider(color: CommonColors.blueGrey!.withOpacity(0.25)),
                const SizedBox(height: 10),

                /// PACKAGES & WEIGHT
                Row(
                  children: [
                    Expanded(
                      child: _bottomChip(
                        icon: Icons.inventory,
                        text: '${stickerModel.pckgs!.toInt()} Pkgs',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _bottomChip(
                        icon: Icons.monitor_weight_outlined,
                        text: '${stickerModel.weight} Kg',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// CHECKBOX (Top-right floating)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
                decoration: BoxDecoration(
                  color: CommonColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CommonColors.appBarColor.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Checkbox(
                  value: stickerModel.selectedsticker ?? false,
                  shape: const CircleBorder(),
                  activeColor: CommonColors.primaryColorShade,
                  onChanged: (val) {
                    context
                        .read<StickerPrintingProvider>()
                        .onStickerCheckChange(val!, index);
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _heroTag({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.verticalPadding,
          horizontal: SizeConfig.horizontalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CommonColors.primaryColorShade!.withOpacity(0.25),
            CommonColors.primaryColorShade!.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: CommonColors.primaryColorShade!.withOpacity(0.2),
            child: Icon(icon, size: 18, color: CommonColors.primaryColorShade),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: CommonColors.blueGrey600,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CommonColors.primaryColorShade,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dynamicInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.verticalPadding,
        horizontal: SizeConfig.horizontalPadding,
      ),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: CommonColors.white!.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: CommonColors.primaryColorShade),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: CommonColors.blueGrey600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.verticalPadding,
          horizontal: SizeConfig.horizontalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CommonColors.primaryColorShade!.withOpacity(0.2),
            CommonColors.primaryColorShade!.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: CommonColors.primaryColorShade),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CommonColors.primaryColorShade,
            ),
          ),
        ],
      ),
    );
  }
}
