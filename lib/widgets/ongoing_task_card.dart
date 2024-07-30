import 'package:flutter/material.dart';

import 'button_pill.dart';
import 'texts.dart';

class OngoingTaskCardHeader extends StatelessWidget {
  const OngoingTaskCardHeader({
    super.key,
    required this.title,
    required this.globalStopwatch,
    required this.buttonLabel,
    required this.onTapButton,
  });

  final String title;
  final String globalStopwatch;
  final Function onTapButton;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: const BoxDecoration(
              color: ThemeColors.accentMain,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: ThemeTextStyles.white18,
                  ),
                  Text(
                    globalStopwatch,
                    style: ThemeTextStyles.white18,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note 1, Note 2',
                    style: ThemeTextStyles.white18
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Note 3',
                    style: ThemeTextStyles.white18
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const Expanded(
                child: SizedBox(
                  height: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButtonPill(
                    label: buttonLabel,
                    onTapButton: () {},
                  )
                ],
              )
            ],
          )),
    );
  }
}
