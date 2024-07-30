// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';


class GlobalController extends GetxController {
  RxBool isAnyProjectRunning = false.obs;

  late RxInt projectRunningIndex = RxInt(-1);
  RxString nameOfProjectRunning = ''.obs;

  void toggle_IsAnyProjectRunningValue() => isAnyProjectRunning.toggle();
  void assign_IndexOfProjectRunning(int index) =>
      projectRunningIndex = RxInt(index);

  void assign_NameOfProjectRunning(String projectTitle) =>
      nameOfProjectRunning = RxString(projectTitle);

  void clearNameOfProjectRunning() => nameOfProjectRunning = RxString('');
  void clearProjectRunningIndex() => projectRunningIndex = RxInt(-1);
}
