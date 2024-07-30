import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EachProjectScreen extends StatefulWidget {
  EachProjectScreen({super.key});

  @override
  State<EachProjectScreen> createState() => _EachProjectScreenState();
}

class _EachProjectScreenState extends State<EachProjectScreen> {
  final _titleEditingController = TextEditingController();
  String? projectTitle;

  final ProjectsController _projectsController = Get.put(ProjectsController());

  @override
  void dispose() {
    _titleEditingController.dispose();
    super.dispose();
  }

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
      floatingActionButton: FABPill(
          onTapFAB: () {
            _projectsController.addToProjectListC(_titleEditingController.text);
            print(_titleEditingController.text);
          },
          labelFAB: 'Add Project',
          textStyleFAB: ThemeTextStyles.white18),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
        color: ThemeColors.accentMain,
        child: TextField(
          controller: _titleEditingController,
          textAlign: TextAlign.center,
          style: ThemeTextStyles.title42white,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Project Name',
              hintStyle: ThemeTextStyles.title42white.copyWith(
                color: Colors.white38,
              )),
        ),
      ),
    );
  }
}
