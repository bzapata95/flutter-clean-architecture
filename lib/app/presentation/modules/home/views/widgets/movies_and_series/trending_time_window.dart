import 'package:flutter/material.dart';

import '../../../../../../domain/enums.dart';
import '../../../../../../generated/translations.g.dart';
import '../../../../../global/colors.dart';
import '../../../../../global/extensions/build_context_ext.dart';

class TrendingTimeWindow extends StatelessWidget {
  const TrendingTimeWindow({
    super.key,
    required this.timeWindow,
    required this.onChanged,
  });
  final TimeWindow timeWindow;
  final void Function(TimeWindow) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translation.home.trending,
            style: context.textTheme.titleSmall,
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color:
                  context.darkMode ? AppColors.dark : const Color(0xfff0f0f0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<TimeWindow>(
                  underline: const SizedBox(),
                  isDense: true,
                  value: timeWindow,
                  items: [
                    DropdownMenuItem(
                      value: TimeWindow.day,
                      child: Text(translation.home.dropdownButton.last24),
                    ),
                    DropdownMenuItem(
                      value: TimeWindow.week,
                      child: Text(translation.home.dropdownButton.lastWeek),
                    )
                  ],
                  onChanged: (mTimeWindow) {
                    if (mTimeWindow != null && mTimeWindow != timeWindow) {
                      onChanged(mTimeWindow);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
