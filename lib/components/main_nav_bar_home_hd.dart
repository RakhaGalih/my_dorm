// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_dorm/components/nav_icon.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/data_model.dart';
import 'package:my_dorm/models/navbar_model.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:provider/provider.dart';

class MainNavBarHomeHD extends StatefulWidget {
  final List<Widget> widgetOptions;
  final List<NavBarModel> navIcons;
  const MainNavBarHomeHD({
    super.key,
    required this.widgetOptions,
    required this.navIcons,
  });

  @override
  State<MainNavBarHomeHD> createState() => _MainNavBarHomeHDState();
}

class _MainNavBarHomeHDState extends State<MainNavBarHomeHD> {
  String statusKamar = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    try {
      final result =
          await fetchStatusKamar(); // <-- fungsi dari jawaban sebelumnya
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
