import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/tiles/bookingTile.dart';
import 'package:intl/intl.dart';
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
      loadingAlertService = LoadingAlertService(context: context);
      _getBookingList();
    });
  }

  Future<void> _getBookingList() async {
    String fromDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 30)));
    String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmfromdt": fromDate,
      "prmtodt": toDate,
      "prmsessionid": savedUser.sessionid.toString()
    };

    Provider.of<BookingListProvider>(context, listen: false)
        .getBookingList(params);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingListProvider>(builder: (_, provider, __) {
      // Handle state changes reactively
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.status == ApiCallingStatus.loading) {
          loadingAlertService.showLoading();
        } else {
          loadingAlertService.hideLoading();
        }

        if (provider.status == ApiCallingStatus.error &&
            provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        }
      });

      return Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          foregroundColor: CommonColors.White,
          title: Text(
            'Booking List',
            style: TextStyle(fontSize: SizeConfig.largeTextSize),
          ),
        ),
        body: provider.bookings.isEmpty &&
                provider.status == ApiCallingStatus.success
            ? Center(
                child: Text(
                  'No bookings found',
                  style: TextStyle(fontSize: SizeConfig.mediumTextSize),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: provider.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  return BookingTile(booking: provider.bookings[index]);
                },
              ),
      );
    });
  }
}
