import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/common/faq_list_page.dart';

class PusatBantuanPage extends StatelessWidget {
  const PusatBantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          const AppBarPage(title: 'Pusat bantuan'),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.support_agent_rounded,
              size: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          ShadowContainer(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FaqListPage()));
              },
              child: Row(
                children: [
                  const Icon(FluentIcons.info_24_filled),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    'FAQ',
                    style: kBoldTextStyle.copyWith(fontSize: 14),
                  ),
                  const Spacer(),
                  const Icon(FluentIcons.chevron_right_24_filled)
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          /*ShadowContainer(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportListPage()));
              },
              child: Row(
                children: [
                  const Icon(
                    FluentIcons.warning_24_filled,
                    color: kMain,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Laporkan Masalah',
                    style: kBoldTextStyle.copyWith(fontSize: 14, color: kMain),
                  ),
                  const Spacer(),
                  const Icon(
                    FluentIcons.chevron_right_24_filled,
                    color: kMain,
                  )
                ],
              ))*/
        ],
      ),
    );
  }
}
