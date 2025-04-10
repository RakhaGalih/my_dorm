import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_dorm/constant/constant.dart';

class PaketCard extends StatelessWidget {
  final String namaDormitizen;
  final String nomorKamar;
  final String paketSampai;
  final String paketDiambil;
  final String status;
  final String pjPaket;

  const PaketCard({
    super.key,
    required this.namaDormitizen,
    required this.nomorKamar,
    required this.paketSampai,
    required this.paketDiambil,
    required this.status,
    required this.pjPaket,
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
          Image.asset('images/paket.png', width: 80, height: 80),
          const SizedBox(height: 5),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kamar $nomorKamar",
                style: kBoldTextStyle.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 5),
              if (status == "belum")
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
                  const Icon(
                    FontAwesomeIcons.solidCircleUser,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    namaDormitizen,
                    style: kSemiBoldTextStyle.copyWith(fontSize: 12),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: kGrey),
                  const SizedBox(width: 5),
                  Text(
                    paketSampai,
                    style:
                        kSemiBoldTextStyle.copyWith(fontSize: 12, color: kGrey),
                  )
                ],
              ),
              const SizedBox(height: 5),
              if (status == "sudah")
                Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      size: 18,
                      color: kGrey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      paketDiambil,
                      style: kSemiBoldTextStyle.copyWith(
                          fontSize: 12, color: kGrey),
                    )
                  ],
                ),
              const SizedBox(height: 5),
            ],
          )
        ],
      ),
    );
  }
}
