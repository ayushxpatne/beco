// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class TaskCard_ProjectsPage extends StatelessWidget {
  TaskCard_ProjectsPage({
    super.key,
    required this.label,
    required this.startOrStopButton,
  });

  final String label;

  Widget startOrStopButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            // border: Border.all(width: 1, color: Colors.black),
            color: ThemeColors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: ThemeTextStyles.white18.copyWith(color: Colors.black),
            ),
            // OutlineTextButtonPill(
            //     label: 'START', onTapButton: () => onTapButton())
            startOrStopButton,
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class TaskCard_Timeline extends StatelessWidget {
  TaskCard_Timeline({
    super.key,
    required this.label,
    required this.timer,
  });

  final String label;
  final String timer;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          // border: Border.all(width: 1, color: Colors.black),
          color: ThemeColors.white,
          border: Border(bottom: BorderSide(width: 0.2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: ThemeTextStyles.white18
                .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          // OutlineTextButtonPill(
          //     label: 'START', onTapButton: () => onTapButton())
          Text(
            timer,
            style: ThemeTextStyles.white18
                .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
