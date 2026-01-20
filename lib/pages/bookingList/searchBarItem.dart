import 'package:flutter/material.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';

class SearchBarItem extends StatelessWidget {
  const SearchBarItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        // onChanged: context.read<BookingListProvider>().updateSearch,
        decoration: InputDecoration(
          hintText: 'Search booking',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
