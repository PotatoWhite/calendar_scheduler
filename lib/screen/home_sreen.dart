import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../component/schedule_card.dart';
import '../component/today_banner.dart';
import '../database/drift_database.dart';

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
              builder: (_) => ScheduleBottomSheet(
                selectedDate: selectedDate, // 선택된 날짜를 ScheduleBottomSheet 위젯에 전달합니다.
              ),
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
              // StreamBuilder는 스트림의 데이터를 수신하고 UI를 업데이트합니다.
              StreamBuilder<List<Schedule>>(
                  stream: GetIt.I.get<LocalDatabase>().watchSchedules(selectedDate),
                  builder: (c, snapshot) {
                    return TodayBanner(
                      selectedDate: selectedDate,
                      count: snapshot.data?.length ?? 0,
                    );
                  }),
              const SizedBox(height: 8.0),
              Expanded(
                // StreamBuilder는 스트림의 데이터를 수신하고 UI를 업데이트합니다.
                child: StreamBuilder<List<Schedule>>(
                  stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                  builder: (c, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    // snapshot.data는 선택된 날짜의 일정 목록을 나타냅니다.
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (c, i) {
                        final schedule = snapshot.data![i];
                        // Dismissible 위젯은 사용자가 스와이프하여 항목을 삭제할 수 있도록 합니다.
                        return Dismissible(
                          key: ValueKey(schedule.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                            child: ScheduleCard(
                              startTime: schedule.startTime,
                              endTime: schedule.endTime,
                              content: schedule.content,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  // onDaySelected 메서드는 사용자가 캘린더에서 날짜를 선택했을 때 호출됩니다.
  // 이 메서드는 선택된 날짜를 상태로 저장합니다.
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
