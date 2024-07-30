// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:beco_productivity/controllers/add_project_dialogue_box_controller.dart';
import 'package:beco_productivity/controllers/onTap_start_or_stop_controller.dart';
import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/screens/each_project_screen.dart';
import 'package:beco_productivity/widgets/button_pill.dart';
import 'package:beco_productivity/widgets/tasks_card_project_page.dart';
import 'package:beco_productivity/widgets/title_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/global_variable_controller.dart';
import '../controllers/stopwatch_controller.dart';
import '../models/project_model.dart';
import '../widgets/fab.dart';
import '../widgets/texts.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  // final AddProjectController addProjectController =
  //     Get.put(AddProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 4),
            child: IconButton(
                onPressed: () {
                  Get.to(() =>EachProjectScreen());
                },
                icon: const Icon(
                  Icons.add,
                  color: ThemeColors.accentMain,
                )),
          ),
        ],
      ),
      body: const ProjectScreenBody(),
      floatingActionButton: FABPill(
          onTapFAB: () {
            Get.back();
          },
          labelFAB: 'Back',
          textStyleFAB: ThemeTextStyles.white18),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class ProjectScreenBody extends StatefulWidget {
  const ProjectScreenBody({super.key});

  @override
  State<ProjectScreenBody> createState() => _ProjectScreenBodyState();
}

class _ProjectScreenBodyState extends State<ProjectScreenBody> {
  final GlobalController globalController = Get.find<GlobalController>();
  final ProjectsController projectsController = Get.put(ProjectsController());
  final OnTapStartStopController onTapStartStopController =
      Get.put(OnTapStartStopController());

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
    // ignore: non_constant_identifier_names

    final String globalStopwatchResult =
        _globalStopwatch.elapsed.toString().split('.').first.padLeft(8, "0");

    final List<Project> _projectList = projectsController.projectListC;
    projectsController.saveToGetStorage();

    final int _indexOfRunningTask = globalController.projectRunningIndex.value;

    return Column(
      children: [
        const CardHeader(title: 'Projects'),
        // CardHeader(title: globalStopwatchResult),
        const SizedBox(
          height: 16,
        ),
        Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: _projectList.length,
            itemBuilder: (context, index) {
              final thisTask = _projectList[index];
              return TaskCard_ProjectsPage(
                  label: thisTask.taskTitle,
                  startOrStopButton: StartStopButtonPill(
                      label: thisTask.isRunning ? 'STOP' : 'START',
                      onTapButton: () {
                        globalController.assign_IndexOfProjectRunning(index);
                        if (globalController.isAnyProjectRunning.isTrue) {
                          if (thisTask.isRunning) {
                            onTapStartStopController.stopProject(
                                index, _globalStopwatch);
                          } else {
                            onTapStartStopController.stopProject(
                                _indexOfRunningTask, _globalStopwatch);
                            onTapStartStopController.startProject(
                                index, _globalStopwatch);
                          }
                        } else {
                          onTapStartStopController.startProject(
                              index, _globalStopwatch);
                        }
                      },
                      buttonAccentColor: thisTask.isRunning
                          ? ThemeColors.red_stop
                          : ThemeColors.accentMain));
            }))
      ],
    );
  }
}
