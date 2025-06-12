// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/converter.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/image_service.dart';

class MyPaketCard extends StatelessWidget {
  final Map<String, dynamic> paket;

  const MyPaketCard({
    super.key,
    required this.paket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 0.5),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      child: Row(
        children: [
          MyNetworkImage(
            imageURL: '$apiURL/images/paket/${paket['gambar']}',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paket['pemilik_paket']['nama'] ?? 'Tidak diketahui',
                  style: kBoldTextStyle.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                if ((paket['status_pengambilan'] ?? 'belum') == "belum")
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationPin,
                        size: 18,
                        color: kRed,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Helpdesk",
                        style: kSemiBoldTextStyle.copyWith(
                            fontSize: 12, color: kRed),
                      )
                    ],
                  ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 18, color: kGrey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        getFormattedDate(paket['waktu_tiba'] ?? '') ??
                            "Belum diambil",
                        style: kSemiBoldTextStyle.copyWith(
                            fontSize: 12, color: kGrey),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                if ((paket['status_pengambilan'] ?? 'belum') == "sudah")
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 18,
                        color: kGrey,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${paket['penerima_paket']['nama'] ?? 'Tidak diketahui'} (PJ Paket)',
                          style: kSemiBoldTextStyle.copyWith(
                              fontSize: 12, color: kGrey),
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 5),
              ],
            ),
          )
        ],
      ),
    );
  }
}
