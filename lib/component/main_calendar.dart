import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// MainCalendar는 사용자가 날짜를 선택할 수 있는 캘린더를 제공하는 위젯입니다.
class MainCalendar extends StatelessWidget {
  // onDaySelected는 날짜가 선택되었을 때 호출되는 콜백 함수입니다.
  // selectedDate는 현재 선택된 날짜를 나타냅니다.
  const MainCalendar({super.key, required this.onDaySelected, required this.selectedDate});

  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    // TableCalendar 위젯을 반환합니다.
    // 이 위젯은 캘린더의 헤더와 본문을 포함하고 있습니다.
    // 헤더에는 현재 선택된 날짜와 월간/주간 뷰 전환 버튼이 있습니다.
    // 본문에는 날짜를 선택할 수 있는 캘린더가 표시됩니다.
    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) => date.year == selectedDate.year && selectedDate.month == date.month && selectedDate.day == date.day,
      lastDay: DateTime(3000, 1, 1),
      firstDay: DateTime(1800, 1, 1),
      focusedDay: DateTime.now(),
      headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          )),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
