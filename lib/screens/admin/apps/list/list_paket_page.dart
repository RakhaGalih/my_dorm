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
      String? token = await getToken();
      var response = await getDataToken('/paket/all', token!);
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
                                builder: (context) => const DetailImagePage(
                                    imagepath: 'images/paket.png')));
                      },
                      child: Image.asset(
                        'images/paket.png',
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
                  "${paket['dormitizen']['nama']} (${paket['dormitizen']['kamar']['nomor']})",
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
                  paket['status_pengambilan'] == "belum"
                      ? Text(
                          "Helpdesk",
                          style: kSemiBoldTextStyle.copyWith(
                              fontSize: 12, color: kRed),
                        )
                      : Text(
                          "Kamar ${paket['dormitizen']['kamar']['nomor']}",
                          style: kSemiBoldTextStyle.copyWith(
                              fontSize: 12, color: kRed),
                        )
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
                  Text(
                    "${paket['penerima paket']['nama']} (Pj Penerimaan)",
                    style: kSemiBoldTextStyle.copyWith(fontSize: 12),
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
                    Text(
                      "${paket['penyerahan paket']['nama']} (Pj Penerimaan)",
                      style: kSemiBoldTextStyle.copyWith(fontSize: 12),
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
                    GradientButton(ontap: () {}, title: "Edit"),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlineButton(
                        ontap: () {
                          confirmDialog(
                              context,
                              "Konfirmasi Penghapusan",
                              "Apakah anda yakin ingin menghapus data paket ini",
                              () {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Column(children: [
            AppBarPage(
              title: 'Paket',
              onAdd: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPaketPage()));
              },
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
                      child: const Row(
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
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kGrey),
                      ),
                      child: const Icon(Icons.filter_alt)),
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
                                      child: PaketCard(
                                        nomorKamar: pakets_belum[index]
                                            ['dormitizen']['kamar']['nomor'],
                                        paketSampai:
                                            '${formatTanggal(pakets_belum[index]['waktu_tiba'])} (Paket Sampai)',
                                        paketDiambil: pakets_belum[index]
                                                    ['status_pengambilan'] ==
                                                'sudah'
                                            ? '${formatTanggal(pakets_belum[index]['waktu_diambil'])} (Paket Diambil)'
                                            : '-',
                                        namaDormitizen: pakets_belum[index]
                                            ['dormitizen']['nama'],
                                        status: pakets_belum[index]
                                            ['status_pengambilan'],
                                        pjPaket:
                                            '${pakets_belum[index]['penerima paket']['nama']} (Pj Paket)',
                                      ),
                                    ),
                                    Positioned(
                                      top: 15,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {},
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
                                    child: PaketCard(
                                      nomorKamar: pakets_sudah[index]
                                          ['dormitizen']['kamar']['nomor'],
                                      paketSampai:
                                          '${formatTanggal(pakets_sudah[index]['waktu_tiba'])} (Paket Sampai)',
                                      paketDiambil: pakets_sudah[index]
                                                  ['status_pengambilan'] ==
                                              'sudah'
                                          ? '${formatTanggal(pakets_sudah[index]['waktu_diambil'])} (Paket Diambil)'
                                          : '-',
                                      namaDormitizen: pakets_sudah[index]
                                          ['dormitizen']['nama'],
                                      status: pakets_sudah[index]
                                          ['status_pengambilan'],
                                      pjPaket:
                                          '${pakets_sudah[index]['penerima paket']['nama']} (Pj Paket)',
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
