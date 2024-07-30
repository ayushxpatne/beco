// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class ThemeColors {
  static const Color accentMain = Color.fromRGBO(55, 50, 255, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color red_stop = Color.fromARGB(255, 255, 50, 77);
  static const Color black = Colors.black;
}

class ThemeTextStyles {
  static TextStyle white18 = const TextStyle(
    fontFamily: 'NeueHaas',
    fontSize: 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
    color: ThemeColors.white,
  );
  static const TextStyle title32 = TextStyle(
    fontFamily: 'NeueHaas',
    fontSize: 32,
    letterSpacing: 0,
    fontWeight: FontWeight.w800,
    color: ThemeColors.accentMain,
  );
  static const TextStyle title24white = TextStyle(
    fontFamily: 'NeueHaas',
    fontSize: 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w800,
    color: ThemeColors.white,
  );

  static const TextStyle title42white = TextStyle(
    fontFamily: 'NeueHaas',
    fontSize: 42,
    letterSpacing: 0,
    fontWeight: FontWeight.w800,
    color: ThemeColors.white,
  );
}
