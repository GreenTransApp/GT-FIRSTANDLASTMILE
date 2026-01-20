import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/bookingList/TableFooter.dart';
import 'package:gtlmd/pages/bookingList/bookingList.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/pages/bookingList/searchBarItem.dart';
import 'package:provider/provider.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingListProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          title: Text(
            'Booking List',
            style: TextStyle(fontSize: SizeConfig.largeTextSize),
          ),
        ),
        body: const Column(
          children: [
            SearchBarItem(),
            // _TableHeader(),
            const Expanded(child: BookingList()),
            const TotalFooter(),
          ],
        ),
      ),
    );
  }
}
