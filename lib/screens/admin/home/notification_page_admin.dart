import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class NotificationPageAdmin extends StatefulWidget {
  const NotificationPageAdmin({super.key});

  @override
  State<NotificationPageAdmin> createState() => _NotificationPageAdminState();
}

class _NotificationPageAdminState extends State<NotificationPageAdmin> {
  List<Map<String, dynamic>> notifications = [];
  bool _showSpinner = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // under construction ya
  Future<void> _loadNotifications() async {
    try {
      String? token = await getToken();
      var response = await getDataToken('/notification/me', token!);
      List<Map<String, dynamic>> parsedData = (response['data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      dev.log("Data Notifikasi: $parsedData");
      setState(() {
        notifications = parsedData;
        _showSpinner = false;
      });
    } catch (e) {
      error = "Error: $e";
    } finally {
      _showSpinner = false;
    }
  }

  String waktuLalu(String createdAt) {
    DateTime createdTime = DateTime.parse(createdAt).toLocal();
    Duration diff = DateTime.now().difference(createdTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} detik lalu';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} minggu lalu';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} bulan lalu';
    } else {
      return '${(diff.inDays / 365).floor()} tahun lalu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const AppBarPage(
        title: 'Notifikasi',
        canBack: false,
      ),
      if (_showSpinner)
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: CircularProgressIndicator(
            color: kMain,
          )),
        )
      else if (notifications.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              const Icon(
                Icons.notifications_none,
                size: 120,
                color: kRed,
              ),
              const SizedBox(height: 25),
              Text("Tidak ada riwayat notifikasi",
                  style: kMediumTextStyle.copyWith(color: Colors.black)),
            ],
          ),
        )
      else if (error.isNotEmpty)
        Center(
          child: Text(
            error,
            style: kMediumTextStyle.copyWith(color: Colors.red),
          ),
        )
      else
        Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ShadowContainer(
                        onLongPress: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification['judul'],
                                    style: kBoldTextStyle.copyWith(fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      waktuLalu(notification['created_at']),
                                      style: kMediumTextStyle.copyWith(
                                          fontSize: 14, color: kGrey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              notification['isi'],
                              style: kMediumTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                  );
                }))
    ]);
  }
}
