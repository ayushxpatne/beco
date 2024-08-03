// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:beco_productivity/database/projectList.dart';
import 'package:beco_productivity/models/project_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProjectsController extends GetxController {
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

    storage.write(projectListKey, projectListJSON);

    update();
  }

  void readGetStorage() {
    String? projectsString = storage.read(projectListKey);

    if (projectsString != null) {
      List<dynamic> decoded = jsonDecode(projectsString);
      projectListC.value =
          decoded.map((item) => Project.fromJson(item)).toList();
    }

    update();
  }

  void addToProjectListC(taskTitle) {
    projectListC.add(Project(taskTitle: taskTitle, timelineObjects: []));
    saveToGetStorage();
  }

  void removeFromProjectListC(Project thisTask) {
    projectListC.remove(thisTask);
    saveToGetStorage();
  }

  void toggleIsRunning(index) {
    projectListC[index].isRunning = !projectListC[index].isRunning;
    saveToGetStorage();
  }

  bool projectAlreadyExists(String? newTaskTitle) {
    late bool projectAlreadyExists = false;

    for (Project project in projectListC) {
      if (project.taskTitle == newTaskTitle) {
        projectAlreadyExists = true;
      } else {
        projectAlreadyExists = false;
      }
    }
    return projectAlreadyExists;
  }

  Project getProjectFromIndex(index) => projectListC[index];
}


//* FOR ANY PROJECT WE NEED RENAME PROJECT, TOGGLE ON OR OFF
//* For PROJECT_LIST WE NEED ADD AND DELETE PROJECT
