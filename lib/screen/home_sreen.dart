import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../component/schedule_card.dart';
import '../component/today_banner.dart';
import '../model/schedule_model.dart';

// HomeScreen 위젯은 앱의 홈 화면을 구성합니다.
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

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

  String selectedDateStr = '';

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
          child: Column(children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusDate) => onDaySelected(selectedDate, focusDate, context),
            ),
            const SizedBox(height: 16.0),
            // StreamBuilder는 스트림의 데이터를 수신하고 UI를 업데이트합니다.
            StreamBuilder<QuerySnapshot>(
              // StreamBuilder를 사용하여 스트림을 수신하고 UI를 생성
              stream: FirebaseFirestore.instance
                  .collection(
                    'schedules',
                  )
                  .where(
                    'date',
                    isEqualTo: selectedDateStr,
                  )
                  .snapshots(), // Firestore에 저장된 일정을 가져오기 위해 스트림을 생성
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0, // cache에 저장된 일정 개수를 가져와서 TodayBanner 위젯에 전달
                );
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // StreamBuilder를 사용하여 스트림을 수신하고 UI를 생성
                stream: FirebaseFirestore.instance
                    .collection(
                      'schedules',
                    )
                    .where(
                      'date',
                      isEqualTo: selectedDateStr,
                    )
                    .snapshots(), // Firestore에 저장된 일정을 가져오기 위해 스트림을 생성
                builder: (context, snapshot) {
                  // Stream을 가져오는 동안 에러가 났을 때 보여줄 화면
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('일정 정보를 가져오지 못했습니다.'),
                    );
                  }

                  // 로딩 중일 때 보여줄 화면
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  final schedules = snapshot.data!.docs
                      .map((e) => ScheduleModel.fromJson(
                            json: e.data() as Map<String, dynamic>,
                          ))
                      .toList();
                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];

                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          var delete = FirebaseFirestore.instance.collection('schedules').doc(schedule.id).delete(); //
                          delete.then((value) => debugPrint('삭제 성공')).catchError((error) => debugPrint('삭제 실패 : $error'));
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
          ]),
        ));
  }

  // onDaySelected는 날짜가 선택되었을 때 호출되는 콜백 함수입니다.
  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDay,
    BuildContext context,
  ) {
    setState(() {
      this.selectedDate = selectedDate;
      final formatter = DateFormat('yyyyMMdd');
      this.selectedDateStr = formatter.format(selectedDate);
    });
  }
}
