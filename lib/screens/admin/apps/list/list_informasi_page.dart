import 'package:flutter/material.dart';
import 'package:googleapis/iam/v1.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/components/info_card.dart';
import 'package:my_dorm/components/outline_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_informasi_page.dart';
import 'package:my_dorm/screens/admin/apps/form/edit_informasi_page.dart';
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
  String? _selectedKategori;
  final List<Map<String, String>> _kategoriList = [
    {'label': 'Fasilitas asrama', 'value': 'fasilitas asrama'},
    {'label': 'Event asrama', 'value': 'event asrama'},
    {'label': 'Lingkungan asrama', 'value': 'lingkungan asrama'},
    {'label': 'Peraturan asrama', 'value': 'peraturan asrama'},
  ];
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

  Future<void> getInformasi({String? search, String? kategori}) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      List<String> queryParams = [];
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=${Uri.encodeQueryComponent(search)}');
      }
      if (kategori != null && kategori.isNotEmpty) {
        queryParams.add('kategori=${Uri.encodeQueryComponent(kategori)}');
      }
      String queryString =
          queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
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

  void _deleteInformasi(String informasiId) async {
    setState(() {
      _showSpinner = true;
    });
    try {
      var response = await deleteDataToken('/informasi/$informasiId');
      if (response['message'] == 'Informasi berhasil dihapus') {
        setState(() {
          informasis.removeWhere(
              (informasi) => informasi['informasi_id'] == informasiId);
        });
        Navigator.pop(context);
      } else {
        setState(() {
          error = "Gagal menghapus pelanggaran";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    } finally {
      setState(() {
        _showSpinner = false;
      });
      Navigator.pop(context);
    }
  }

  void _showActionDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Aksi Informasi',
            style: kBoldTextStyle,
          ),
          backgroundColor: kWhite,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Aksi apa yang ingin Anda lakukan?'),
                const SizedBox(height: 10),
                GradientButton(
                  ontap: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditInformasiPage(
                                  item: item,
                                )));
                    if (result != null) {
                      refresh();
                    }
                  },
                  title: "EDIT",
                ),
                const SizedBox(height: 10),
                OutlineButton(
                    ontap: () {
                      confirmDialog(context, "Konfirmasi Penghapusan",
                          "Apakah anda yakin ingin menghapus informasi ini?",
                          () {
                        _deleteInformasi(item['informasi_id']);
                      });
                    },
                    title: "DELETE"),
              ],
            ),
          ),
        );
      },
    );
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
            child: Column(
              children: [
                Row(
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
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.filter_alt),
                        onSelected: (String value) {
                          setState(() {
                            _selectedKategori = value;
                          });
                          getInformasi(
                            search: _searchController.text,
                            kategori: value,
                          );
                        },
                        itemBuilder: (BuildContext context) {
                          return _kategoriList.map((item) {
                            return PopupMenuItem<String>(
                              value: item['value']!,
                              child: Text(item['label']!),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
                if (_selectedKategori != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Filter: ${_kategoriList.firstWhere((item) => item['value'] == _selectedKategori)['label']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
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
                        onHold: () {
                          _showActionDialog(item);
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
