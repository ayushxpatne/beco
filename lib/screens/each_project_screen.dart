import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EachProjectScreen extends StatelessWidget {
  const EachProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 250,
        //
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.accentMain,
        title: Padding(
          padding: const EdgeInsets.only(
            top: 32,
          ),
          child: Text(
            'beco',
            style: ThemeTextStyles.title32.copyWith(color: ThemeColors.white),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
        color: ThemeColors.accentMain,
        child: Text(
          'Project Name',
          style: ThemeTextStyles.title42white,
        ),
      ),
    );
  }
}
