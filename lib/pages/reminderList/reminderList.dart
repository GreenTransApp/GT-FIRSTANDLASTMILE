import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/reminderList/models/reminderLIstModel.dart';
import 'package:gtlmd/pages/reminderList/reminderListViewModel.dart';
import 'package:gtlmd/tiles/reminderTile.dart';
import 'package:gtlmd/tiles/runningTripTile.dart';
import 'package:lottie/lottie.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  State<ReminderListPage> createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  List<ReminderListModel> _reminderList = List.empty(growable: true);
  List<ReminderListModel> _filterList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  final TextEditingController _searchController = TextEditingController();
  late String query = "";
  final List<StreamSubscription> _subscription = [];
  ReminderListViewModel viewModel = ReminderListViewModel();
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    getReminderList();
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

    _subscription.add(viewModel.reminderListLiveData.stream.listen((data) {
      setState(() {
        _reminderList = data;
        _filterList = _reminderList;
      });
    }));

    _subscription.add(viewModel.archieveLiveData.stream.listen((data) {
      if (data.CommandStatus == 1) {
        if (data.CommandMessage != null) {
          successToast(data.CommandMessage!);
        } else {
          successToast("sent");
        }
        getReminderList();
      } else {
        if (data.CommandMessage != null) {
          failToast(data.CommandMessage!);
        } else {
          failToast("Something went wrong");
        }
      }
    }));
  }

  void getReminderList() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmloginbranchtype": savedUser.loginbranchtype.toString(),
      "prmlogindt": convert2SmallDateTime(savedUser.logindatetime.toString()),
      "prmusercode": savedUser.usercode.toString(),
    };

    viewModel.getReminderList(params);
  }

  Future<void> onRefresh() async {
    getReminderList();
  }

  void updateSearch(String newQuery) {
    List<ReminderListModel> newMatchQuery = [];

    if (newQuery.isEmpty) {
      setState(() {
        query = '';
        _filterList = _reminderList;
      });
    } else {
      for (var i in _reminderList) {
        if (i.subject
            .toString()
            .toLowerCase()
            .contains(newQuery.toLowerCase())) {
          newMatchQuery.add(i);
        }
      }
      setState(() {
        query = newQuery;
        _filterList = newMatchQuery;
      });
    }
  }

  okayCallBack(ReminderListModel model) {
    archiveReminder(model);
  }

  void cancelPopup() {
    Get.back();
  }

  alertBeforeArchive(ReminderListModel model) {
    commonAlertDialog(
        context,
        "ALERT!",
        "Are you sure you want to archive ${model.subject}?",
        "",
        const Icon(Icons.archive),
        () => okayCallBack(model),
        cancelCallBack: cancelPopup);
  }

  archiveReminder(ReminderListModel model) {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmalertid": model.alertid.toString(),
    };

    viewModel.archieveReminder(params);
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
              'Reminders',
              style: TextStyle(
                color: CommonColors.White,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Your notifications',
              style: TextStyle(
                color: CommonColors.white!.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: CommonColors.blueGrey?.withAlpha((0.1 * 255).toInt()),
        child: Column(
          children: [
            Padding(
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
                  hintText: 'Search',
                  filled: true,
                  fillColor: CommonColors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Set the desired radius
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: updateSearch,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: Container(
                  child: (_filterList.isEmpty) == true
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/emptyDelivery.json",
                                      height: 150),
                                  Text(
                                    "No Reminder",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: CommonColors.appBarColor),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filterList.length,
                          itemBuilder: (context, index) {
                            var currentData = _filterList[index];
                            return ReminderTile(
                              model: currentData,
                              onRefresh: onRefresh,
                              onArchive: () => alertBeforeArchive(currentData),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
