import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/pages/reminderList/models/reminderLIstModel.dart';

class ReminderTile extends StatelessWidget {
  final ReminderListModel model;
  const ReminderTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: isSmallDevice ? 10 : 16,
          vertical: isSmallDevice ? 6 : 10),
      elevation: 6,
      shadowColor: CommonColors.colorPrimary!.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: isSmallDevice ? 10 : 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CommonColors.colorPrimary!,
                    CommonColors.primaryColorShade!,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SNO #${model.sno ?? ""}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallDevice ? 13 : 15,
                      color: Colors.white,
                    ),
                  ),
                  _buildStatusChip(model.readstatus),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Subject",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: CommonColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CommonColors.primaryLighter,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      model.subject ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallDevice ? 13 : 15,
                        fontWeight: FontWeight.w600,
                        color: CommonColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CommonColors.grey50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.calendar_today, "Date",
                            model.alertdate ?? "", isSmallDevice),
                        const SizedBox(height: 6),
                        _buildInfoRow(Icons.person, "From",
                            model.alertfrom ?? "", isSmallDevice),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.reply,
                          label: "Reply",
                          color: CommonColors.colorPrimary!,
                          onTap: () {},
                          isSmallDevice: isSmallDevice,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.archive_outlined,
                          label: "Archive",
                          color: CommonColors.orange!,
                          onTap: () {},
                          isSmallDevice: isSmallDevice,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final isUnread = (status ?? "").toLowerCase() == "unread";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isUnread ? CommonColors.red50 : CommonColors.green50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status ?? "",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isUnread ? CommonColors.red600 : CommonColors.green600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, bool isSmallDevice) {
    return Row(
      children: [
        Icon(icon, size: isSmallDevice ? 14 : 16, color: CommonColors.grey600),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: isSmallDevice ? 12 : 13,
            color: CommonColors.grey600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isSmallDevice ? 12 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isSmallDevice,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isSmallDevice ? 8 : 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isSmallDevice ? 14 : 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallDevice ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
