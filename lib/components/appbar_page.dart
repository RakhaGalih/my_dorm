// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';

class AppBarPage extends StatelessWidget {
  final String title;
  final bool canBack;
  final VoidCallback? onAdd;
  const AppBarPage({
    super.key,
    required this.title,
    this.canBack = true,
    this.onAdd
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      width: double.infinity,
      decoration: const BoxDecoration(gradient: kGradientMain),
      child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                SizedBox(
                    width: 50,
                    child: (canBack)
                        ? IconButton(
                            onPressed: () {
                              Navigator.pop(context, "oke");
                            },
                            icon: const Icon(
                              FluentIcons.arrow_left_24_filled,
                              color: kWhite,
                            ))
                        : const SizedBox()),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          kBoldTextStyle.copyWith(fontSize: 16, color: kWhite),
                    ),
                  ),
                ),
                SizedBox(
                    width: 50,
                    child: (onAdd != null)
                        ? IconButton(
                            onPressed: onAdd,
                            icon: const Icon(
                              FluentIcons.add_circle_24_regular,
                              color: kWhite,
                            ))
                        : const SizedBox()),
              ],
            ),
          )),
    );
  }
}
