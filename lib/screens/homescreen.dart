import 'package:beco_productivity/controllers/global_variable_controller.dart';
import 'package:beco_productivity/controllers/stopwatch_controller.dart';
import 'package:beco_productivity/controllers/timeline_controller.dart';
import 'package:beco_productivity/screens/edit_timeline_object.dart';

import 'package:beco_productivity/screens/project_screen.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:beco_productivity/widgets/tasks_card_widgets.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/onTap_start_or_stop_controller.dart';
import '../widgets/ongoing_task_card.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FABPill(
            onTapFAB: () {
              Get.to(
                () => const ProjectScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 400),
              );
            },
            labelFAB: 'Projects',
            textStyleFAB: ThemeTextStyles.white18),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(
              top: 32,
            ),
            child: Text(
              'beco',
            ),
          ),
        ),
        body: const HomescreenBody());
  }
}

class HomescreenBody extends StatefulWidget {
  const HomescreenBody({super.key});

  @override
  State<HomescreenBody> createState() => _HomescreenBodyState();
}

class _HomescreenBodyState extends State<HomescreenBody> {
  final GlobalStopwatch _globalStopwatch = GlobalStopwatch();

  @override
  void initState() {
    super.initState();
    _globalStopwatch.addListener(_updateState);
  }

  @override
  void dispose() {
    _globalStopwatch.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String globalStopwatchResult =
        _globalStopwatch.elapsed.toString().split('.').first.padLeft(8, "0");

    final GlobalController globalController = Get.find<GlobalController>();
    final OnTapStartStopController onTapStartStopController =
        Get.put(OnTapStartStopController());

    Get.put(TimelineController());

    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ElevatedButton(
          //     onPressed: () => timelineController.clearTimeline(),
          //     child: Text('x')),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: globalController.isAnyProjectRunning.isTrue
                  ? OngoingTaskCardHeader(
                      key: ValueKey<bool>(
                          globalController.isAnyProjectRunning.value),
                      title: globalController.nameOfProjectRunning.value,
                      globalStopwatch: globalStopwatchResult,
                      buttonLabel: 'STOP',
                      onTapButton: () {
                        onTapStartStopController.stopProject(
                          globalController.projectRunningIndex.value,
                          _globalStopwatch,
                        );
                      },
                    )
                  : const SizedBox(
                      key: ValueKey<bool>(false),
                      height: 32,
                    ),
            ),
          ),
          const Expanded(child: SingleChildScrollView(child: Timeline())),
          Obx(() {
            return globalController.isAnyProjectRunning.isTrue
                ? SizedBox(
                    height: screenHeight * 0.05,
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find<GlobalController>();
    final TimelineController timelineController = Get.put(TimelineController());

    final screenHeight = MediaQuery.of(context).size.height;

    // Get the height of the status bar
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Get the height of the bottom system navigation (if present)
    final bottomNavHeight = MediaQuery.of(context).padding.bottom;

    // Calculate the maximum safe area height
    final safeAreaHeight = screenHeight - statusBarHeight - bottomNavHeight;
    final cardHeight = MediaQuery.of(context).size.width / 2.5;

    return SizedBox(
      height: globalController.isAnyProjectRunning.isTrue
          ? safeAreaHeight - cardHeight
          : safeAreaHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () {
              final groupedByDateTimeline =
                  timelineController.groupTimelineByDate(
                      timelineController.displayedTimelineList);
              final datesInTimeline = groupedByDateTimeline.keys.toList();

              String todaysDate =
                  DateFormat('dd-MM-yyyy').format(DateTime.now());

              if (timelineController.displayedTimelineList.isEmpty &&
                  !timelineController.isLoading.value) {
                return const Column(
                  children: [
                    SizedBox(
                      key: ValueKey<bool>(false),
                      height: 32,
                    ),
                    SizedBox(
                      height: 100,
                      child: Text(
                        'No Tasks Yet',
                      ),
                    ),
                  ],
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: datesInTimeline.length + 1,
                  itemBuilder: ((context, index) {
                    if (index < datesInTimeline.length) {
                      final date = datesInTimeline[index];
                      final eventsOnDate =
                          groupedByDateTimeline[date]!.toList();

                      String label = displayTodayLogic(date, todaysDate);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
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
                ),
              );
            },
          ),
          SizedBox(
            height: screenHeight / 6,
          )
        ],
      ),
    );
  }
}

String displayTodayLogic(date, todaysDate) {
  String label = '';
  if (date == todaysDate) {
    label = 'Today ';
  } else {
    // Example input string
    String inputFormat = "dd-MM-yyyy"; // Input format

    // Parse the string into a DateTime object
    DateFormat inputDateFormatter = DateFormat(inputFormat);
    DateTime dateTime = inputDateFormatter.parse(date);

    // Format the DateTime object into a different format if needed
    String outputFormat = "MMM dd, EEEE'";
    DateFormat outputDateFormatter = DateFormat(outputFormat);
    String formattedDate = outputDateFormatter.format(dateTime);
    label = formattedDate;
  }

  return label;
}
