import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/filter_button.dart';
import 'package:my_dorm/components/log_box.dart';
import 'package:my_dorm/components/search_container.dart';
import 'package:my_dorm/models/request_model.dart';
import 'package:my_dorm/service/http_service.dart';

class ListMyLog extends StatefulWidget {
  const ListMyLog({super.key});

  @override
  State<ListMyLog> createState() => _ListMyLogState();
}

class _ListMyLogState extends State<ListMyLog> {
  List<RequestModel> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      final result = await fetchLogKeluarMasukOfDormitizen(); // dari service
      setState(() {
        logs = result;
        isLoading = false;
      });
    } catch (e) {
      print("Gagal mengambil log: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Column(children: [
      const AppBarPage(
        title: 'My Log',
      ),
      const SizedBox(height: 20),
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
