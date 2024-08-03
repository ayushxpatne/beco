// ignore_for_file: avoid_print

import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/controllers/stopwatch_controller.dart';
import 'package:beco_productivity/controllers/timeline_controller.dart';
import 'package:get/get.dart';

import '../models/project_model.dart';
import '../models/timeline_object_model.dart';
import 'global_variable_controller.dart';

class OnTapStartStopController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>();
  final ProjectsController projectsController = Get.put(ProjectsController());
  final TimelineController timelineController = Get.put(TimelineController());

  DateTime? projectStartTime;

  void startProject(int index, GlobalStopwatch globalStopwatch) {
    globalController.toggle_IsAnyProjectRunningValue();

    Project getProjectFromIndex = projectsController.getProjectFromIndex(index);

    globalController.assign_NameOfProjectRunning(getProjectFromIndex.taskTitle);
    globalController.assign_IndexOfProjectRunning(index);

    projectsController.toggleIsRunning(index);
    globalStopwatch.start();

    // Record the start time
    projectStartTime = DateTime.now();
    update();
  }

  void stopProject(int index, GlobalStopwatch globalStopwatch) {
    globalController.toggle_IsAnyProjectRunningValue();
    globalStopwatch.stop();

    DateTime projectEndTime = DateTime.now();

    Project getProjectFromIndex = projectsController.getProjectFromIndex(index);

    // Ensure projectStartTime is not null
    if (projectStartTime != null) {
      // Create TimelineObject with start and end times
      TimelineObject timelineObject = TimelineObject(
        getProjectFromIndex.taskTitle,
        projectStartTime!.toLocal(),
        projectStartTime!,
        projectEndTime,
      );

      // Add to timeline
      timelineController.addToTimeline(timelineObject);

      // Add to project's timeline objects
      getProjectFromIndex.timelineObjects.add(timelineObject);
      
    } else {
      print("Error: Project start time was not recorded.");
    }

    globalController.clearNameOfProjectRunning();
    globalController.clearProjectRunningIndex();

    projectsController.toggleIsRunning(index);
    globalStopwatch.reset();

    // Clear the start time
    projectStartTime = null;
    timelineController.update();
    update();
  }
}
