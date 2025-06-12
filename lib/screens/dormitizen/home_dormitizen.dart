import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/components/main_nav_bar_home.dart';
import 'package:my_dorm/models/navbar_model.dart';
import 'package:my_dorm/screens/admin/home/notification_page_admin.dart';
import 'package:my_dorm/screens/dormitizen/home/home_page_dormitizen.dart';
import 'package:my_dorm/screens/dormitizen/home/unused_home_page_dormitizen.dart';
import 'package:my_dorm/screens/dormitizen/home/paket_page_dormitizen.dart';
import 'package:my_dorm/screens/dormitizen/home/profil_page_dormitizen.dart';

class HomeDormitizen extends StatelessWidget {
  final List<NavBarModel> navIcons = [
    NavBarModel(icon: FluentIcons.home_24_filled, title: 'Beranda'),
    NavBarModel(
      icon: FluentIcons.box_24_filled,
      title: 'Paket',
    ),
    NavBarModel(
      icon: FluentIcons.alert_24_filled,
      title: 'Notifikasi',
    ),
    NavBarModel(
      icon: FluentIcons.person_24_filled,
      title: 'Profil',
    ),
  ];
  final List<Widget> widgetOptions = <Widget>[
    const HomePageDormitizen(),
    const PaketPageDormitizen(),
    const NotificationPageAdmin(),
    const ProfilPageDromitizen(),
  ];

  HomeDormitizen({super.key});
  @override
  Widget build(BuildContext context) {
    return MainNavBarHome(widgetOptions: widgetOptions, navIcons: navIcons);
  }
}
