import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/filter_button.dart';
import 'package:my_dorm/components/search_container.dart';
import 'package:my_dorm/components/statistic_box.dart';
import 'package:my_dorm/models/statistic_model.dart';

class ListStatistikPage extends StatelessWidget {
  const ListStatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<StatisticModel> statistics = [
      StatisticModel(url_file: "temp", date: DateTime.now()),
      StatisticModel(url_file: "temp", date: DateTime.now()),
      StatisticModel(url_file: "temp", date: DateTime.now()),
      StatisticModel(url_file: "temp", date: DateTime.now()),
    ];

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
                const AppBarPage(
          title: 'Statistik',
                ),
                const SizedBox(height: 20),
                Column(
            children: List.generate(
                statistics.length,
                (index) => StatisticBox(
                    date: statistics[index].date,
                    url_file: statistics[index].url_file)))
              ]),
        ));
  }
}
