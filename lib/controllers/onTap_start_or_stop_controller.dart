// ignore_for_file: file_names

import 'package:beco_productivity/controllers/global_variable_controller.dart';
import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/controllers/stopwatch_controller.dart';
import 'package:get/get.dart';

import '../models/project_model.dart';

class OnTapStartStopController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
  final ProjectsController projectsController = Get.find<ProjectsController>();

  void startProject(int index, GlobalStopwatch globalStopwatch) {
    globalController.toggle_IsAnyProjectRunningValue();

    Project getProjectFromIndex = projectsController.getProjectFromIndex(index);

    globalController.assign_NameOfProjectRunning(getProjectFromIndex.taskTitle);
    globalController.assign_IndexOfProjectRunning(index);

    projectsController.toggleIsRunning(index);
    globalStopwatch.start();
  }

  void stopProject(int index, GlobalStopwatch globalStopwatch) {
    globalController.toggle_IsAnyProjectRunningValue();
    globalStopwatch.stop();
    Project getProjectFromIndex = projectsController.getProjectFromIndex(index);

    //timeline code

    globalController.clearNameOfProjectRunning();
    globalController.clearProjectRunningIndex();

    projectsController.toggleIsRunning(index);
    globalStopwatch.reset();
  }
}
