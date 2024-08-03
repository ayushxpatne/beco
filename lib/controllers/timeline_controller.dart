//TIMELINE CONTROLLER
//MAKE A STORAGE BOX FOR IT IN GET STORAGE, MAKE A KEY
//MAKE READ AND SAVE
//MAKE ADD TIMELINE FEATURE, IF DURATION = 00:00:00 REMOVE IT
//EDIT THE TIMELINE OBJECT - DURATION AND DAY FOR IT//

import 'dart:convert';

import 'package:beco_productivity/database/timelineList.dart';
import 'package:beco_productivity/models/timeline_object_model.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class TimelineController extends GetxController {
  final storageTimeline = GetStorage();
  final String timelineKey = 'timeline';

  final RxBool isLoading = false.obs;

  final RxList<TimelineObject> displayedTimelineList = <TimelineObject>[].obs;

  final int pageSize = 10;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();

    readFromStorage();
    loadMoreItems();
    ever(timelineList, (_) => update());
    ever(
        displayedTimelineList,
        (_) =>
            update()); // This will trigger an update whenever timelineList changes
  }

  Future<void> loadMoreItems2({bool forceReload = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    // await Future.delayed(const Duration(milliseconds: 100));

    if (forceReload) {
      currentPage = 0;
      displayedTimelineList.clear();
    }

    int start = currentPage * pageSize;
    int end = start + pageSize;
    if (end > timelineList.length) end = timelineList.length;

    if (start < timelineList.length) {
      displayedTimelineList.addAll(timelineList.sublist(start, end));
      currentPage++;
    }

    isLoading.value = false;
    update();
  }

  Future<void> loadMoreItems({bool forceReload = false}) async {
    isLoading.value = true;
    await Future.delayed(
        const Duration(milliseconds: 500)); // Remove for better performance

    // Check if there are tasks saved before reloading
    if (timelineList.isNotEmpty || forceReload) {
      if (forceReload) {
        currentPage = 0;
        displayedTimelineList.clear();
      }

      int start = currentPage * pageSize;
      int end = start + pageSize;
      if (end > timelineList.length) end = timelineList.length;

      if (start < timelineList.length) {
        displayedTimelineList.addAll(timelineList.sublist(start, end));
        currentPage++;
      }
    } else {
      // Handle scenario where there are no tasks saved (fresh launch)
      // You can display a message or show an empty view here
      print('ELSEPArt');
    }

    // if (displayedTimelineList.length == timelineList.length)

    isLoading.value = false;
    update();
  }

  void saveTimelineToStorage() {
    String timelineToJSON =
        jsonEncode(timelineList.map((element) => element.toJSON()).toList());

    storageTimeline.write(timelineKey, timelineToJSON);

    update();
  }

  void clearTimeline() {
    storageTimeline.erase();
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

  void addToTimeline(TimelineObject newObject) {
    timelineList.insert(0, newObject); // Add to the beginning of the list
    timelineList.refresh();

    // Update displayedTimelineList if it's not empty
    if (displayedTimelineList.isNotEmpty) {
      displayedTimelineList.insert(0, newObject);
      displayedTimelineList.refresh();
    } else {
      // If displayedTimelineList is empty, initialize it with the first page
      loadMoreItems(forceReload: true);
    }

    saveTimelineToStorage();
    update();
  }

  void deleteFromTimeline(TimelineObject objectToDelete) {
  // Remove from the main timelineList
  timelineList.remove(objectToDelete);
  timelineList.refresh();

  // Remove from displayedTimelineList if it exists there
  int displayIndex = displayedTimelineList.indexWhere((element) => 
    element.title == objectToDelete.title &&
    element.date == objectToDelete.date &&
    element.startTime == objectToDelete.startTime &&
    element.endTime == objectToDelete.endTime
  );
  
  if (displayIndex != -1) {
    displayedTimelineList.removeAt(displayIndex);
    displayedTimelineList.refresh();
  }

  // Save the updated list to storage
  saveTimelineToStorage();

  // Notify listeners about the change
  update();
}

  void editTimelineObject({
    required int index,
    required String newTitle,
    required DateTime newDate,
    required DateTime newStartTime,
    required DateTime newEndTime,
  }) {
    if (index < 0 || index >= timelineList.length) {
      print('Invalid index');
      return;
    }

    TimelineObject newObject = TimelineObject(
      newTitle,
      newDate,
      newStartTime,
      newEndTime,
    );

    // Update the object in the main list
    timelineList[index] = newObject;

    // Sort the main list
    timelineList.sort((a, b) {
      int dateComparison = b.date.compareTo(a.date);
      if (dateComparison != 0) return dateComparison;
      return b.startTime.compareTo(a.startTime);
    });

    // Clear and reload the displayed list
    // displayedTimelineList.clear();
    loadMoreItems(forceReload: true);

    // Save the updated list to storage
    saveTimelineToStorage();

    // Refresh both lists
    timelineList.refresh();
    displayedTimelineList.refresh();

    // Notify listeners about the change
    update();
  }

  Map<String, List<TimelineObject>> groupTimelineByDate(
    RxList<TimelineObject> timelineList,
  ) {
    Map<String, List<TimelineObject>> groupedTimelineByDate = {};

    timelineList.reversed.toList().sort(
          (a, b) => a.date.compareTo(b.date),
        );

    for (TimelineObject timelineObject in timelineList) {
      // timelineList.refresh();
      final date = DateFormat('dd-MM-yyyy').format(timelineObject.date);

      if (!groupedTimelineByDate.containsKey(date)) {
        groupedTimelineByDate[date] = [];
      }

      groupedTimelineByDate[date]?.add(timelineObject);
    }
    update();

    return groupedTimelineByDate;
  }

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> initialDate = DateTime.now().obs;

  Future<void> selectDate(
      BuildContext context, TimelineObject currentTask) async {
    initialDate.value = selectedDate.value;

    DateTime picked = selectedDate.value;

    if (currentTask.date.day != DateTime.now().day) {
      selectedDate.value = currentTask.date;
    }

    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              color: ThemeColors.white,
              height: 216,
              width: MediaQuery.sizeOf(context).width,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate.value,
                minimumDate: DateTime(2000),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime dateTime) {
                  picked = dateTime;
                },
              ));
        });

    selectedDate.value = picked;

    // return selectedDate.value;
  }

  final Rx<DateTime> selectedStartTime = DateTime.now().obs;

  Future<void> selectStartTime(
      BuildContext context, TimelineObject currentTask) async {
    // if (DateFormat('hh:mm:ss').format(currentTask.startTime) !=
    //     DateFormat('hh:mm:ss').format(DateTime.now())) {
    //   selectedStartTime.value = currentTask.startTime;
    // }

    String taskDate = DateFormat('dd-MM-yyyy').format(currentTask.date);
    String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          // selectedStartTime.value = currentTask.startTime;
          return Container(
              color: ThemeColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Start Time:',
                      style: ThemeTextStyles.white18.copyWith(
                        color: ThemeColors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 216,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime:
                          selectedStartTime.value == currentTask.startTime
                              ? currentTask.startTime
                              : selectedStartTime.value,
                      minimumDate: DateTime(2000),
                      maximumDate:
                          taskDate == dateNow ? DateTime.now() : DateTime(3101),
                      onDateTimeChanged: (DateTime dateTime) {
                        //The returned [Duration] will be negative if [other] occurs after [this].

                        selectedStartTime.value = dateTime;
                      },
                    ),
                  ),
                ],
              ));
        });
    // return selectedDate.value;
  }

  final Rx<DateTime> selectedEndTime = DateTime.now().obs;

  Future<void> selectEndTime(
      BuildContext context, TimelineObject currentTask) async {
    // selectedEndTime.value = currentTask.endTime;

    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          String taskDate = DateFormat('dd-MM-yyyy').format(currentTask.date);
          String dateNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
          String selectedDateStringe =
              DateFormat('dd-MM-yyyy').format(selectedDate.value);

          return Container(
              color: ThemeColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select End Time:',
                      style: ThemeTextStyles.white18.copyWith(
                        color: ThemeColors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 216,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime:
                          selectedEndTime.value == currentTask.endTime
                              ? currentTask.endTime
                              : selectedEndTime.value,
                      minimumDate: DateTime(2000),
                      maximumDate: selectedDateStringe == dateNow
                          ? DateTime.now()
                          : DateTime(3101),
                      onDateTimeChanged: (DateTime dateTime) {
                        selectedEndTime.value = dateTime;
                      },
                    ),
                  ),
                ],
              ));
        });

    // return selectedDate.value;
  }
}
