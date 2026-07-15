import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/pair_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/reminder_provider.dart';
import 'services/database_service.dart';
import 'theme/app_colors.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await DatabaseService.init();

  final db = DatabaseService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PairProvider(db)),
        ChangeNotifierProvider(create: (_) => JournalProvider(db)),
        ChangeNotifierProvider(create: (_) => ReminderProvider(db)),
      ],
      child: const ZenithApp(),
    ),
  );
}
