// ignore: camel_case_types
import 'package:intl/intl.dart';

class TimelineObject {
  final String title;
  final String elapsedTime;
  final DateTime date;

  TimelineObject(
    this.title,
    this.elapsedTime,
    this.date,
  );

  // Convert a TimelineObject instance to a JSON object
  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'elapsedTime': elapsedTime,
      'date':
          DateFormat('dd-MM-yyyy').format(date), // DateTime to ISO 8601 string
    };
  }

  // Create a TimelineObject instance from a JSON object
  factory TimelineObject.fromJSON(Map<String, dynamic> json) {
    return TimelineObject(
      json['title'],
      json['elapsedTime'],
      DateFormat('dd-MM-yyyy')
          .parse(json['date']), // ISO 8601 string to DateTime
    );
  }
}
