import 'package:calendar_scheduler/screen/home_sreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
