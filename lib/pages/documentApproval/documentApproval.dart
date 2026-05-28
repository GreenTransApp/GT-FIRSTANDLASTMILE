import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/documentApproval/documentApprovalViewModel.dart';
import 'package:gtlmd/pages/documentApproval/model/documentApprovalModel.dart';
import 'package:gtlmd/tiles/reminderTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DocumentApproval extends StatefulWidget {
  const DocumentApproval({super.key});

  @override
  State<DocumentApproval> createState() => _DocumentApprovalState();
}

class _DocumentApprovalState extends State<DocumentApproval> {
  List<DocumentApprovalModel> _docApprovalList = List.empty(growable: true);
  List<DocumentApprovalModel> _filterList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  final TextEditingController _searchController = TextEditingController();
  late String query = "";
  final List<StreamSubscription> _subscription = [];
  DocumentApprovalViewModel viewModel = DocumentApprovalViewModel();
  DateTime currentDate = DateTime.now();
  String selectedStatus = "S";
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  late DateTime todayDateTime;
  late String smallDateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    // getDocApprovalList();
  }

  setObservers() {
    _subscription.add(viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          loadingAlertService.showLoading();
        });
      } else {
        setState(() {
          loadingAlertService.hideLoading();
        });
      }
    }));

    _subscription.add(viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    }));

    _subscription.add(viewModel.docApprovalLiveData.stream.listen((data) {
      setState(() {
        _docApprovalList = data;
        _filterList = _docApprovalList;
      });
    }));
  }

  void _dateChanged(String fromDt, String toDt) {
    // debugPrint("fromDt ${fromDt}");
    // debugPrint("toDt ${toDt}");

    this.fromDt = fromDt;
    this.toDt = toDt;

    DateTime fromdt = DateTime.parse(this.fromDt);
    DateTime todt = DateTime.parse(this.toDt);
    dashboardFromDt = fromdt;
    dashboardToDt = todt;
    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    onRefresh();
  }

  void getDocApprovalList() {
    Map<String, String> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmfromdt": convert2SmallDateTime(this.fromDt),
      "prmtodt": savedUser.usercode.toString(),
      "prmfiltertype": savedUser.usercode.toString(),
      "prmcharstr": savedUser.usercode.toString(),
    };

    viewModel.getDocApprovalList(params);
  }

  Future<void> onRefresh() async {
    getDocApprovalList();
  }

  void updateSearch(String newQuery) {
    List<DocumentApprovalModel> newMatchQuery = [];

    if (newQuery.isEmpty) {
      setState(() {
        query = '';
        _filterList = _docApprovalList;
      });
    } else {
      for (var i in _docApprovalList) {
        // if (i.
        //     .toString()
        //     .toLowerCase()
        //     .contains(newQuery.toLowerCase())) {
        //   newMatchQuery.add(i);
        // }
      }
      setState(() {
        query = newQuery;
        _filterList = newMatchQuery;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CommonColors.colorPrimary!,
                CommonColors.primaryColorShade!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: CommonColors.white,
              size: 18,
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Document Approval',
              style: TextStyle(
                color: CommonColors.White,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Pending & approved documents',
              style: TextStyle(
                color: CommonColors.white!.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          Icon(
            Icons.date_range,
            color: CommonColors.white,
          ),
        ],
      ),
      body: Container(
        color: CommonColors.blueGrey?.withAlpha((0.1 * 255).toInt()),
        child: Column(
          children: [
            /// SEARCH + STATUS FILTER
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding,
              ),
              child: Row(
                children: [
                  /// SEARCH FIELD
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      cursorColor: CommonColors.appBarColor,
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
                              updateSearch('');
                            });
                          },
                          icon: _searchController.text.isNotEmpty
                              ? const Icon(Icons.clear)
                              : Icon(
                                  Icons.clear,
                                  color: CommonColors.transparent,
                                ),
                        ),
                        hintText: 'Search document',
                        filled: true,
                        fillColor: CommonColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: updateSearch,
                    ),
                  ),

                  SizedBox(width: 10),

                  /// SEEN / UNSEEN FILTER
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: CommonColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        hint: Text("All"),
                        items: [
                          DropdownMenuItem(
                            value: "S",
                            child: Text("Seen"),
                          ),
                          DropdownMenuItem(
                            value: "U",
                            child: Text("Unseen"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });

                          // Apply Filter Here
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: (_filterList.isEmpty)
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 120),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  "assets/emptyDelivery.json",
                                  height: 170,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "No Document Found",
                                  style: TextStyle(
                                    fontSize: SizeConfig.mediumTextSize,
                                    color: CommonColors.appBarColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 10),
                        itemCount: _filterList.length,
                        itemBuilder: (context, index) {
                          var currentData = _filterList[index];

                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  /// ICON
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: CommonColors.colorPrimary!
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.description_outlined,
                                      color: CommonColors.colorPrimary,
                                      size: 28,
                                    ),
                                  ),

                                  SizedBox(width: 14),

                                  /// DETAILS
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Document Approval Request",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: CommonColors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Waiting for approval",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: CommonColors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: CommonColors.grey,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "18 May 2026",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: CommonColors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// STATUS
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          CommonColors.orange!.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Pending",
                                      style: TextStyle(
                                        color: CommonColors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
