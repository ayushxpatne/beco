// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:beco_productivity/models/project_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:beco_productivity/db/projectList.dart';

class ProjectsController extends GetxController {
  final projectListC = <Project>[
    Project('taskTitle', false),
    Project('taskTitle-2', false),
  ].obs;

  final storage = GetStorage();
  final String projectListKey = 'project_list';

  @override
  void onInit() {
    super.onInit();

    readGetStorage();
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
  }

  void readGetStorage() {
    String? projectsString = storage.read(projectListKey);

    if (projectsString != null) {
      List<dynamic> decoded = jsonDecode(projectsString);
      projectListC.value =
          decoded.map((item) => Project.fromJson(item)).toList();
    } else {
      projectListC.value = [Project('Yes Tasks', false)];
    }
  }

  void toggleIsRunning(index) {
    projectListC[index].isRunning = !projectListC[index].isRunning;
  }

  Project getProjectFromIndex(index) => projectListC[index];
}


//* FOR ANY PROJECT WE NEED RENAME PROJECT, TOGGLE ON OR OFF
//* For PROJECT_LIST WE NEED ADD AND DELETE PROJECT
