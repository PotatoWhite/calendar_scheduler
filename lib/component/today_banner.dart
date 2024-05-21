import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({super.key, required this.selectedDate, required this.count});

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: PRIMARY_COLOR,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            style: textStyle,
          ),
          const SizedBox(width: 8.0),
          Text(
            'Total: $count',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
