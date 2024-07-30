import 'package:beco_productivity/controllers/global_variable_controller.dart';
import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/controllers/stopwatch_controller.dart';
import 'package:beco_productivity/database/timelineList.dart';
import 'package:beco_productivity/models/timeline_object_model.dart';
import 'package:beco_productivity/screens/project_screen.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:beco_productivity/widgets/tasks_card_project_page.dart';
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
                () => ProjectScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 400),
              );
            },
            labelFAB: 'Projects',
            textStyleFAB: ThemeTextStyles.white18),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          globalController.isAnyProjectRunning.isTrue
              ? OngoingTaskCardHeader(
                  title: globalController.nameOfProjectRunning.value,
                  globalStopwatch: globalStopwatchResult,
                  buttonLabel: 'STOP',
                  onTapButton: () {
                    onTapStartStopController.stopProject(
                        globalController.projectRunningIndex.value,
                        _globalStopwatch,
                        globalStopwatchResult);
                  },
                )
              : const SizedBox(
                  height: 32,
                ),
          Timeline(),
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
        children: [
          Text(
            'Timeline:',
            style: ThemeTextStyles.white18.copyWith(
                color: ThemeColors.black, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Obx(() {
              final groupedByDateTimeline = groupTimelineByDate(timelineList);
              final datesInTimeline = groupedByDateTimeline.keys.toList();

              return ListView.builder(
                itemCount: datesInTimeline.length,
                itemBuilder: ((context, index) {
                  final date = datesInTimeline[index];
                  final eventsOnDate = groupedByDateTimeline[date];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date),
                      ...eventsOnDate!.reversed.map((currentTask) {
                        return TaskCard_Timeline(
                          label: currentTask.title,
                          timer: currentTask.elapsedTime,
                        );
                      }).toList(),
                    ],
                  );
                }),
              );
            }),
          ),
          SizedBox(
            height: screenHeight / 6,
          )
        ],
      ),
    );
  }
}

Map<String, List<TimelineObject>> groupTimelineByDate(
  RxList<TimelineObject> timelineList,
) {
  Map<String, List<TimelineObject>> groupedTimelineByDate = {};

  timelineList.sort(
    (a, b) => a.date.compareTo(b.date),
  );

  for (TimelineObject timelineObject in timelineList) {
    timelineList.refresh();
    final date = DateFormat('dd-MM-yyyy').format(timelineObject.date);

    if (!groupedTimelineByDate.containsKey(date)) {
      groupedTimelineByDate[date] = [];
    }

    groupedTimelineByDate[date]?.add(timelineObject);
  }

  return groupedTimelineByDate;
}
