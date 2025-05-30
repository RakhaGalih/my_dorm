import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/components/outline_button.dart';
import 'package:my_dorm/components/paket_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_paket_page.dart';
import 'package:my_dorm/screens/common/detail_image.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/image_service.dart';

class ListPaketPage extends StatefulWidget {
  const ListPaketPage({super.key});

  @override
  State<ListPaketPage> createState() => _ListPaketPageState();
}

class _ListPaketPageState extends State<ListPaketPage> {
  List<Map<String, dynamic>> pakets = [];
  List<Map<String, dynamic>> pakets_belum = [];
  List<Map<String, dynamic>> pakets_sudah = [];
  String error = "";
  String? role;
  // ignore: unused_field
  bool _showSpinner = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getPaket();
  }

  String formatTanggal(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal).toLocal();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  Future<void> getPaket({String? search}) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });

    try {
      pakets_belum.clear();
      pakets_sudah.clear();
      role = await getRole();
      String? token = await getToken();
      String queryString = '';
      if (search != null && search.isNotEmpty) {
        queryString = '?search=${Uri.encodeQueryComponent(search)}';
      }
      var response = await getDataToken('/paket/all$queryString', token!);
      if (response['data'] != null) {
        setState(() {
          pakets = (response['data'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          print('Data Paket: $pakets');
          pakets_belum = [];
          pakets_sudah = [];
          for (int i = 0; i < pakets.length; i++) {
            if (pakets[i]["status_pengambilan"] == "belum") {
              pakets_belum.add(pakets[i]);
            } else {
              pakets_sudah.add(pakets[i]);
            }
          }
        });
      } else {
        setState(() {
          error = "Data paket dormitizen kosong.";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    }
    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> deletePaket(String id) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      await deleteDataToken('/paket/$id');

      print('Paket dengan ID $id berhasil dihapus');
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

  Future<void> updatePaket(String id) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      await updateDataTokenTanpaBody('/paket/$id');

      print('Paket dengan ID $id berhasil diupdate');
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

  void showPaketDetail(Map<String, dynamic> paket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailImagePage(
                                    imagepath:
                                        '$apiURL/images/paket/${paket['gambar']}')));
                      },
                      child: MyNetworkImage(
                        imageURL: '$apiURL/images/paket/${paket['gambar']}',
                        width: double.maxFinite,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Text("Ketuk untuk memperbesar",
                        style: kSemiBoldTextStyle.copyWith(
                            fontSize: 12, color: kWhite)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                  "${paket['pemilik_paket']['nama']} (${paket['pemilik_paket']['kamar']['nomor']})",
                  style: kBoldTextStyle),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.locationPin,
                    size: 18,
                    color: kRed,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                      child: paket['status_pengambilan'] == "belum"
                          ? Text(
                              "Helpdesk",
                              style: kSemiBoldTextStyle.copyWith(
                                  fontSize: 12, color: kRed),
                            )
                          : Text(
                              "Kamar ${paket['pemilik_paket']['kamar']['nomor']}",
                              style: kSemiBoldTextStyle.copyWith(
                                  fontSize: 12, color: kRed),
                            ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.solidCircleUser,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  if (paket['penerima_paket']['nama'] != null)
                    Expanded(
                      child: Text(
                        "${paket['penerima_paket']['nama']} (Pj Penerimaan)",
                        style: kSemiBoldTextStyle.copyWith(fontSize: 12),
                      ),
                    )
                ],
              ),
              if (paket['status_pengambilan'] == "sudah")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.solidCircleUser,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    if (paket['penyerah_paket']['nama'] != null)
                      Expanded(
                        child: Text(
                          "${paket['penyerah_paket']['nama']} (Pj Penerimaan)",
                          style: kSemiBoldTextStyle.copyWith(fontSize: 12),
                        ),
                      )
                  ],
                ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text("${formatTanggal(paket['waktu_tiba'])} (Diterima)"),
                ],
              ),
              if (paket['status_pengambilan'] == "sudah")
                const SizedBox(
                  height: 5,
                ),
              if (paket['status_pengambilan'] == "sudah")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.timer,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                        "${formatTanggal(paket['waktu_diambil'])} (Diserahkan)"),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    GradientButton(
                        ontap: () async {
                          await updatePaket(paket['paket_id']);
                          Navigator.of(context).pop();
                          await getPaket();
                        },
                        title: "Selesai"),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlineButton(
                        ontap: () {
                          confirmDialog(context, "Konfirmasi Penghapusan",
                              "Apakah anda yakin ingin menghapus data paket ini",
                              () async {
                            await deletePaket(paket['paket_id']);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await getPaket();
                          });
                        },
                        title: "Hapus Paket"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateAndDisplayResult(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddPaketPage()));

    // Check what was returned and act accordingly
    if (result != null) {
      await getPaket(search: _searchController.text);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Column(children: [
            AppBarPage(
              title: 'Paket',
              onAdd: (role == 'helpdesk')
                  ? () {
                      _navigateAndDisplayResult(context);
                    }
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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
                          Icon(Icons.search),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                hintText: 'nama penerima',
                                border: InputBorder.none,
                                isDense: true),
                            onChanged: (value) {
                              getPaket(search: value);
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  /*const SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kGrey),
                      ),
                      child: const Icon(Icons.filter_alt)),*/
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Paket belum diambil :',
                    style: kBoldTextStyle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (_showSpinner)
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kRed,
                          ),
                        )
                      : Column(
                          children: List.generate(
                              pakets_belum.length,
                              (index) => Stack(children: [
                                    InkWell(
                                        onTap: () {
                                          showPaketDetail(pakets_belum[index]);
                                        },
                                        child: GestureDetector(
                                          onLongPress: () {
                                            confirmDialog(
                                                context,
                                                "Konfirmasi Penghapusan",
                                                "Apakah anda yakin ingin menghapus data paket ini?",
                                                () async {
                                              await deletePaket(
                                                  pakets_belum[index]
                                                      ['paket_id']);
                                              Navigator.of(context).pop();
                                              await getPaket();
                                            });
                                          },
                                          child: PaketCard(
                                            paket: pakets_belum[index],
                                          ),
                                        )),
                                    Positioned(
                                      top: 15,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await updatePaket(
                                              pakets_belum[index]['paket_id']);
                                          await getPaket();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              gradient: kGradientMain,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.check,
                                                  size: 16,
                                                  color: kWhite,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Selesai",
                                                  style:
                                                      kBoldTextStyle.copyWith(
                                                          color: kWhite,
                                                          fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ])),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Paket sudah diambil :',
                    style: kBoldTextStyle.copyWith(fontSize: 14),
                  ),
                  (_showSpinner)
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kRed,
                          ),
                        )
                      : Column(
                          children: List.generate(
                              pakets_sudah.length,
                              (index) => InkWell(
                                    onTap: () {
                                      showPaketDetail(pakets_sudah[index]);
                                    },
                                    child: GestureDetector(
                                      onLongPress: () {
                                        confirmDialog(
                                            context,
                                            "Konfirmasi Penghapusan",
                                            "Apakah anda yakin ingin menghapus data paket ini",
                                            () async {
                                          await deletePaket(
                                              pakets_sudah[index]['paket_id']);
                                          Navigator.of(context).pop();
                                          await getPaket();
                                        });
                                      },
                                      child: PaketCard(
                                        paket: pakets_sudah[index],
                                      ),
                                    ),
                                  )),
                        ),
                ],
              ),
            ),
          ]),
        ));
  }
}
