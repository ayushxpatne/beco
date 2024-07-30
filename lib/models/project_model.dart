class Project {
  final String taskTitle;
  bool isRunning = false;
  

  Project(
    this.taskTitle,
    this.isRunning,
  );

  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'isRunning': isRunning,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      json['taskTitle'] as String,
      json['isRunning'] as bool,
    );
  }
}
