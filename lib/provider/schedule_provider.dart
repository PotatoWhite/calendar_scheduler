import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../model/schedule_model.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository;

  // 현재 선택된 날짜 초기값은 현재 날짜
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 캐시된 일정 데이터
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({
    required this.repository,
  }) : super() {
    getSchedules(date: selectedDate);
  }

  // 주어진 날짜의 일정을 가져옵니다. 가져온 일정은 캐시에 저장
  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await repository.getSchedules(date: date);
    cache.update(date, (value) => resp, ifAbsent: () => resp);
    notifyListeners(); // 상태가 변경되었음을 알립니다.
  }

  // 새로운 일정을 생성합니다. 생성된 일정은 캐시에 저장
  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;

    final tempId = const Uuid().v4(); // 임시 id 생성
    final newSchedule = schedule.copyWith(id: tempId);

    // 1. 우선 Cache를 반영해서 화면을 업데이트 한다.
    cache.update(
        targetDate,
        (value) => [
              ...value,
              newSchedule,
            ]..sort((a, b) => a.startTime.compareTo(b.startTime)),
        ifAbsent: () => [newSchedule]);

    notifyListeners();

    // 2. DB에 저장하고 Cache에 tempID를 실제 ID로 업데이트한다.
    try {
      // API 호출
      final savedSchedule = await repository.createSchedule(schedule: schedule); // 일정 생성
      cache.update(
        // 캐시 업데이트
        targetDate,
        (value) => value
            .map((e) => e.id == tempId
                ? e.copyWith(
                    id: savedSchedule,
                  )
                : e)
            .toList(),
      );
    } catch (e) {
      // 실패 시 캐시에서 해당 일정을 제거
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  // cache를 먼저 지우고, DB에서도 삭제(실패시 cache에 다시 추가) 이렇게 복잡하게 하는 이유는 혹시나 하는 에러를 대비하기 위함
  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    // from cache
    final targetSchedule = cache[date]!.firstWhere((x) => x.id == id); // id가 일치하는 일정을 찾음

    // 1. Cache에서 해당 일정을 제거
    cache.update(
      date,
      (value) => value.where((x) => x.id != id).toList(), // id가 일치하는 일정을 제외한 나머지 일정을 반환
      ifAbsent: () => [],
    );

    // 2. DB에서 해당 일정을 제거
    try {
      await repository.deleteSchedule(id: id);
    } catch (e) {
      // 실패 시 캐시에 해당 일정을 다시 추가
      cache.update(
        date,
        (value) => [
          ...value,
          targetSchedule,
        ],
      );
    }

    notifyListeners();
  }

  // 선택된 날짜를 변경합니다.
  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;
    notifyListeners();
  }
}
