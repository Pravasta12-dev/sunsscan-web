import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';

class GuestScanTabbar extends StatelessWidget {
  const GuestScanTabbar({super.key, required this.selectedIndex, required this.onTabChanged});

  final int selectedIndex;
  final Function(int) onTabChanged;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _TabbarLabel.tabbarLabels.length,
      initialIndex: selectedIndex,
      child: Container(
        color: AppColors.headerColor,
        child: TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: AppTextStyles.body,
          unselectedLabelStyle: AppTextStyles.body.copyWith(
            color: AppColors.greyColor.withAlpha(150),
          ),
          onTap: (value) {
            onTabChanged(value);
          },
          tabs: _TabbarLabel.tabbarLabels
              .map(
                (tab) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Tab(text: tab.label)],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TabbarLabel {
  final String label;
  final int index;

  _TabbarLabel({required this.label, required this.index});

  static final List<_TabbarLabel> tabbarLabels = [
    _TabbarLabel(label: 'Scan Masuk', index: 0),
    _TabbarLabel(label: 'Scan Keluar', index: 1),
  ];
}
