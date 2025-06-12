import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/common/add_report_page.dart';
import 'package:my_dorm/service/http_service.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  List<Map<String, dynamic>> laporans = [];
  String error = "";
  bool _showSpinner = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLaporan();
  }

  Future<void> getLaporan() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/laporan', token!);
      List<Map<String, dynamic>> parsedData = (response['data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      print(response);
      setState(() {
        laporans = parsedData;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    }
    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> _navigateAndDisplayResult(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddReportPage()));

    // Check what was returned and act accordingly
    if (result != null) {
      await getLaporan();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          AppBarPage(
            title: 'Laporan',
            onAdd: () async {
              await _navigateAndDisplayResult(context);
            },
          ),
          (_showSpinner)
              ? const Center(
                  child: CircularProgressIndicator(
                  color: kRed,
                ))
              : Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: laporans.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ShadowContainer(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    laporans[index]['judul'],
                                    style:
                                        kBoldTextStyle.copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    '10 Januari 2024',
                                    style: kMediumTextStyle.copyWith(
                                        fontSize: 14, color: kGrey),
                                  ),
                                  Text(
                                    'status: dalam proses',
                                    style: kMediumTextStyle.copyWith(
                                        fontSize: 14, color: kGrey),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    laporans[index]['isi'],
                                    style: kMediumTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }))
        ],
      ),
    );
  }
}
