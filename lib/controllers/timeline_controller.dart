//TIMELINE CONTROLLER
//MAKE A STORAGE BOX FOR IT IN GET STORAGE, MAKE A KEY
//MAKE READ AND SAVE
//MAKE ADD TIMELINE FEATURE, IF DURATION = 00:00:00 REMOVE IT
//EDIT THE TIMELINE OBJECT - DURATION AND DAY FOR IT//

import 'dart:convert';

import 'package:beco_productivity/database/timelineList.dart';
import 'package:beco_productivity/models/timeline_object_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TimelineController extends GetxController {
  final storageTimeline = GetStorage();
  final String timelineKey = 'timeline';

  @override
  void onInit() {
    super.onInit();

    readFromStorage();
  }

  void saveTimelineToStorage() {
    String timelineToJSON =
        jsonEncode(timelineList.map((element) => element.toJSON()).toList());

    storageTimeline.write(timelineKey, timelineToJSON);

    update();
  }

  void readFromStorage() {
    String? readFromStorageJSON = storageTimeline.read(timelineKey);

    if (readFromStorageJSON != null) {
      List<dynamic> decodeJSON = jsonDecode(readFromStorageJSON);
      timelineList.value =
          decodeJSON.map((e) => TimelineObject.fromJSON(e)).toList();
    }

    update();
  }

  void addToTimeline(TimelineObject timelineObject) {
    timelineList.add(timelineObject);
    saveTimelineToStorage();
  }
}
