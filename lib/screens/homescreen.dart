import 'package:beco_productivity/controllers/global_variable_controller.dart';
import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/controllers/stopwatch_controller.dart';
import 'package:beco_productivity/database/timelineList.dart';
import 'package:beco_productivity/screens/project_screen.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:beco_productivity/widgets/tasks_card_project_page.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline:',
          style: ThemeTextStyles.white18
              .copyWith(color: ThemeColors.black, fontWeight: FontWeight.w600),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: timelineList.length,
            itemBuilder: ((context, index) {
              final currentTask = timelineList[index];
              return TaskCard_Timeline(
                label: currentTask.title,
                timer: currentTask.elapsedTime,
              );
            }))
      ],
    );
  }
}
