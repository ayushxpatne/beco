import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
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
          child: Row(
            children: [
              GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_ios_new)),
              // Text(
              //   'beco',
              //   style:
              //       ThemeTextStyles.title32.copyWith(color: ThemeColors.white),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FABPill(
          backgroundColor: ThemeColors.white,
          onTapFAB: () {
            if (_projectsController
                .projectAlreadyExists(_titleEditingController.text)) {
              Get.snackbar('Project Already Exists',
                  '${_titleEditingController.text} was already added to Projects',
                  backgroundColor: ThemeColors.white);
            } else if (_titleEditingController.text.isEmpty) {
              Get.snackbar('Enter Project', 'Enter A Valid Project Name',
                  backgroundColor: ThemeColors.white);
            } else {
              _projectsController
                  .addToProjectListC(_titleEditingController.text);

              Get.back();
            }
          },
          labelFAB: 'Add Project',
          textStyleFAB:
              ThemeTextStyles.white18.copyWith(color: ThemeColors.accentMain)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
