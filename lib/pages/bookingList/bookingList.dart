import 'package:flutter/material.dart';
import 'package:gtlmd/tiles/bookingTile.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:provider/provider.dart';

class BookingList extends StatelessWidget {
  const BookingList();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingListProvider>(
      builder: (_, provider, __) {
        if (provider.bookings.isEmpty) {
          return const Center(child: Text('No bookings found'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: provider.bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return BookingTile(booking: provider.bookings[index]);
          },
        );
      },
    );
  }
}
