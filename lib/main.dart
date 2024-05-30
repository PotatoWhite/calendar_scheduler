import 'package:calendar_scheduler/screen/home_sreen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'database/drift_database.dart';
import 'provider/schedule_provider.dart';
import 'repository/schedule_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  //db init
  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final repository = ScheduleRepository();
  final provider = ScheduleProvider(repository: repository);

  runApp(ChangeNotifierProvider(
    create: (_) => provider,
    child: MaterialApp(
      home: HomeScreen(),
    ),
  ));
}
