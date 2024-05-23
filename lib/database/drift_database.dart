import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/schedule.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Schedule>> watchSchedules(DateTime date) => (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  Future<int> insertSchedule(SchedulesCompanion schedule) => into(schedules).insert(schedule);

  Future<void> updateSchedule(SchedulesCompanion schedule) => update(schedules).replace(schedule);

  Future<void> removeSchedule(int id) => (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
