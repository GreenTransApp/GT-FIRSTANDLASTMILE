import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bluetooth/bluetoothScreen.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/GrListModel.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/stickerProvider.dart';
import 'package:gtlmd/tiles/stickerListTile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StickerListPage extends StatefulWidget {
  final GrListModel grModel;
  const StickerListPage({super.key, required this.grModel});

  @override
  State<StickerListPage> createState() => _StickerListPageState();
}

class _StickerListPageState extends State<StickerListPage> {
  late LoadingAlertService loadingAlertService;
  TextEditingController _searchController = TextEditingController();
  StreamSubscription<String>? _scanSubscription;

  BaseRepository baseRepo = BaseRepository();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      _getStickerList();
    });
  }

  Future<void> _getStickerList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmgrno": widget.grModel.grno.toString(),
      "prmsessionid": savedUser.sessionid.toString()
    };

    Provider.of<StickerPrintingProvider>(context, listen: false)
        .getStickerList(params);
  }

  Future<void> onRefresh() async {
    _getStickerList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StickerPrintingProvider>(builder: (_, provider, __) {
      final selectedStickers = provider.selectedStickerList;
      // Handle state changes reactively
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.status == ApiCallingStatus.loading) {
          loadingAlertService.showLoading();
        } else {
          loadingAlertService.hideLoading();
        }

        if (provider.status == ApiCallingStatus.error &&
            provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        }
      });

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CommonColors.colorPrimary,
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: CommonColors.white,
                  ));
            }),
            title: Text(
              'Stickers ',
              style: TextStyle(
                color: CommonColors.white,
              ),
            ),
            // actions: [
            //   GestureDetector(
            //     onTap: () {
            //       // Get.to(const BluetoothScreen(stickerList: selected,));
            //     },
            //     child: Container(
            //       padding: EdgeInsets.symmetric(
            //           horizontal: SizeConfig.smallHorizontalSpacing,
            //           vertical: SizeConfig.smallVerticalSpacing),
            //       decoration: BoxDecoration(
            //         border: Border.all(color: CommonColors.white!),
            //         shape: BoxShape.circle,
            //       ),
            //       child: Icon(Icons.bluetooth,
            //           size: SizeConfig.extraLargeIconSize,
            //           color: CommonColors.White),
            //     ),
            //   )
            // ],
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: CommonColors.colorPrimary),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    cursorColor: CommonColors.appBarColor,
                    obscureText: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: CommonColors.appBarColor,
                        size: SizeConfig.largeIconSize,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchController.clear();
                            // updateSearch('');
                          });
                        },
                        icon: _searchController.text.isNotEmpty
                            ? const Icon(Icons.clear)
                            : const Icon(
                                Icons.clear,
                                color: Colors.transparent,
                              ),
                      ),
                      hintText: 'Search',
                      filled: true,
                      fillColor: CommonColors.White,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.extraLargeRadius)),
                          borderSide: const BorderSide(
                              color: CommonColors.appBarColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.extraLargeRadius),
                          borderSide: const BorderSide(
                              color: CommonColors.appBarColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.extraLargeRadius),
                          borderSide: const BorderSide(
                              color: CommonColors.appBarColor)),
                    ),
                    // onChanged: provider.grSearch,
                    onChanged: (value) {
                      context
                          .read<StickerPrintingProvider>()
                          .updateStickerSearch(value);
                    },
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // GR No
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GR No',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.grModel.grno.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Divider
                      Container(
                        height: 36,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),

                      // Total Packages
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Packages',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (widget.grModel.pckgs!.toInt()).toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.stickerSearch.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    return StickerListTile(
                      stickerModel: provider.stickerSearch[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
          persistentFooterButtons: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.verticalPadding,
                  horizontal: SizeConfig.horizontalPadding),
              decoration: BoxDecoration(
                color: CommonColors.whiteShade,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SizeConfig.largeRadius),
                  bottomRight: Radius.circular(SizeConfig.largeRadius),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedStickers.isEmpty) {
                    failToast("Please Select  Sticker Before Print");
                    return;
                  } else {
                    for (var sticker in selectedStickers) {
                      debugPrint(sticker.stickerno);
                    }
                    Get.to(BluetoothScreen(
                      stickerList: selectedStickers,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.colorPrimary,
                  foregroundColor: CommonColors.White,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: SizeConfig.smallTextSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
