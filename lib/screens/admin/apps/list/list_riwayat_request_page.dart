import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/filter_button.dart';
import 'package:my_dorm/components/search_container.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/components/log_box.dart';
import 'package:my_dorm/models/request_model.dart';
import 'package:my_dorm/screens/admin/apps/form/add_log_page.dart';
import 'package:my_dorm/service/http_service.dart';

class ListRiwayatRequestPage extends StatefulWidget {
  const ListRiwayatRequestPage({super.key});

  @override
  State<ListRiwayatRequestPage> createState() => _ListRiwayatRequestPageState();
}

class _ListRiwayatRequestPageState extends State<ListRiwayatRequestPage> {
  List<RequestModel> logs = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs({String? search}) async {
    try {
      String queryString = '';
      if (search != null && search.isNotEmpty) {
        queryString = '?search=${Uri.encodeQueryComponent(search)}';
      }
      final result = await fetchLogKeluarMasuk(queryString: queryString);
      setState(() {
        logs = result;
        isLoading = false;
      });
    } catch (e) {
      print("Gagal mengambil data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = logs.where((log) => log.status != 'pending').toList();
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
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kGrey),
          ),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 5),
              Expanded(
                  child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'cari judul',
                    border: InputBorder.none,
                    isDense: true),
                onChanged: (value) {
                  fetchLogs(search: value);
                },
              ))
            ],
          ),
        ),
      ),
      Expanded(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredLogs.isEmpty
                ? const Center(child: Text('Tidak ada riwayat log.'))
                : ListView.builder(
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return LogBox(
                        nama: log.name,
                        type: log.type,
                        date: log.date,
                      );
                    },
                  ),
      ),
    ]));
  }
}
