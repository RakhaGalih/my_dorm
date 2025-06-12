// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/common/pusat_bantuan_page.dart';

class AppBarHome extends StatelessWidget {
  final Widget titleContent;
  const AppBarHome({
    super.key,
    required this.titleContent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          children: [
            titleContent,
            const Spacer(),
            GestureDetector(
              onTap: () {
                /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Report()));*/
              },
              child: IconButton(
                icon: const Icon(
                  FluentIcons.warning_20_filled,
                  size: 25,
                  color: kWhite,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PusatBantuanPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
