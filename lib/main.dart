import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/models/data_model.dart';
import 'package:my_dorm/screens/admin/nav_helpdesk.dart';
import 'package:my_dorm/screens/admin/nav_sr.dart';
import 'package:my_dorm/screens/auth/login_page.dart';
import 'package:my_dorm/screens/dormitizen/home_dormitizen.dart';
import 'package:my_dorm/service/camera_service.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/myfirebasenotification_service.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await initializeDateFormatting('id_ID');
  final cameraService = CameraService();
  await cameraService.initializeCameras();
  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  DateTime selectedTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    21,
    45,
    0,
  );
  await notificationService.scheduleNotification(selectedTime);
  await FirebaseNotificationService.initialize();

  FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) async {
    print('FCM Token refreshed: $fcmToken');
    await postTokenFCM(fcmToken);
  });

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late String? role = "";
  bool _showSpinner = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _showSpinner = true;
    });
    role = await getRole();
    setState(() {
      _showSpinner = false;
    });
  }

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
          home: ModalProgressHUD(
            inAsyncCall: _showSpinner,
            child: (role == 'dormitizen')
                ? HomeDormitizen()
                : (role == 'senior_resident')
                    ? NavbarSR()
                    : (role == 'helpdesk')
                        ? NavBarHelpdesk()
                        : const LoginPage(),
          )),
    );
  }
}
