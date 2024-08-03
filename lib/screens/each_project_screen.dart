import 'package:beco_productivity/controllers/timeline_controller.dart';

import 'package:beco_productivity/models/timeline_object_model.dart';
import 'package:beco_productivity/widgets/tasks_card_widgets.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/project_model.dart';
import 'edit_timeline_object.dart';
import 'homescreen.dart';

class EachProjectScreen extends StatefulWidget {
  final Project project;
  const EachProjectScreen({super.key, required this.project});

  @override
  State<EachProjectScreen> createState() => _EachProjectScreenState();
}

class _EachProjectScreenState extends State<EachProjectScreen> {
  final _titleEditingController = TextEditingController();

  late Project project;

  @override
  void initState() {
    super.initState();
    project = widget.project; // Access widget here
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 250,
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.accentMain,

        title: Padding(
          padding: const EdgeInsets.only(
            top: 32,
          ),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_ios_new)),
              
            ],
            
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            color: ThemeColors.accentMain,
            child: Text(project.taskTitle, style: ThemeTextStyles.title42white),
          ),
          Expanded(child: EachProjectTimelineObjects(project: project)),
          SizedBox(
            height: screenHeight / 20,
          )
        ],
      ),
    );
  }
}

class EachProjectTimelineObjects extends StatelessWidget {
  EachProjectTimelineObjects({super.key, required this.project});

  final Project project;
  final TimelineController timelineController = Get.put(TimelineController());

  @override
  Widget build(BuildContext context) => Obx(() {
        final groupedByDateTimeline = timelineController
            .groupTimelineByDate(timelineController.displayedTimelineList);
        final datesInTimeline = groupedByDateTimeline.keys.toList();

        String todaysDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

        if (timelineController.displayedTimelineList.isEmpty &&
            !timelineController.isLoading.value) {
          return Container(
            alignment: Alignment.topCenter,
            child: const Text(
              'No Tasks Yet',
            ),
          );
        }

        return ListView.builder(
          itemCount: datesInTimeline.length + 1,
          itemBuilder: ((context, index) {
            if (index < datesInTimeline.length) {
              final date = datesInTimeline[index];
              final eventsOnDate = groupedByDateTimeline[date]!.toList();

              String label = displayTodayLogic(date, todaysDate);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        label,
                        style: ThemeTextStyles.white18.copyWith(
                            color: ThemeColors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ...eventsOnDate!.map((currentTask) {
                      return GestureDetector(
                        onTap: () => {
                          Get.to(() => EditTimelineObject(
                                currentTask: currentTask,
                                index: eventsOnDate.indexOf(currentTask),
                              ))
                        },
                        child: TaskCard_Timeline(
                          label: currentTask.title,
                          timer: currentTask.elapsedTime,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            } else {
              // timelineController.loadMoreItems(forceReload: true);
              if (timelineController.isLoading.isFalse) {
                return const SizedBox.shrink();
              }
              // Loading indicator at the end of the list
              if (timelineController.isLoading.isTrue) {
                // if (timelineController.displayedTimelineList.isEmpty) {
                //   return const Center(
                //     child: Text(
                //       'No Tasks Yet Inside',
                //     ),
                //   );
                // }
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(32),
                  child: SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      color: ThemeColors.accentMain,
                      strokeWidth: 2,
                    ),
                  ),
                ));
              } else {
                timelineController.loadMoreItems();
                return const SizedBox.shrink();
              }
            }
          }),
        );
      });
}

// floatingActionButton: FABPill(
      //     onTapFAB: () {
      //       if (_projectsController
      //           .projectAlreadyExists(_titleEditingController.text)) {
      //         Get.snackbar('Project Already Exists',
      //             '${_titleEditingController.text} was already added to Projects',
      //             backgroundColor: ThemeColors.white);
      //       } else {
      //         _projectsController
      //             .addToProjectListC(_titleEditingController.text);
      //         Get.snackbar('Project Created',
      //             '${_titleEditingController.text} was added to Projects',
      //             backgroundColor: ThemeColors.white);
      //       }
      //     },
      //     labelFAB: 'Add Project',
      //     textStyleFAB: ThemeTextStyles.white18),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


                  // child: TextField(
            //   controller: _titleEditingController,
            //   textAlign: TextAlign.center,
            //   style: ThemeTextStyles.title42white,
            //   decoration: InputDecoration(
            //       border: InputBorder.none,
            //       hintText: 'Project Name',
            //       hintStyle: ThemeTextStyles.title42white.copyWith(
            //         color: Colors.white38,
            //       )),
            // ),