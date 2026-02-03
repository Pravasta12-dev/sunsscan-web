import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/features/guest/bloc/guest_tab/guest_tab_cubit.dart';
import 'package:sun_scan/features/guest/bloc/souvenir/souvenir_bloc.dart';

class GuestTabletTabbar extends StatelessWidget {
  GuestTabletTabbar({super.key, required this.eventUuid});

  final String eventUuid;

  final List<_TabbarLabel> tabbarLabels = [
    _TabbarLabel(
      label: 'Dashboard',
      assetIcon: Assets.svg.svgDashboard.path,
      tab: GuestTab.dashboard,
    ),
    _TabbarLabel(label: 'Scan', assetIcon: Assets.svg.svgCamera.path, tab: GuestTab.scan),
    _TabbarLabel(label: 'List Tamu', assetIcon: Assets.svg.svgUsers.path, tab: GuestTab.guests),
    _TabbarLabel(label: 'Souvenir', assetIcon: Assets.svg.svgGift.path, tab: GuestTab.souvenirs),
    _TabbarLabel(label: 'Layar Sapa', assetIcon: Assets.svg.svgMonitor.path, tab: GuestTab.layers),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestTabCubit, GuestTab>(
      builder: (context, state) {
        return DefaultTabController(
          length: tabbarLabels.length,
          initialIndex: state.index,
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
                context.read<GuestTabCubit>().setTab(GuestTab.values[value]);
                switch (GuestTab.values[value]) {
                  case GuestTab.dashboard:
                    break;
                  case GuestTab.scan:
                    break;
                  case GuestTab.guests:
                    break;
                  case GuestTab.souvenirs:
                    context.read<SouvenirBloc>().loadSouvenirs(eventUuid);
                    break;
                  case GuestTab.layers:
                    break;
                }
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
