import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/bottomSheet/notificationOptionBottomSheet/model/notificationOptionModel.dart';
import 'package:gtlmd/common/Colors.dart';

class NotificationOptionBottomSheet extends StatefulWidget {
  const NotificationOptionBottomSheet({super.key});

  @override
  State<NotificationOptionBottomSheet> createState() =>
      _NotificationOptionBottomSheetState();
}

class _NotificationOptionBottomSheetState
    extends State<NotificationOptionBottomSheet> {
  static List<NotificationOptionModel> optionList = [
    NotificationOptionModel(
        title: "Reminder", key: "R", pageName: "ReminderList", count: 0),
    NotificationOptionModel(
        title: "Jinni Approval",
        key: "J",
        pageName: "JinniApprovalList",
        count: 0),
  ];

  IconData getIcon(String key) {
    switch (key) {
      case "R":
        return Icons.notifications_active;
      case "J":
        return Icons.verified_user;
      default:
        return Icons.notifications;
    }
  }

  Color getColor(String key) {
    switch (key) {
      case "R":
        return CommonColors.orange!;
      case "J":
        return CommonColors.successColor!;
      default:
        return CommonColors.primaryColorShade!;
    }
  }

  void navigateToPage(NotificationOptionModel model) {
    Get.to(() => model.pageName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: CommonColors.colorPrimary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.notifications, color: CommonColors.white),
              const SizedBox(width: 10),
              Text(
                "Notifications",
                style: TextStyle(
                  color: CommonColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: CommonColors.white),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: optionList.length,
            itemBuilder: (context, index) {
              final item = optionList[index];

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: CommonColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: CommonColors.grey200!,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: getColor(item.key!).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      getIcon(item.key!),
                      color: getColor(item.key!),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if ((item.count ?? 0) >= 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: getColor(item.key!),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.count.toString(),
                            style: TextStyle(
                              color: CommonColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    navigateToPage(item);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> notificationOptionBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const NotificationOptionBottomSheet(),
      );
    },
  );
}
