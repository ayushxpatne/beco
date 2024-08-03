import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';

class FABPill extends StatelessWidget {
  const FABPill({
    super.key,
    required this.onTapFAB,
    required this.labelFAB,
    required this.textStyleFAB,
    this.backgroundColor,
  });

  final Function onTapFAB;
  final String labelFAB;
  final TextStyle textStyleFAB;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 150,
      child: FloatingActionButton.extended(
          backgroundColor: backgroundColor ?? ThemeColors.accentMain,
          label: Text(labelFAB, style: textStyleFAB),
          onPressed: () => onTapFAB()),
    );
  }
}
