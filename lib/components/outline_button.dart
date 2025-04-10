import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';

class OutlineButton extends StatelessWidget {
  final VoidCallback ontap;
  final String title;
  const OutlineButton({
    super.key,
    required this.ontap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: 52,
        decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kRed, width: 3.0)),
        child: Text(
          title,
          style: kBoldTextStyle.copyWith(color: kRed, fontSize: 16),
        ),
      ),
    );
  }
}
