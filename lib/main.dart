import 'package:calendar_scheduler/screen/home_sreen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'database/drift_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  //db init
  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database); // GetIt 패키지를 사용하여 의존성 주입을 수행합니다.

  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
