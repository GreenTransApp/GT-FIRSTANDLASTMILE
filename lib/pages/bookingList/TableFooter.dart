import 'package:flutter/material.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:provider/provider.dart';

class TotalFooter extends StatelessWidget {
  const TotalFooter();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingListProvider>(
      builder: (_, provider, __) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black12,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${provider.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
