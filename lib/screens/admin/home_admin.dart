import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/components/main_nav_bar_home.dart';
import 'package:my_dorm/models/navbar_model.dart';
import 'package:my_dorm/screens/admin/home/home_page_admin.dart';
import 'package:my_dorm/screens/admin/home/list_kamar_page_admin.dart';
import 'package:my_dorm/screens/admin/home/notification_page_admin.dart';
import 'package:my_dorm/screens/admin/home/profil_page_admin.dart';

class HomeAdmin extends StatelessWidget {
  final List<NavBarModel> navIcons = [
    NavBarModel(icon: FluentIcons.home_24_filled, title: 'Beranda'),
    NavBarModel(
      icon: FluentIcons.bed_24_filled,
      title: 'kamar',
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
    const HomePageAdmin(),
    const ListKamarPageAdmin(),
    const NotificationPageAdmin(),
    const ProfilPageAdmin(),
  ];
  HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavBarHome(widgetOptions: widgetOptions, navIcons: navIcons);
  }
}
