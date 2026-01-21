import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/bookingList/TableFooter.dart';
import 'package:gtlmd/pages/bookingList/bookingList.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/pages/bookingList/searchBarItem.dart';
import 'package:gtlmd/tiles/bookingTile.dart';
import 'package:provider/provider.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  late LoadingAlertService loadingAlertService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getBookingList();
    });
  }

  void _handleStateChange(
      ApiCallingStatus status, String? error, BookingListProvider provider) {
    if (status == ApiCallingStatus.loading) {
      loadingAlertService.showLoading();
    } else {
      loadingAlertService.hideLoading();
    }
  }

  Future<void> _getBookingList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmfromdt": '2025-12-01',
      "prmtodt": '2025-12-01',
      "prmsessionid": savedUser.sessionid.toString()
    };

    // context.read<BookingListProvider>().getBookingList(params);
    Provider.of<BookingListProvider>(context, listen: false)
        .getBookingList(params);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingListProvider>(builder: (_, provider, __) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: CommonColors.colorPrimary,
            title: Text(
              'Booking List',
              style: TextStyle(fontSize: SizeConfig.largeTextSize),
            ),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return BookingTile(booking: provider.bookings[index]);
            },
          )
          // const Column(
          //   children: [
          //     SearchBarItem(),
          //     // _TableHeader(),
          //     const Expanded(child: BookingList()),
          //     // const TotalFooter(),
          //   ],
          // ),
          );
    });
  }
}
