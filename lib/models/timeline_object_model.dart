import 'package:intl/intl.dart';

class TimelineObject {
  final String title;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  TimelineObject(
    this.title,
    this.date,
    this.startTime,
    this.endTime,
  );

  String get elapsedTime {
    Duration difference = endTime.difference(startTime);
    return '${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  // Convert a TimelineObject instance to a JSON object
  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'date': DateFormat('dd-MM-yyyy').format(date),
      'startTime': DateFormat('HH:mm:ss').format(startTime),
      'endTime': DateFormat('HH:mm:ss').format(endTime),
    };
  }

  // Create a TimelineObject instance from a JSON object
  factory TimelineObject.fromJSON(Map<String, dynamic> json) {
    DateTime date = DateFormat('dd-MM-yyyy').parse(json['date']);
    DateTime startTime = DateFormat('HH:mm:ss').parse(json['startTime']);
    DateTime endTime = DateFormat('HH:mm:ss').parse(json['endTime']);

    return TimelineObject(
      json['title'],
      date,
      DateTime(date.year, date.month, date.day, startTime.hour,
          startTime.minute, startTime.second),
      DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute,
          endTime.second),
    );
  }
}
