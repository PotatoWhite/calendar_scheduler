import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/schedule_card.dart';
import '../component/today_banner.dart';
import '../provider/schedule_provider.dart';

// HomeScreen 위젯은 앱의 홈 화면을 구성합니다.
class HomeScreen extends StatelessWidget {
  // selectedDate는 현재 선택된 날짜를 나타냅니다.
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>(); // watch의 특성은 해당 provider의 상태가 변경될 때마다 해당 위젯을 리빌드
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];

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
              builder: (_) => ScheduleBottomSheet(
                selectedDate: selectedDate, // 선택된 날짜를 ScheduleBottomSheet 위젯에 전달합니다.
              ),
              isScrollControlled: true,
            );
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusDate) => onDaySelected(selectedDate, focusDate, context),
            ),
            const SizedBox(height: 16.0),
            // StreamBuilder는 스트림의 데이터를 수신하고 UI를 업데이트합니다.
            TodayBanner(
              selectedDate: selectedDate, // cache에 저장된 일정 개수를 가져와서 TodayBanner 위젯에 전달
              count: schedules.length, // cache에 저장된 일정 개수를 가져와서 TodayBanner 위젯에 전달
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Dismissible(
                    key: Key(schedule.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      provider.deleteSchedule(date: selectedDate, id: schedule.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ));
  }

  // onDaySelected는 날짜가 선택되었을 때 호출되는 콜백 함수입니다.
  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDay,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
  }
}
