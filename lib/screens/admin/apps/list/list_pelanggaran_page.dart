import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_pelanggaran_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_detail_pelanggaran.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/image_service.dart';
import 'dart:developer' as dev;

class ListPelanggaranPage extends StatefulWidget {
  const ListPelanggaranPage({super.key});

  @override
  State<ListPelanggaranPage> createState() => _ListPelanggaranPageState();
}

class _ListPelanggaranPageState extends State<ListPelanggaranPage> {
  List<Map<String, dynamic>> pelanggarans = [];
  List<Map<String, dynamic>> dormitizens = [];
  int max_pelanggaran = 9;
  String error = "";
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    getPelanggaran();
    getDormitizenbyKamar();
  }

  Future<void> getDormitizenbyKamar() async {
    error = "";
    try {
      String? token = await getToken();
      var response = await getDataToken('/user/101', token!);
      List<Map<String, dynamic>> parsedData = (response['response'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      setState(() {
        for (int i = 0; i < parsedData.length; i++) {
          dormitizens
              .add({'nama': parsedData[i]['nama'], 'jml_pelanggaran': 0});
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    }
  }

  String formatTanggal(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal).toLocal();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  Future<void> getPelanggaran() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/pelanggaran', token!);
      List<Map<String, dynamic>> parsedData = (response['data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      print(response);
      setState(() {
        pelanggarans = parsedData;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    } finally {
      setState(() {
        _showSpinner = false;
        for (int i = 0; i < pelanggarans.length; i++) {
          for (int j = 0; j < dormitizens.length; j++) {
            if ((pelanggarans[i]['dormitizen']['nama'] ==
                    dormitizens[j]['nama']) &&
                (dormitizens[j]['jml_pelanggaran'] < max_pelanggaran)) {
              dormitizens[j]['jml_pelanggaran'] += 1;
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarPage(
            title: 'Daftar Pelanggaran',
            onAdd: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPelanggaranPage(
                      // Kirim semua data hasil pencarian
                      ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kGrey),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Cari')
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kGrey),
                    ),
                    child: Icon(Icons.filter_alt)),
              ],
            ),
          ),
          if (_showSpinner)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: CircularProgressIndicator(
                color: kMain,
              )),
            )
          else if (error.isNotEmpty)
            Center(
              child: Text(
                error,
                style: kMediumTextStyle.copyWith(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: dormitizens.length,
                itemBuilder: (context, index) {
                  final dormitizen = dormitizens[index];
                  double progressValue =
                      dormitizen['jml_pelanggaran'] / max_pelanggaran;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ShadowContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListDetailPelanggaranPage(
                                namaDormitizen: dormitizen['nama']),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: MyNetworkImage(
                              imageURL:
                                  'https://mydorm-mobile-backend-production.up.railway.app/images/${pelanggaran['gambar']}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Informasi Pelanggaran
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dormitizen['nama'],
                                  style: kBoldTextStyle.copyWith(fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: progressValue,
                                          minHeight: 8,
                                          backgroundColor: kGrey,
                                          valueColor:
                                              AlwaysStoppedAnimation(kRed),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    RichText(
                                        text: TextSpan(
                                            style: kMediumTextStyle.copyWith(
                                                fontSize: 15, color: kGrey),
                                            children: [
                                          TextSpan(
                                            text:
                                                "${dormitizen['jml_pelanggaran']}",
                                            style: kMediumTextStyle.copyWith(
                                                fontSize: 15, color: kRed),
                                          ),
                                          TextSpan(text: "/${max_pelanggaran}")
                                        ]))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
