import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

import '../component/schedule_card.dart';
import '../component/today_banner.dart';

// HomeScreen 위젯은 앱의 홈 화면을 구성합니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // selectedDate는 현재 선택된 날짜를 나타냅니다.
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    // Scaffold 위젯을 반환합니다. 이 위젯은 앱의 기본 레이아웃을 구성합니다.
    // 화면 상단에는 MainCalendar 위젯이 위치하고, 그 아래에는 TodayBanner와 ScheduleCard 위젯이 위치합니다.
    // 화면 우측 하단에는 일정을 추가할 수 있는 FloatingActionButton이 위치합니다.
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              builder: (_) => const ScheduleBottomSheet(),
              isScrollControlled: true,
            );
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            children: [
              MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
              ),
              const SizedBox(height: 16.0),
              TodayBanner(
                selectedDate: selectedDate,
                count: 0,
              ),
              const ScheduleCard(
                startTime: 12,
                endTime: 14,
                content: 'Meeting with client',
              ),
            ],
          ),
        ));
  }

  // onDaySelected 메서드는 사용자가 캘린더에서 날짜를 선택했을 때 호출됩니다.
  // 이 메서드는 선택된 날짜를 상태로 저장합니다.
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      selectedDate = selectedDate;
    });
  }
}
