import 'package:beco_productivity/models/timeline_object_model.dart';

class Project {
  final String taskTitle;
  bool isRunning = false;
  List<TimelineObject> timelineObjects = [];

  Project({
    required this.taskTitle,
    this.isRunning = false,
    required this.timelineObjects, // Default to empty list
  });

  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'isRunning': isRunning,
      'timelineObjects': timelineObjects.map((obj) => obj.toJSON()).toList(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      taskTitle: json['taskTitle'] as String,
      isRunning: json['isRunning'] as bool,
      timelineObjects: json['timelineObjects'] != null
          ? (json['timelineObjects'] as List)
              .map((obj) => TimelineObject.fromJSON(obj))
              .toList()
          : [], // Or provide a default list
    );
  }
}
