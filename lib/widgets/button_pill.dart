// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';

class TextButtonPill extends StatelessWidget {
  const TextButtonPill({
    super.key,
    required this.label,
    required this.onTapButton,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final Function onTapButton;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        backgroundColor: backgroundColor ?? ThemeColors.white,
        foregroundColor: foregroundColor ?? ThemeColors.accentMain,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
      child: Text(label),
      onPressed: () => onTapButton(),
    );
  }
}

class StartStopButtonPill extends StatelessWidget {
  StartStopButtonPill(
      {super.key,
      required this.label,
      required this.onTapButton,
      required this.buttonAccentColor});

  final String label;
  final Function onTapButton;

  final Color buttonAccentColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: buttonAccentColor,
        elevation: 0,
        shape: StadiumBorder(
          side: BorderSide(
            width: 2,
            color: buttonAccentColor,
          ),
        ),
      ),
      child: Text(label),
      onPressed: () => onTapButton(),
    );
  }
}
