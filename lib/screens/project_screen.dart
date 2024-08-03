// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:beco_productivity/controllers/onTap_start_or_stop_controller.dart';
import 'package:beco_productivity/controllers/projects_controller.dart';
import 'package:beco_productivity/database/projectList.dart';
import 'package:beco_productivity/screens/add_project_screen.dart';
import 'package:beco_productivity/screens/each_project_screen.dart';
import 'package:beco_productivity/widgets/button_pill.dart';
import 'package:beco_productivity/widgets/tasks_card_widgets.dart';
import 'package:beco_productivity/widgets/title_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/global_variable_controller.dart';
import '../controllers/stopwatch_controller.dart';
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
                  Get.to(() => const AddProjectScreen());
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
    // projectsController.saveToGetStorage();
    final screenHeight = MediaQuery.of(context).size.height;

    final String globalStopwatchResult =
        _globalStopwatch.elapsed.toString().split('.').first.padLeft(8, "0");

    final int _indexOfRunningTask = globalController.projectRunningIndex.value;

    return Column(
      children: [
        const CardHeader(title: 'Projects'),
        // CardHeader(title: globalStopwatchResult),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Obx(() => projectListC.isEmpty
              ? const Text('No Projects Found')
              : ShowProjects(
                  projectList: projectListC,
                  globalStopwatch: _globalStopwatch,
                  indexOfRunningTask: _indexOfRunningTask,
                  globalController: globalController,
                  globalStopwatchResult: globalStopwatchResult,
                  onTapStartStopController: onTapStartStopController,
                  projectsController: projectsController,
                )),
        ),
        SizedBox(
          height: screenHeight / 6,
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class ShowProjects extends StatelessWidget {
  ShowProjects({
    super.key,
    required this.projectList,
    required this.globalStopwatch,
    required this.indexOfRunningTask,
    required this.globalController,
    required this.onTapStartStopController,
    required this.globalStopwatchResult,
    required this.projectsController,
  });
  List projectList;
  GlobalController globalController;
  GlobalStopwatch globalStopwatch;
  int indexOfRunningTask;
  String globalStopwatchResult;
  ProjectsController projectsController;

  OnTapStartStopController onTapStartStopController =
      Get.put(OnTapStartStopController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          itemCount: projectList.length,
          itemBuilder: (context, index) {
            final thisTask = projectList[index];
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(thisTask.taskTitle),
              confirmDismiss: (direction) async {
                return await Get.defaultDialog(
                  titlePadding:
                      const EdgeInsets.only(top: 32, left: 32, right: 32),
                  middleTextStyle: const TextStyle(fontSize: 0),
                  title: 'Do you want to delete ${thisTask.taskTitle}?',
                  titleStyle: ThemeTextStyles.white18.copyWith(
                      color: ThemeColors.black, fontWeight: FontWeight.w600),
                  contentPadding:
                      EdgeInsets.only(bottom: 16, left: 32, right: 32),
                  confirm: TextButtonPill(
                      backgroundColor: ThemeColors.red_stop,
                      foregroundColor: ThemeColors.white,
                      label: 'Delete',
                      onTapButton: () => Navigator.of(context).pop(true)),
                  backgroundColor: ThemeColors.white,
                  cancel: TextButtonPill(
                      onTapButton: () => Navigator.of(context).pop(false),
                      label: 'Cancel'),
                );
              },
              onDismissed: (direction) =>
                  (projectsController.removeFromProjectListC(thisTask)),
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  // alignment: Alignment.centerRight,
                  // width: 100,
                  color: ThemeColors.red_stop,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.delete,
                      color: ThemeColors.white,
                    ),
                  ),
                ),
              ),
              child: TaskCard_ProjectsPage(
                  label: thisTask.taskTitle,
                  onPressedTitle: () =>
                      Get.to(() => EachProjectScreen(project: thisTask)),
                  startOrStopButton: StartStopButtonPill(
                      label: thisTask.isRunning ? 'STOP' : 'START',
                      onTapButton: () {
                        globalController.assign_IndexOfProjectRunning(index);
                        if (globalController.isAnyProjectRunning.isTrue) {
                          if (thisTask.isRunning) {
                            onTapStartStopController.stopProject(
                              index,
                              globalStopwatch,
                            );
                          } else {
                            onTapStartStopController.stopProject(
                              indexOfRunningTask,
                              globalStopwatch,
                            );
                            onTapStartStopController.startProject(
                                index, globalStopwatch);
                          }
                        } else {
                          onTapStartStopController.startProject(
                              index, globalStopwatch);
                        }
                      },
                      buttonAccentColor: thisTask.isRunning
                          ? ThemeColors.red_stop
                          : ThemeColors.accentMain)),
            );
          }),
    );
  }
}
