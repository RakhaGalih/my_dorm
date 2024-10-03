// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const ShadowContainer({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: kWhite,
            boxShadow: [basicDropShadow],
            borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
