import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/features/guest/bloc/guest_tab/guest_tab_cubit.dart';

class WebDashboardTabbar extends StatelessWidget {
  WebDashboardTabbar({super.key});

  final List<_TabbarLabel> tabbarLabels = [
    _TabbarLabel(label: 'List Tamu', assetIcon: Assets.svg.svgUsers.path, tab: GuestTab.guests),
    _TabbarLabel(label: 'Souvenir', assetIcon: Assets.svg.svgGift.path, tab: GuestTab.souvenirs),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestTabCubit, GuestTab>(
      builder: (context, state) {
        // Cari index yang benar dari tabbarLabels
        var initialIndex = tabbarLabels.indexWhere((tab) => tab.tab == state);

        // Jika state tidak ada (misal dashboard), default ke guests
        if (initialIndex < 0) {
          initialIndex = tabbarLabels.indexWhere((tab) => tab.tab == GuestTab.guests);
          if (initialIndex < 0) initialIndex = 0;
        }

        return DefaultTabController(
          length: tabbarLabels.length,
          initialIndex: initialIndex,
          child: Container(
            color: AppColors.headerColor,
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
              indicator: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              labelStyle: AppTextStyles.body,
              unselectedLabelStyle: AppTextStyles.body.copyWith(
                color: AppColors.greyColor.withAlpha(150),
              ),
              onTap: (value) {
                // Handle tab changes if necessary
                context.read<GuestTabCubit>().setTab(tabbarLabels[value].tab);
              },
              tabs: tabbarLabels
                  .map(
                    (tab) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          tab.assetIcon,
                          width: 20,
                          colorFilter: ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 12),
                        Tab(text: tab.label),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _TabbarLabel {
  final String label;
  final String assetIcon;
  final GuestTab tab;

  _TabbarLabel({required this.label, required this.assetIcon, required this.tab});
}
