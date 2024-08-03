import 'package:beco_productivity/controllers/timeline_controller.dart';
import 'package:beco_productivity/models/timeline_object_model.dart';
import 'package:beco_productivity/screens/homescreen.dart';
import 'package:beco_productivity/widgets/button_pill.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/texts.dart';

class EditTimelineObject extends StatefulWidget {
  EditTimelineObject(
      {super.key, required this.currentTask, required this.index});

  final TimelineObject currentTask;
  final int index;

  @override
  State<EditTimelineObject> createState() => _EditTimelineObjectState();
}

class _EditTimelineObjectState extends State<EditTimelineObject> {
  late TimelineController _timelineController;

  @override
  void initState() {
    super.initState();
    _timelineController = Get.find<TimelineController>();

    // Initialize values here
    _timelineController.selectedDate.value = widget.currentTask.date;
    _timelineController.selectedStartTime.value = widget.currentTask.startTime;
    _timelineController.selectedEndTime.value = widget.currentTask.endTime;
  }

  @override
  Widget build(BuildContext context) {
    // final currentTask = currentTask;
    return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 250,
          automaticallyImplyLeading: false,
          backgroundColor: ThemeColors.accentMain,
          centerTitle: false,

          title: Padding(
            padding: const EdgeInsets.only(
              top: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new)),
                Expanded(
                  child: Center(
                    child: Text(
                      'Edit',
                      style: ThemeTextStyles.white18.copyWith(
                          color: ThemeColors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        titlePadding:
                            const EdgeInsets.only(top: 32, left: 32, right: 32),
                        middleTextStyle: const TextStyle(fontSize: 0),
                        title: 'Do you want to delete this entry?',
                        titleStyle: ThemeTextStyles.white18.copyWith(
                            color: ThemeColors.black,
                            fontWeight: FontWeight.w600),
                        contentPadding: const EdgeInsets.only(
                            bottom: 16, left: 32, right: 32),
                        confirm: TextButtonPill(
                          backgroundColor: ThemeColors.red_stop,
                          foregroundColor: ThemeColors.white,
                          label: 'Delete',
                          onTapButton: () {
                            _timelineController
                                .deleteFromTimeline(widget.currentTask);

                            Get.back();
                            Get.back();
                            // return Get.off(
                            //   () => const Homescreen(),
                            //   transition: Transition.noTransition,
                            // );
                          },
                        ),
                        backgroundColor: ThemeColors.white,
                        cancel: TextButtonPill(
                            onTapButton: () => Get.back(), label: 'Cancel'),
                      );
                    },
                    child: const Icon(Icons.delete)),
              ],
            ),
          ),
        ),
        floatingActionButton: FABPill(
            onTapFAB: () {
              if (_timelineController.selectedStartTime.value
                  .difference(_timelineController.selectedEndTime.value)
                  .isNegative) {
                _timelineController.editTimelineObject(
                  index: widget.index,
                  newTitle: widget.currentTask.title,
                  newDate: _timelineController.selectedDate.value,
                  newStartTime: _timelineController.selectedStartTime.value,
                  newEndTime: _timelineController.selectedEndTime.value,
                );
                Get.back();
              } else {
                Get.snackbar('Invalid Start Time',
                    'Start Time should be not more than End Time',
                    backgroundColor: ThemeColors.white);
              }
            },
            labelFAB: 'Save Changes',
            textStyleFAB: ThemeTextStyles.white18),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: EditTimelineBody(
          currentTask: widget.currentTask,
          timelineController: _timelineController,
        ));
  }
}

class EditTimelineBody extends StatelessWidget {
  const EditTimelineBody({
    super.key,
    required this.currentTask,
    required this.timelineController,
  });

  final TimelineObject currentTask;
  final TimelineController timelineController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          color: ThemeColors.accentMain,
          child: Text(currentTask.title, style: ThemeTextStyles.title42white),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EditDate(
                  currentTask: currentTask,
                  timelineController: timelineController,
                ),
                EditStartTime(
                    currentTask: currentTask,
                    timelineController: timelineController),
                EditEndTime(
                    currentTask: currentTask,
                    timelineController: timelineController)
              ],
            ),
          ),
        )
      ],
    );
  }
}

class EditDate extends StatefulWidget {
  const EditDate({
    super.key,
    required this.currentTask,
    required this.timelineController,
  });

  final TimelineObject currentTask;
  final TimelineController timelineController;

  @override
  State<EditDate> createState() => _EditDateState();
}

class _EditDateState extends State<EditDate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          widget.timelineController.selectDate(context, widget.currentTask),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            // border: Border.all(width: 1, color: Colors.black),
            color: ThemeColors.white,
            border: Border(bottom: BorderSide(width: 0.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ',
              style: ThemeTextStyles.white18.copyWith(
                  color: ThemeColors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Obx(
                  () => Text(
                    DateFormat('dd-MM-yyyy')
                        .format(widget.timelineController.selectedDate.value)
                        .toString(),
                    style: ThemeTextStyles.white18.copyWith(
                        color: ThemeColors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox.square(
                  dimension: 18,
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditStartTime extends StatefulWidget {
  const EditStartTime(
      {super.key, required this.currentTask, required this.timelineController});

  final TimelineObject currentTask;
  final TimelineController timelineController;

  @override
  State<EditStartTime> createState() => _EditStartTimeState();
}

class _EditStartTimeState extends State<EditStartTime> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.timelineController
          .selectStartTime(context, widget.currentTask),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            // border: Border.all(width: 1, color: Colors.black),
            color: ThemeColors.white,
            border: Border(bottom: BorderSide(width: 0.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Start Time: ',
              style: ThemeTextStyles.white18.copyWith(
                  color: ThemeColors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Obx(
                  () => Text(
                    DateFormat('hh:mm a')
                        .format(
                            widget.timelineController.selectedStartTime.value)
                        .toString(),
                    style: ThemeTextStyles.white18.copyWith(
                        color: ThemeColors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox.square(
                  dimension: 18,
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditEndTime extends StatefulWidget {
  const EditEndTime({
    super.key,
    required this.currentTask,
    required this.timelineController,
  });

  final TimelineObject currentTask;
  final TimelineController timelineController;

  @override
  State<EditEndTime> createState() => _EditEndTimeState();
}

class _EditEndTimeState extends State<EditEndTime> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          widget.timelineController.selectEndTime(context, widget.currentTask),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            // border: Border.all(width: 1, color: Colors.black),
            color: ThemeColors.white,
            border: Border(bottom: BorderSide(width: 0.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'End Time: ',
              style: ThemeTextStyles.white18.copyWith(
                  color: ThemeColors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Obx(
                  () => Text(
                    DateFormat('hh:mm a')
                        .format(widget.timelineController.selectedEndTime.value)
                        .toString(),
                    style: ThemeTextStyles.white18.copyWith(
                        color: ThemeColors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox.square(
                  dimension: 18,
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
