import 'package:flutter/material.dart';
import 'package:gtlmd/common/bottomSheet/cancelBookingBottomSheet.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/pages/bookingList/model/BookingListModel.dart';
import 'package:provider/provider.dart';

class BookingTile extends StatelessWidget {
  final BookingListModel booking;

  const BookingTile({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingListProvider>(builder: (_, provider, __) {
      return Card(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                CommonColors.white!,
                CommonColors.blue600!.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                children: [
                  Expanded(
                    child: _iconInfo(
                      icon: Icons.confirmation_number,
                      label: 'GR#',
                      value: booking.grno.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _iconInfo(
                      icon: Icons.calendar_today,
                      label: 'GR Date',
                      value: booking.grdt.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _iconInfo(
                      icon: Icons.location_on,
                      label: 'Origin',
                      value: booking.origin.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:

                        /// Destination
                        _iconInfo(
                      icon: Icons.location_on,
                      label: 'Destination',
                      value: booking.destname.toString(),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Amount Highlight
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: CommonColors.green200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '₹ ${booking.tamount.toString()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CommonColors.successColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),

              const SizedBox(height: 12),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    icon: Icons.picture_as_pdf,
                    label: 'PDF',
                    color: CommonColors.blue600!,
                    onTap: () {},
                  ),
                  _actionButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    color: Colors.orange,
                    onTap: () {
                      provider.navigateToBookingWithEwayBill(
                          booking.grno.toString());
                    },
                  ),
                  _actionButton(
                    icon: Icons.cancel,
                    label: 'Cancel',
                    color: Colors.red,
                    onTap: () {
                      showCancelBookingBottomSheet(
                        context,
                        (remarks) {
                          debugPrint(remarks);
                          context
                              .read<BookingListProvider>()
                              .cancelBooking(remarks, booking);
                        },
                        () {},
                        booking.grno.toString(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });

    // Card(
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           flex: 2,
    //           child: Text(
    //             booking.grNo,
    //             style: const TextStyle(fontWeight: FontWeight.w600),
    //           ),
    //         ),
    //         Expanded(
    //           flex: 2,
    //           child: Text(_formatDate(booking.grDate)),
    //         ),
    //         Expanded(
    //           flex: 3,
    //           child: Text(booking.destination),
    //         ),
    //         Expanded(
    //           flex: 2,
    //           child: Text(
    //             '₹${booking.amount.toStringAsFixed(2)}',
    //             textAlign: TextAlign.end,
    //             style: const TextStyle(fontWeight: FontWeight.w600),
    //           ),
    //         ),
    //         IconButton(
    //             icon: const Icon(Icons.share),
    //             onPressed: () {
    //               // context.read<BookingListProvider>().sharePdf(booking),
    //             }),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _iconInfo({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: CommonColors.grey400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}
