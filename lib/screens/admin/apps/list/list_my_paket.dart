import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/paket_my_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/common/detail_image.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/image_service.dart';

class ListMyPaketPage extends StatefulWidget {
  const ListMyPaketPage({super.key});

  @override
  State<ListMyPaketPage> createState() => _ListMyPaketPageState();
}

class _ListMyPaketPageState extends State<ListMyPaketPage> {
  List<Map<String, dynamic>> pakets = [];
  List<Map<String, dynamic>> pakets_belum = [];
  List<Map<String, dynamic>> pakets_sudah = [];
  String? role;
  String error = "";
  // ignore: unused_field
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    getPaket();
  }

  String formatTanggal(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal).toLocal();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  Future<void> getPaket() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });

    try {
      pakets_belum.clear();
      pakets_sudah.clear();
      role = await getRole();
      String? token = await getToken();
      var response = await getDataToken('/paket', token!);
      if (response['data'] != null) {
        setState(() {
          pakets = (response['data'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        });
        print('Data Paket: $pakets');

        for (int i = 0; i < pakets.length; i++) {
          if (pakets[i]["status_pengambilan"] == "belum") {
            pakets_belum.add(pakets[i]);
          } else {
            pakets_sudah.add(pakets[i]);
          }
        }
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
              Text("${paket['pemilik_paket']['nama']}", style: kBoldTextStyle),
              const SizedBox(
                height: 10,
              ),
              if (paket['status_pengambilan'] == "belum")
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    FontAwesomeIcons.locationPin,
                    size: 18,
                    color: kRed,
                  ),
                  const SizedBox(width: 5),
                  
                    Expanded(
                        child: Text(
                      "Helpdesk",
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Expanded(child: Text("${formatTanggal(paket['waktu_tiba'])} (Diterima)")),
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
                    Expanded(
                      child: Text(
                          "${formatTanggal(paket['waktu_diambil'])} (Diserahkan)"),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const AppBarPage(
                title: 'My Paket',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                                (index) => GestureDetector(
                                      onTap: () {
                                        showPaketDetail(pakets_belum[index]);
                                      },
                                      child: MyPaketCard(
                                        paket: pakets_belum[index],
                                      ),
                                    )),
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
                                (index) => GestureDetector(
                                      onTap: () {
                                        showPaketDetail(pakets_sudah[index]);
                                      },
                                      child: MyPaketCard(
                                        paket: pakets_sudah[index],
                                      ),
                                    )),
                          ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
