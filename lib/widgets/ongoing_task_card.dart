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
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Working On:',
            style: ThemeTextStyles.white18.copyWith(
                color: ThemeColors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: ThemeTextStyles.title24white,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      Text(
                        globalStopwatch,
                        style: ThemeTextStyles.title24white,
                      ),
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
                        onTapButton: () => onTapButton(),
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
