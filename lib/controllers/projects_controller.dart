// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:beco_productivity/models/project_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:beco_productivity/database/projectList.dart';

class ProjectsController extends GetxController {
  final storage = GetStorage();
  final String projectListKey = 'project_list';

  @override
  void onInit() {
    super.onInit();

    if (projectListC.isNotEmpty) {
      readGetStorage();
    }
  }

  void saveToGetStorage() {
    //CONVERTING TO JSON

    String projectListJSON =
        jsonEncode(projectListC.map((e) => e.toJson()).toList());

    String ifEmptyThenWrite = jsonEncode({
      'taskTitle': 'Empty',
      'isRunning': 'false',
    });

    projectListC.isNotEmpty
        ? storage.write(projectListKey, projectListJSON)
        : storage.write(projectListKey, ifEmptyThenWrite);

    update();
  }

  void readGetStorage() {
    String? projectsString = storage.read(projectListKey);

    if (projectsString != null) {
      List<dynamic> decoded = jsonDecode(projectsString);
      projectListC.value =
          decoded.map((item) => Project.fromJson(item)).toList();
    }
  }

  void addToProjectListC(taskTitle) {
    projectListC.add(Project(taskTitle, false));
    saveToGetStorage();
  }

  void toggleIsRunning(index) {
    projectListC[index].isRunning = !projectListC[index].isRunning;
    saveToGetStorage();
  }

  Project getProjectFromIndex(index) => projectListC[index];
}


//* FOR ANY PROJECT WE NEED RENAME PROJECT, TOGGLE ON OR OFF
//* For PROJECT_LIST WE NEED ADD AND DELETE PROJECT
