import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HeaderAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  // void toggleWidget(bool showWidget) {
  //   showWidget = !showWidget;
  //   if (showWidget) {
  //     _animationController.forward();
  //   } else {
  //     _animationController.reverse();
  //   }
  //   update();
  // }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}
