import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_pelanggaran_page.dart';
import 'package:my_dorm/service/http_service.dart';
import 'dart:developer' as dev;

class ListDetailPelanggaranPage extends StatefulWidget {
  final String namaDormitizen;
  const ListDetailPelanggaranPage({super.key, required this.namaDormitizen});

  @override
  State<ListDetailPelanggaranPage> createState() =>
      _ListDetailPelanggaranPageState();
}

class _ListDetailPelanggaranPageState extends State<ListDetailPelanggaranPage> {
  List<Map<String, dynamic>> pelanggarans = [];
  String error = "";
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    getPelanggaran();
  }

  String formatTanggal(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal).toLocal();
    return DateFormat('dd MMM yyyy • HH:mm').format(dateTime);
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarPage(
            title: 'Detail Pelanggaran',
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
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              "List Pelanggaran ${widget.namaDormitizen} ",
              style: kBoldTextStyle,
            ),
          ),
          const SizedBox(height: 15),
          if (_showSpinner)
            const Center(child: CircularProgressIndicator())
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
                itemCount: pelanggarans.length,
                itemBuilder: (context, index) {
                  final pelanggaran = pelanggarans[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ShadowContainer(
                      onTap: () {
                        // Tambahkan aksi ketika item diklik
                      },
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar Lokal Menggunakan Image.asset
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'images/dormitizen.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                            Icons.image_not_supported),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Informasi Pelanggaran
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.namaDormitizen,
                                        style: kBoldTextStyle.copyWith(
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            formatTanggal(pelanggaran['waktu']),
                                            style: kMediumTextStyle.copyWith(
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                                "Kamar: ${pelanggaran['dormitizen']['kamar']['nomor']}",
                                style: kMediumTextStyle.copyWith(fontSize: 15)),
                            const SizedBox(height: 4),
                            Text("Kategori: ${pelanggaran['kategori']}",
                                style: kMediumTextStyle.copyWith(fontSize: 15)),
                            const SizedBox(height: 4),
                            Text("Bukti:",
                                style: kMediumTextStyle.copyWith(fontSize: 15)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: Image.asset(
                                'images/bukti_pelanggaran.png',
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 1,
                          right: 1,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: kGradientMain,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.pencil,
                                      size: 16,
                                      color: kWhite,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Edit",
                                      style: kBoldTextStyle.copyWith(
                                          color: kWhite, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
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
