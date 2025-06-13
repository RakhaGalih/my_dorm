// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_dorm/components/appbar_home.dart';
import 'package:my_dorm/components/apps_icon.dart';
import 'package:my_dorm/components/request_box.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/request_model.dart';
import 'package:my_dorm/screens/admin/apps/list/list_informasi_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_my_log.dart';
import 'package:my_dorm/screens/admin/apps/list/list_my_paket.dart';
import 'package:my_dorm/screens/admin/apps/list/list_paket_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_paket_page_dormitizen.dart';
import 'package:my_dorm/screens/admin/apps/list/list_riwayat_request_page.dart';
import 'package:my_dorm/screens/auth/login_page.dart';
import 'package:my_dorm/service/converter.dart';
import 'package:my_dorm/service/http_service.dart';

class HomePageSR extends StatefulWidget {
  const HomePageSR({
    super.key,
  });

  @override
  State<HomePageSR> createState() => _HomePageSRState();
}

class _HomePageSRState extends State<HomePageSR> {
  String nama = 'loading...';
  String kamarTerbuka = '0';
  String kamarTertutup = '0';
  String error = "";
  String statusKamar = '';
  String waktuSekarang = '';
  bool _showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waktuSekarang = getFormattedTime();
    _getInfo();
    _getInfoKamar();
    _getStatusKamar();
    _getLogKeluarMasuk();
  }

  void _getInfo() async {
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
      });
      error = "${response['message']}";
      print(response);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  void _getInfoKamar() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      String? token = await getToken();
      response = await getDataToken("/kamar/status/all", token!);
      print(response);
      kamarTerbuka = response['countTerbuka'].toString();
      kamarTertutup = response['countTertutup'].toString();
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
      print('error: $e');
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

  void _getLogKeluarMasuk() async {
    setState(() {
      error = "";
      _showSpinner = true;
    });

    try {
      List<RequestModel> result = await fetchLogKeluarMasuk();
      print(result
          .map((r) =>
              'ID: ${r.id},Name: ${r.name}, Type: ${r.type}, Date: ${r.date}, Status: ${r.status}')
          .toList());

      print("tesssss");
      setState(() {
        requests = result;
      });
    } catch (e) {
      print("Gagal mengambil log keluar masuk: $e");
    }
  }

  List<RequestModel> requests = [];
  @override
  Widget build(BuildContext context) {
    final pendingRequests =
        requests.where((r) => r.status == 'pending').toList();
    void popList(RequestModel item) {
      setState(() {
        requests.removeWhere((r) => r.id == item.id);
      });
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
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
                          width: width, fit: BoxFit.cover),
                    ),
                    SafeArea(
                      bottom: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppBarHome(
                                titleContent: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Kunci di Kamar',
                                        style: kSemiBoldTextStyle.copyWith(
                                            fontSize: 14, color: kWhite),
                                      ),
                                      Text(
                                        kamarTerbuka,
                                        style: kBoldTextStyle.copyWith(
                                            fontSize: 45, color: kWhite),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Kunci di helpdesk',
                                        style: kSemiBoldTextStyle.copyWith(
                                            fontSize: 14, color: kWhite),
                                      ),
                                      Text(
                                        kamarTertutup,
                                        style: kBoldTextStyle.copyWith(
                                            fontSize: 45, color: kWhite),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.symmetric(horizontal: 30),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Request Dormitizen',
                            style: kBoldTextStyle.copyWith(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListRiwayatRequestPage()));
                            },
                            child: Text(
                              'Lihat Semua',
                              style: kMediumTextStyle.copyWith(
                                  fontSize: 14, color: kMain),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (pendingRequests.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(44),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(child: Image.asset('images/women.png')),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    'Tidak ada request',
                                    style: kBoldTextStyle.copyWith(
                                        fontSize: 14, color: kGrey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                                children: List.generate(
                                    pendingRequests.length,
                                    (index) => RequestBox(
                                          nama: pendingRequests[index].name,
                                          type: pendingRequests[index].type,
                                          onAccept: () async {
                                            await updateStatusLog(
                                                pendingRequests[index].id,
                                                'diterima');
                                            popList(pendingRequests[index]);
                                          },
                                          onReject: () async {
                                            await updateStatusLog(
                                                pendingRequests[index].id,
                                                'ditolak');
                                            popList(pendingRequests[index]);
                                          },
                                        ))),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Apps',
                        style: kBoldTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AppsIcon(
                                icon: FontAwesomeIcons.history,
                                title: 'Riwayat Request',
                                pushWidget: ListRiwayatRequestPage(),
                              ),
                              AppsIcon(
                                icon: FontAwesomeIcons.box,
                                title: 'Paket',
                                pushWidget: ListPaketPageSR(),
                              ),
                              AppsIcon(
                                icon: FontAwesomeIcons.bullhorn,
                                title: 'Informasi',
                                pushWidget: ListInformasiPage(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AppsIcon(
                                icon: FontAwesomeIcons.bookmark,
                                title: 'My Log',
                                pushWidget: ListMyLog(),
                              ),
                              AppsIcon(
                                icon: FontAwesomeIcons.boxArchive,
                                title: 'My Paket',
                                pushWidget: ListMyPaketPage(),
                              ),
                              Expanded(child: SizedBox())
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
