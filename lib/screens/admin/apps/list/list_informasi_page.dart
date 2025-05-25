import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/info_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_informasi_page.dart';
import 'package:my_dorm/service/http_service.dart';

class ListInformasiPage extends StatefulWidget {
  const ListInformasiPage({super.key});

  @override
  State<ListInformasiPage> createState() => _ListInformasiPageState();
}

class _ListInformasiPageState extends State<ListInformasiPage> {
  List<Map<String, dynamic>> informasis = [];
  String error = "";
  bool _showSpinner = false;
  @override
  void initState() {
    super.initState();
    getInformasi();
  }

  Future<void> getInformasi() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/berita', token!);
      List<Map<String, dynamic>> parsedData = (response['data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      print(response);
      setState(() {
        informasis = parsedData;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  Future<void> _navigateAndDisplayResult(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditInformasiPage()));

    // Check what was returned and act accordingly
    if (result != null) {
      await getInformasi();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarPage(
            title: 'Informasi',
            onAdd: () {
              _navigateAndDisplayResult(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kGrey),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 5),
                        Text('Cari')
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kGrey),
                  ),
                  child: const Icon(Icons.filter_alt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          (_showSpinner)
              ? const Center(
                  child: CircularProgressIndicator(
                  color: kRed,
                ))
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: informasis.length,
                    itemBuilder: (context, index) {
                      final item = informasis[index];
                      return InformasiCard(item: item);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
