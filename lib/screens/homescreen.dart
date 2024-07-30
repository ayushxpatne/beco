import 'package:beco_productivity/controllers/global_variable_controller.dart';
import 'package:beco_productivity/controllers/stopwatch_controller.dart';
import 'package:beco_productivity/db/timeline_db.dart';
import 'package:beco_productivity/screens/project_screen.dart';
import 'package:beco_productivity/widgets/fab.dart';
import 'package:beco_productivity/widgets/tasks_card_project_page.dart';
import 'package:beco_productivity/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          OngoingTaskCardHeader(
            title: globalController.nameOfProjectRunning.value,
            globalStopwatch: globalStopwatchResult,
            buttonLabel: 'STOP',
            onTapButton: () {
              _globalStopwatch.stop();
            },
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: timeline_db.length,
              itemBuilder: ((context, index) {
                final currentTask = timeline_db[index];
                return TaskCard_Timeline(
                  label: currentTask.title,
                  timer: currentTask.elapsedTime,
                );
              }))
        ],
      ),
    );
  }
}
