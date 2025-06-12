import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';

class AppsIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget pushWidget;
  const AppsIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.pushWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => pushWidget));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
          child: Container(
            constraints: const BoxConstraints(minHeight: 60, minWidth: 80),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: kMain,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: kSemiBoldTextStyle.copyWith(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
