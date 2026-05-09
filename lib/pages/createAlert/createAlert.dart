import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/pages/createAlert/createAlertRepository.dart';
import 'package:gtlmd/pages/createAlert/createAlertViewModel.dart';
import 'package:gtlmd/pages/createAlert/models/notificationDetailModel.dart';
import 'package:gtlmd/pages/reminderList/models/reminderLIstModel.dart';

class CreateAlert extends StatefulWidget {
  final ReminderListModel model;
  const CreateAlert({super.key, required this.model});

  @override
  State<CreateAlert> createState() => _CreateAlertState();
}

class _CreateAlertState extends State<CreateAlert> {
  List<NotificationDetailModel> notiDetailList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  final List<StreamSubscription> _subscription = [];
  CreateAlertViewModel viewModel = CreateAlertViewModel();

  final TextEditingController commentController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  String notificationFor = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();

    getNotificationDetail();
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

    _subscription.add(viewModel.notiDetailListLiveData.stream.listen((data) {
      setState(() {
        notiDetailList = data;
        if (notiDetailList[0].createid == savedUser.usercode) {
          notificationFor = notiDetailList[0].notificationfor.toString();
        } else {
          notificationFor = notiDetailList[0].createid.toString();
        }
      });
    }));

    _subscription.add(viewModel.addCommentLiveData.stream.listen((data) {
      if (data.CommandStatus == 1) {
        if (data.CommandMessage != null) {
          successToast(data.CommandMessage!);
        } else {
          successToast("sent");
        }
        commentController.text = '';
        getNotificationDetail();
      } else {
        if (data.CommandMessage != null) {
          failToast(data.CommandMessage!);
        } else {
          failToast("Something went wrong");
        }
      }
    }));
  }

  getNotificationDetail() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmgroupid": widget.model.groupid.toString(),
    };

    viewModel.getNotificationDetail(params);
  }

  validateComment() {
    if (isNullOrEmpty(commentController.text)) {
      failToast("Please Enter Your Comment First.");
      return;
    }
    addUserComment();
  }

  addUserComment() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmalertid": widget.model.alertid.toString(),
      "prmalertfor": notificationFor,
      "prmsubject": widget.model.subject.toString(),
      "prmalerttext": commentController.text.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTAPP_CREATEALERTS",
      "prmsessionid": savedUser.sessionid.toString(),
      "prmgroupid": widget.model.groupid.toString(),
    };

    viewModel.addUserComment(params);
  }

  Future<void> onRefresh() async {
    getNotificationDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.pageBackground,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
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
          padding: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Alert",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: CommonColors.white,
              ),
            ),
            Text(
              "Reminder Chat",
              style: TextStyle(
                fontSize: 11,
                color: CommonColors.white!.withOpacity(0.8),
              ),
            )
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12),
        //     child: CircleAvatar(
        //       backgroundColor: Colors.white.withOpacity(0.15),
        //       child: const Icon(
        //         Icons.notifications_active_outlined,
        //         color: Colors.white,
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CommonColors.white!,
                  CommonColors.primaryLighter,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: CommonColors.colorPrimary!.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CommonColors.primaryLighter,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.subject,
                        color: CommonColors.colorPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "SUBJECT",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: CommonColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.model.subject ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CommonColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 18),

                const Divider(
                  color: CommonColors.dividerColor,
                ),

                const SizedBox(height: 14),

                // USER + DATE
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.person_outline,
                        title: "USER",
                        value: widget.model.alertfrom ?? "",
                        color: CommonColors.orange!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.calendar_month,
                        title: "DATE",
                        value: widget.model.alertdate ?? "",
                        color: CommonColors.successColor!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: notiDetailList.length,
                itemBuilder: (context, index) {
                  var data = notiDetailList[index];
                  bool isMe = data.createid == savedUser.usercode;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72,
                      ),
                      decoration: BoxDecoration(
                        gradient: isMe
                            ? LinearGradient(
                                colors: [
                                  CommonColors.green600!,
                                  CommonColors.green500!,
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  CommonColors.white!,
                                  CommonColors.grey50!,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: CommonColors.appBarColor.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // isMe ? "Hello 👋" : "Testing Reminder",
                            "${data.notificationtext}",
                            style: TextStyle(
                              color: isMe
                                  ? CommonColors.white
                                  : CommonColors.appBarColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${data.notificationtime}",
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  isMe ? CommonColors.white : CommonColors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
            decoration: BoxDecoration(
              color: CommonColors.white,
              boxShadow: [
                BoxShadow(
                  color: CommonColors.appBarColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: CommonColors.grey50,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: CommonColors.grey200!,
                      ),
                    ),
                    child: TextField(
                      controller: commentController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: "Write your comments...",
                        hintStyle: TextStyle(
                          color: CommonColors.grey600,
                        ),
                        prefixIcon: Icon(
                          Icons.edit_note,
                          color: CommonColors.colorPrimary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // SEND BUTTON
                InkWell(
                  onTap: () {
                    validateComment();
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CommonColors.green600!,
                          CommonColors.green500!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: CommonColors.green600!.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: CommonColors.white,
                      size: 22,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: CommonColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: CommonColors.textPrimary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
