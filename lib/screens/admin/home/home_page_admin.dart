import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_dorm/components/appbar_home.dart';
import 'package:my_dorm/components/apps_icon.dart';
import 'package:my_dorm/components/request_box.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/request_model.dart';
import 'package:my_dorm/screens/admin/apps/list/list_informasi_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_keterlambatan_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_paket_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_riwayat_request_page.dart';
import 'package:my_dorm/screens/admin/apps/list/list_statistik_page.dart';
import 'package:my_dorm/screens/common/unavailable_features.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  List<RequestModel> requests = [
    RequestModel(
        name: "Rakha Galih Nugraha S", type: "In", date: DateTime.now()),
    RequestModel(name: "Iksan Oktav Risandy", type: "In", date: DateTime.now()),
    RequestModel(name: "Abdillah Aufa", type: "Out", date: DateTime.now())
  ];
  @override
  Widget build(BuildContext context) {
    void popList(List L, int index) {
      setState(() {
        L.removeAt(index);
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
                                    'Selamat pagi,',
                                    style: kSemiBoldTextStyle.copyWith(
                                        color: kWhite, fontSize: 15),
                                  ),
                                  Text(
                                    'Senior Residents!',
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
                                        'Kunci kamar di Asrama',
                                        style: kSemiBoldTextStyle.copyWith(
                                            fontSize: 14, color: kWhite),
                                      ),
                                      Text(
                                        '110',
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
                                        'Kunci kamar di Luar',
                                        style: kSemiBoldTextStyle.copyWith(
                                            fontSize: 14, color: kWhite),
                                      ),
                                      Text(
                                        '50',
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
                    (requests.isEmpty)
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
                                    requests.length,
                                    (index) => RequestBox(
                                          nama: requests[index].name,
                                          type: requests[index].type,
                                          onAccept: () {
                                            popList(requests, index);
                                          },
                                          onReject: () {
                                            popList(requests, index);
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
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          AppsIcon(
                            icon: FontAwesomeIcons.history,
                            title: 'Riwayat\nRequest',
                            pushWidget: ListRiwayatRequestPage(),
                          ),
                          AppsIcon(
                            icon: FontAwesomeIcons.box,
                            title: 'Paket',
                            pushWidget: ListPaketPage(),
                          ),
                          AppsIcon(
                            icon: FontAwesomeIcons.bullhorn,
                            title: 'Informasi',
                            pushWidget: ListInformasiPage(),
                          ),
                          AppsIcon(
                            icon: FontAwesomeIcons.chartSimple,
                            title: 'Statistik',
                            // pushWidget: UnavailableFeaturesPage(),
                            pushWidget: ListStatistikPage(),
                          ),
                          AppsIcon(
                            icon: FluentIcons.chat_warning_24_filled,
                            title: 'Keterlambatan',
                            pushWidget: ListKeterlambatanPage(),
                          ),
                          AppsIcon(
                            icon:FluentIcons.warning_12_filled , 
                            title: 'Pelanggaran', 
                            pushWidget: ListKeterlambatanPage(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
