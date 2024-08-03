import 'package:beco_productivity/screens/homescreen.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/global_variable_controller.dart';

void main() async {
  Get.put(GlobalController());
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MainApp());
}

// ignore: must_be_immutable
class MainApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: ThemeColors.white,
          appBarTheme: const AppBarTheme(
              surfaceTintColor: ThemeColors.white,
              centerTitle: false,
              elevation: 0,
              backgroundColor: ThemeColors.white,
              foregroundColor: ThemeColors.white,
              // titleSpacing: 32,
              titleTextStyle: ThemeTextStyles.title32),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0,
            backgroundColor: ThemeColors.accentMain,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Homescreen());
  }
}
