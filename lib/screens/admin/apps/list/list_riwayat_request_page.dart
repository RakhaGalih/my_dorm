import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/screens/admin/apps/form/add_log_page.dart';

class ListRiwayatRequestPage extends StatelessWidget {
  const ListRiwayatRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      AppBarPage(
        title: 'Riwayat Request',
        onAdd: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddLogPage()));
        },
      ),
    ]));
  }
}
