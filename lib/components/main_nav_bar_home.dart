// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_dorm/components/nav_icon.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/data_model.dart';
import 'package:my_dorm/models/navbar_model.dart';
import 'package:provider/provider.dart';
import 'package:my_dorm/service/http_service.dart';

class MainNavBarHome extends StatefulWidget {
  final List<Widget> widgetOptions;
  final List<NavBarModel> navIcons;
  const MainNavBarHome({
    super.key,
    required this.widgetOptions,
    required this.navIcons,
  });

  @override
  State<MainNavBarHome> createState() => _MainNavBarHomeState();
}

class _MainNavBarHomeState extends State<MainNavBarHome> {
  String statusKamar = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    try {
      final result = await fetchStatusKamar(); // <-- fungsi dari jawaban sebelumnya
      setState(() {
        statusKamar = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        statusKamar = 'Gagal';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, data, child) {
      return Scaffold(
        backgroundColor: kBgColor,
        body: Stack(
          children: [
            widget.widgetOptions[data.selectedNavBar],
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [basicDropShadow],
                      borderRadius: BorderRadius.circular(10)),
                  child: const SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                      )),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < widget.navIcons.length ~/ 2; i++)
                        Expanded(
                          child: NavIcon(
                            icon: widget.navIcons[i].icon,
                            title: widget.navIcons[i].title,
                            index: i,
                          ),
                        ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            confirmDialog(
                              context,
                              "Konfirmasi Request",
                              "Apakah Anda yakin ingin mengajukan request keluar/masuk?",
                              () async {
                                Navigator.of(context)
                                    .pop(); // Tutup dialog dulu
                                try {
                                  await requestKeluarMasuk(); // Fungsi untuk panggil API
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Request berhasil dikirim')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Gagal mengirim request')),
                                  );
                                }
                              },
                            );
                          },

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: kGradientMain),
                                child:  Icon(
                                  statusKamar == "Kamar terkunci"
                                  ? FontAwesomeIcons.doorClosed
                                  : FontAwesomeIcons.doorOpen,
                                  color: kWhite,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                statusKamar == "Kamar terkunci" ? 'Masuk' : 'Keluar',
                                style: kSemiBoldTextStyle.copyWith(
                                    fontSize: 14, color: kRed),
                              ),
                            ],
                          ),
                        ),
                      ),
                      for (int i = widget.navIcons.length ~/ 2;
                          i < widget.navIcons.length;
                          i++)
                        Expanded(
                          child: NavIcon(
                            icon: widget.navIcons[i].icon,
                            title: widget.navIcons[i].title,
                            index: i,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
