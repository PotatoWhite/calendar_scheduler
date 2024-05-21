import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

// TodayBanner 위젯은 선택된 날짜와 해당 날짜의 일정 개수를 표시하는 배너입니다.
class TodayBanner extends StatelessWidget {
  // selectedDate는 현재 선택된 날짜를 나타냅니다.
  // count는 선택된 날짜의 일정 개수를 나타냅니다.
  const TodayBanner({super.key, required this.selectedDate, required this.count});

  final DateTime selectedDate;
  final int count;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    // Container 위젯을 반환합니다. 이 위젯은 배너의 레이아웃을 구성합니다.
    // 배너는 PRIMARY_COLOR로 채워져 있으며, 선택된 날짜와 일정 개수를 표시하는 Text 위젯을 포함하고 있습니다.
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
