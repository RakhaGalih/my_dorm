import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';

class StatisticBox extends StatelessWidget {
  final DateTime date;
  final String url_file;

  const StatisticBox({super.key, required this.date, required this.url_file});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ShadowContainer(
        onTap: () {},
        child: Row(
          children: [
            const Icon(
              Icons.insert_drive_file_rounded,
              color: kRed,
              size: 45,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Log Keluar-Masuk",
                        textAlign: TextAlign.start,
                        style: kBoldTextStyle.copyWith(fontSize: 14)),
                    const Text(
                      "Statistik Keluar-Masuk Asrama",
                      style: TextStyle(fontSize: 10),
                    )
                  ]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: kGradientMain,
                    borderRadius: BorderRadius.circular(4)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.download_sharp, color: kWhite),
                      Text(
                        "Unduh",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
