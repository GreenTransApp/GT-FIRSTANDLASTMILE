import 'package:flutter/material.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/pages/bookingList/bookingModel.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                booking.grNo,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(_formatDate(booking.grDate)),
            ),
            Expanded(
              flex: 3,
              child: Text(booking.destination),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₹${booking.amount.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // context.read<BookingListProvider>().sharePdf(booking),
                }),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}
