import 'package:flutter/material.dart';

class FABPill extends StatelessWidget {
  const FABPill(
      {super.key,
      required this.onTapFAB,
      required this.labelFAB,
      required this.textStyleFAB});

  final Function onTapFAB;
  final String labelFAB;
  final TextStyle textStyleFAB;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 150,
      child: FloatingActionButton.extended(
          label: Text(labelFAB, style: textStyleFAB),
          onPressed: () => onTapFAB()),
    );
  }
}
