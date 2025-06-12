import 'package:flutter/material.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/components/outline_button.dart';

const kGradientMain =
    LinearGradient(begin: Alignment(-1, -0.2), end: Alignment(1, 0.2), colors: [
  Color(0xFFCC3545),
  Color(0xFF994F56),
  Color(0xFF686767),
]);

const kGradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA1F2B8),
      Color(0xFF36C06E),
      Color(0xFF1D3F83),
    ]);
const kGradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA1D5F2),
      Color(0xFF366EC0),
      Color(0xFF6E1D83),
    ]);
const kGradientOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEFAB02),
      Color(0xFFF5911F),
      Color(0xFFFF5E0C),
    ]);
const kGradientRed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9597),
      Color(0xFFEA494C),
      Color(0xFF831D5A),
    ]);

const kRegularTextStyle = TextStyle(fontWeight: FontWeight.w400);
const kMediumTextStyle = TextStyle(fontWeight: FontWeight.w500);
const kSemiBoldTextStyle = TextStyle(fontWeight: FontWeight.w600);
const kBoldTextStyle = TextStyle(fontWeight: FontWeight.w700);

const kWhite = Color(0xFFFEFEFF);
const kBgColor = Color(0xFFF8F8F8);
const kGray = Color(0xFFD9D9D9);
const kGrey = Color(0xFFAEA7A7);
const kFormBG = Color(0xFFF0F0F0);
const kFormText = Color(0xFFABABAB);
const kRed = Color(0xFF994F56);
const kMain = Color(0xFFCC3545);
const kBlueGrey = Color(0xFF696F8E);
const kReddish = Color(0xFFEDD8D8);

BoxShadow basicDropShadow = BoxShadow(
    color: Colors.black.withOpacity(0.25),
    offset: const Offset(0, 4),
    blurRadius: 4);

InputDecoration basicInputDecoration(String title) {
  return InputDecoration(
    labelText: title,
    filled: true,
    fillColor: kFormBG,
    alignLabelWithHint: true,
    labelStyle: kRegularTextStyle.copyWith(color: kFormText),
    floatingLabelStyle: kRegularTextStyle.copyWith(color: kMain),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: kMain, width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE2E2E2), width: 2),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE2E2E2), width: 2),
    ),
  );
}

const seniorResidentsToken =
    "dltAcaffQkK9an5KhjzJUT:APA91bHkrVHrFPZuZmNyU5-bMkgJmZWTM3MolnOqZM35pPYlr3vTIoF7L-S-mgOCOsR3p-V-NlORmiF-O9iyN8a2QRwaXPoUmIzxck-aMQDlHwfcXEBF6_E";
const dormitizenToken =
    "eDlmG2sJRiWC-jPYlFoGSo:APA91bEyxjp9kOcamiDqOQkfRRlHNvkGfKTGw40uJHW6CCVVb9fCNB49fYVfATxOjVs9RW41O4G1Sme3kAzbmdToV7Lit-K5oOWfGWbsoSrmRCQ2SusqLsc";
const mydorm_news_topic = "MyDorm-Informasi";

void confirmDialog(BuildContext context, String title, String subtitle,
    VoidCallback? onConfirm) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          title: Text(
            title,
            style: kSemiBoldTextStyle.copyWith(fontSize: 21),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 120,
                      child: GradientButton(
                          ontap: onConfirm ?? () {}, title: "Iya")),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      width: 120,
                      child: OutlineButton(
                          ontap: () {
                            Navigator.of(context).pop();
                          },
                          title: "Batal"))
                ],
              )
            ],
          ),
        );
      });
}
