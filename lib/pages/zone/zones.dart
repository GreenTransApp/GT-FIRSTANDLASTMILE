import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/pages/zone/zoneItem.dart';
import 'package:get/get.dart';

class Consignments extends StatelessWidget {
  Consignments({required this.type});

  String type = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(
              left: MediaQuery.sizeOf(context).width * 0.01,
              right: MediaQuery.sizeOf(context).width * 0.01),
          itemCount: 7,
          itemBuilder: (context, index) {
            return const ConsignmentItem();
          }),
    );
  }
}
