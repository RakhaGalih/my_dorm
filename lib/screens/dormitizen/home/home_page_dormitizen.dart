import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_home.dart';
import 'package:my_dorm/components/info_card.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/auth/login_page.dart';
import 'package:my_dorm/service/converter.dart';
import 'package:my_dorm/service/http_service.dart';

class HomePageDormitizen extends StatefulWidget {
  const HomePageDormitizen({super.key});

  @override
  State<HomePageDormitizen> createState() => _HomePageDormitizenState();
}

class _HomePageDormitizenState extends State<HomePageDormitizen> {
  String nama = 'loading...';
  List<Map<String, dynamic>> pakets = [];
  List<Map<String, dynamic>> informasis = [];
  String error = "";
  String statusKamar = '';
  String waktuSekarang = '';
  // ignore: unused_field
  bool _showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waktuSekarang = getFormattedTime();
    _getInfoUser();
    _getStatusKamar();
    _getInformasi();
  }

  void _getInfoUser() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      String? token = await getToken();

      response = await getDataToken("/user/me", token!);
      print(response);
      nama = response['data']['nama'];
    } catch (e) {
      if (e.toString() == 'Exception: Unauthorized or Forbidden') {
        print('Session expired');
        await removeToken();
        setState(() {
          _showSpinner = false;
          error = "Session expired, silahkan login kembali";
        });
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      }
      setState(() {
        _showSpinner = false;
        error = "Email atau Password salah";
      });
      error = "${response['message']}";
      print('Login error: $e');
      print(response);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  void _getStatusKamar() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/kamar/status', token!);
      print(response);

      setState(() {
        statusKamar = response['data']['status'];
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

  Future<void> _getInformasi() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/informasi', token!);
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(children: [
          SizedBox(
            height: 145,
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
                        'Selamat $waktuSekarang,',
                        style: kSemiBoldTextStyle.copyWith(
                            color: kWhite, fontSize: 15),
                      ),
                      Text(
                        nama,
                        style: kBoldTextStyle.copyWith(
                            color: kWhite, fontSize: 20),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: kRed,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: kWhite,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                'Kunci Anda Sekarang berada di ',
                                style: kRegularTextStyle.copyWith(
                                    color: kWhite, fontSize: 12),
                              ),
                              Text(
                                (statusKamar == '')
                                    ? 'Loading...'
                                    : (statusKamar == 'terkunci')
                                        ? 'Helpdesk'
                                        : 'Kamar Anda',
                                style: kBoldTextStyle.copyWith(
                                    color: kWhite, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Informasi Terbaru',
                      style: kSemiBoldTextStyle.copyWith(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/list-informasi');
                      },
                      child: Text(
                        'Lihat Semua',
                        style: kSemiBoldTextStyle.copyWith(
                            color: kMain, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                (informasis.isEmpty)
                    ? const Center(
                        child: Text(
                          'Tidak ada informasi terbaru',
                          style: kRegularTextStyle,
                        ),
                      )
                    : InformasiCard(item: informasis[0]),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat',
                      style: kSemiBoldTextStyle.copyWith(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/list-informasi');
                      },
                      child: Text(
                        'Lihat Semua',
                        style: kSemiBoldTextStyle.copyWith(
                            color: kMain, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}
