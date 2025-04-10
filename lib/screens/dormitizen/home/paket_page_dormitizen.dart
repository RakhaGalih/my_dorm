import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_home.dart';
import 'package:my_dorm/components/paket_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/paket_model.dart';
import 'package:my_dorm/service/http_service.dart';

class PaketPageDormitizen extends StatefulWidget {
  const PaketPageDormitizen({super.key});

  @override
  State<PaketPageDormitizen> createState() => _PaketPageDormitizenState();
}

class _PaketPageDormitizenState extends State<PaketPageDormitizen> {
  List<Map<String, dynamic>> pakets = [];
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
      var response = await getDataToken('/paket', token!);
      if (response['data'] != null) {
        setState(() {
          pakets = (response['data'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        });
        print('Data Paket: $pakets');
      } else {
        setState(() {
          error = "Data paket dormitizen kosong.";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _showSpinner = false;
        error = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Stack(children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(gradient: kGradientMain),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('images/bg-asrama-wide.png',
                      width: double.infinity, fit: BoxFit.cover),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBarHome(
                      titleContent: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paket kamu akan',
                            style: kSemiBoldTextStyle.copyWith(
                                color: kWhite, fontSize: 15),
                          ),
                          Text(
                            'Teracatat di sini!',
                            style: kSemiBoldTextStyle.copyWith(
                                color: kWhite, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cari Paket :',
                            style: kSemiBoldTextStyle.copyWith(
                                fontSize: 14, color: kWhite),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kBlueGrey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nama Barang',
                                  prefixIcon: Icon(Icons.search),
                                  prefixIconColor: kBlueGrey),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Paket :',
                    style: kBoldTextStyle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: List.generate(
                        pakets.length,
                        (index) => PaketCard(
                              nomorKamar: pakets[index]['dormitizen']['kamar']
                                  ['nomor'],
                              paketSampai:
                                  '${formatTanggal(pakets[index]['waktu_tiba'])} (Paket Sampai)',
                              paketDiambil: pakets[index]
                                          ['status_pengambilan'] ==
                                      'sudah'
                                  ? '${formatTanggal(pakets[index]['waktu_diambil'])} (Paket Diambil)'
                                  : '-',
                              namaDormitizen: pakets[index]['dormitizen']
                                  ['nama'],
                              status: pakets[index]['status_pengambilan'],
                              pjPaket:
                                  '${pakets[index]['penerima paket']['nama']} (Pj Paket)',
                            )),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
