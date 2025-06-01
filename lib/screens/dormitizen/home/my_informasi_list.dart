import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/info_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_informasi_page.dart';
import 'package:my_dorm/service/http_service.dart';

class MyListInformasiPage extends StatefulWidget {
  const MyListInformasiPage({super.key});

  @override
  State<MyListInformasiPage> createState() => _MyListInformasiPageState();
}

class _MyListInformasiPageState extends State<MyListInformasiPage> {
  List<Map<String, dynamic>> informasis = [];
  String error = "";
  bool _showSpinner = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getInformasi();
  }

  Future<void> refresh() async {
    setState(() {
      _showSpinner = true;
      informasis.clear();
    });
    await getInformasi();
  }

  Future<void> getInformasi({String? search}) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      String queryString = '';
      if (search != null && search.isNotEmpty) {
        queryString = '?search=${Uri.encodeQueryComponent(search)}';
      }
      var response = await getDataToken('/informasi$queryString', token!);
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
        MaterialPageRoute(builder: (context) => const AddInformasiPage()));

    // Check what was returned and act accordingly
    if (result != null) {
      await getInformasi(search: _searchController.text);
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
          const AppBarPage(
            title: 'Informasi',
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
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 5),
                        Expanded(
                            child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                              hintText: 'cari judul',
                              border: InputBorder.none,
                              isDense: true),
                          onChanged: (value) {
                            getInformasi(search: value);
                          },
                        ))
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
                      return InformasiCard(
                        item: item,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
