import 'package:flutter/material.dart';

import 'texts.dart';


class CardHeader extends StatelessWidget {
  const CardHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 3,
        decoration: const BoxDecoration(
            color: ThemeColors.accentMain,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Text(
          title,
          style: ThemeTextStyles.title24white,
        ),
      ),
    );
  }
}