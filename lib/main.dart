import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dorm/models/data_model.dart';
import 'package:my_dorm/screens/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final NotificationService _notificationService = NotificationService();
  await _notificationService.initialize();
  DateTime selectedTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    21,
    19,
    0,
  );
  await _notificationService.scheduleNotification(selectedTime);
  // _notificationService.showInstantNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<DataModel>(
      create: (_) => DataModel(),
      child: MaterialApp(
          theme: ThemeData(fontFamily: "Sans", primarySwatch: Colors.red),
          home: const LoginPage()),
    );
  }
}
