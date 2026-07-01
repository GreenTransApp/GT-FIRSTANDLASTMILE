import 'package:flutter/material.dart';
import 'package:gtlmd/bottomSheet/datePicker.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/directBooking/directBookingViewModel.dart';
import 'package:gtlmd/pages/directBooking/model/directBookingModel.dart';
import 'package:gtlmd/tiles/directBookingTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DirectBookingPage extends StatefulWidget {
  const DirectBookingPage({super.key});

  @override
  State<DirectBookingPage> createState() => _DirectBookingPageState();
}

class _DirectBookingPageState extends State<DirectBookingPage> {
  List<DirectBookingModel> directBookingList = List.empty(growable: true);

  DirectBookingViewModel viewModel = DirectBookingViewModel();
  late LoadingAlertService loadingAlertService;
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  late String smallDateTime;
  late DateTime todayDateTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    setObservers();
    getDirectBookingSearchList();
  }

  setObservers() {
    viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          // isLoading = true;
          loadingAlertService.showLoading();
        });
      } else {
        setState(() {
          // isLoading = false;
          loadingAlertService.hideLoading();
        });
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.directBookingLiveData.stream.listen((data) {
      setState(() {
        directBookingList = data;
      });
    });
  }

  getDirectBookingSearchList() {
    Map<String, dynamic> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmfromdate":  convert2SmallDateTime(fromDt.toString()),
      "prmtodate":  convert2SmallDateTime(dashboardFromDt.toString()),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.getDirectBookingSearchList(params);
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
    // getDashboardDetails();
    
  }


  Future<void> refreshScreen() async {
    getDirectBookingSearchList();
  
  }


  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Scaffold(
appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          "Direct Booking",
          style: TextStyle(color: CommonColors.White),
        ),
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
     
body: directBookingList.isEmpty
          ? Scaffold(
              body: Center(
              child: Text(
                "data not  found ".toUpperCase(),
                style:
                    TextStyle(color: CommonColors.successColor, fontSize: 20),
              ),
            ))
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmallDevice ? 8 : 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  // Consignments Title
                  Text(
                    'Consignments',
                    style: TextStyle(
                      fontSize: isSmallDevice ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  directBookingList.isNotEmpty
                      ? Expanded(
                          child: RefreshIndicator(
                            onRefresh: refreshScreen,
                            backgroundColor: CommonColors.colorPrimary,
                            color: CommonColors.White,
                            child: Container(
                              decoration: BoxDecoration(
                                color: CommonColors.White,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: CommonColors.appBarColor
                                        .withAlpha((0.05 * 255).round()),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                itemCount: directBookingList.length,
                                itemBuilder: (context, index) {
                                  var data = directBookingList[index];

                                  return DirectBookingTile(
                                    model: data,
                                    
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              Lottie.asset(
                                'assets/map_blue.json',
                                height: 100,
                              ),
                              const Text(
                                "No Data Found",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 18),
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
    
    );
  }
}
