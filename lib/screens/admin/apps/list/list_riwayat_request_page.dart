import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/filter_button.dart';
import 'package:my_dorm/components/search_container.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/components/log_box.dart';
import 'package:my_dorm/models/request_model.dart';
import 'package:my_dorm/screens/admin/apps/form/add_log_page.dart';

class ListRiwayatRequestPage extends StatelessWidget {
  const ListRiwayatRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<RequestModel> logs = [
      RequestModel(
          name: "Rakha Galih Nugraha S", type: "In", date: DateTime.now()),
      RequestModel(
          name: "Iksan Oktav Risandy", type: "In", date: DateTime.now()),
      RequestModel(name: "Abdillah Aufa", type: "Out", date: DateTime.now())
    ];
    return Scaffold(
        body: Column(children: [
      AppBarPage(
        title: 'Riwayat Request',
        onAdd: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddLogPage()));
        },
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            const Expanded(child: SearchBox(placehold: "Cari Riwayat log")),
            const SizedBox(
              width: 20,
            ),
            FilterButton()
          ],
        ),
      ),
      Column(
          children: List.generate(
              logs.length,
              (index) => LogBox(
                    nama: logs[index].name,
                    type: logs[index].type,
                    date: logs[index].date,
                  )))
    ]));
  }
}
