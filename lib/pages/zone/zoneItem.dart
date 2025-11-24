import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/pages/routeDetail/routeDetail.dart';

class ConsignmentItem extends StatelessWidget {
  const ConsignmentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                ),
                Text('No. of consignments '),
              ],
            ),
            // TextButton(
            //   onPressed: () => {Get.to(Routedetail())},
            //   child: const Text(
            //     'Route',
            //     style: TextStyle(color: Colors.black),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
