import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/stickerProvider.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/tiles/grListTile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GrListPage extends StatefulWidget {
  const GrListPage({super.key});

  @override
  State<GrListPage> createState() => _GrListPageState();
}

class _GrListPageState extends State<GrListPage> {
  late LoadingAlertService loadingAlertService;
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  String formattedDate = '';
  late DateTime todayDateTime;
  late String smallDateTime;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      todayDateTime = DateTime.now();
      smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
      fromDt = smallDateTime.toString();
      toDt = smallDateTime.toString();
      DateTime fromdt = DateTime.parse(fromDt);
      DateTime todt = DateTime.parse(toDt);
      _getGrList();
    });
  }

  Future<void> _getGrList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmfromdt": convert2SmallDateTime(fromDt),
      // "prmfromdt": '2025-11-01',
      "prmtodt": convert2SmallDateTime(toDt),
      "prmsessionid": savedUser.sessionid.toString()
    };

    Provider.of<StickerPrintingProvider>(context, listen: false)
        .getGrList(params);
  }

  void _dateChanged(String fromDt, String toDt) {
    // debugPrint("fromDt ${fromDt}");
    // debugPrint("toDt ${toDt}");

    this.fromDt = fromDt;
    this.toDt = toDt;

    DateTime fromdt = DateTime.parse(this.fromDt);
    DateTime todt = DateTime.parse(this.toDt);

    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    onRefresh();
  }

  Future<void> onRefresh() async {
    _getGrList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StickerPrintingProvider>(builder: (_, provider, __) {
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
              'GR List',
              style: TextStyle(
                color: CommonColors.white,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  showDatePickerBottomSheet(context, _dateChanged);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: CommonColors.white,
                  ),
                ),
              )
            ],
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
                          .updateGrSearch(value);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.grSearch.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    return GrListTile(grModel: provider.grSearch[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
