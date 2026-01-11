import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_scan/data/model/guests_model.dart';

import '../../../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/utils/shimmer_box.dart';
import '../../../../../bloc/guest/guest_bloc.dart';
import 'circular_progress.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  bool _isVip(GuestsModel g) {
    final name = (g.guestCategoryName ?? '').trim().toUpperCase();

    return name == 'VIP' || name.contains('VIP');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestBloc, GuestState>(
      builder: (context, state) {
        final bool isLoading = state is GuestLoading;

        final List<GuestsModel> guests = state is GuestLoaded
            ? state.guests
            : [];

        final vipGuests = guests.where(_isVip).toList();
        final regularGuests = guests.where((g) => !_isVip(g)).toList();

        int attendedCount(List<GuestsModel> list) => list.length;
        int checkedInCount(List<GuestsModel> list) =>
            list.where((g) => g.isCheckedIn).length;
        int notCheckedInCount(List<GuestsModel> list) =>
            list.where((g) => !g.isCheckedIn).length;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              _StatisticCard(
                type: StatisticType.vip,
                isLoading: isLoading,
                attended: attendedCount(vipGuests),
                checkedIn: checkedInCount(vipGuests),
                notCheckedIn: notCheckedInCount(vipGuests),
                total: vipGuests.length,
              ),
              const SizedBox(width: 16),
              _StatisticCard(
                type: StatisticType.regular,
                isLoading: isLoading,
                attended: attendedCount(regularGuests),
                checkedIn: checkedInCount(regularGuests),
                notCheckedIn: notCheckedInCount(regularGuests),
                total: regularGuests.length,
              ),
            ],
          ),
        );
      },
    );
  }
}

enum StatisticType { vip, regular }

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.type,
    required this.isLoading,
    this.attended,
    this.total,
    this.checkedIn,
    this.notCheckedIn,
  });

  final StatisticType type;
  final bool isLoading;
  final int? attended;
  final int? total;
  final int? checkedIn;
  final int? notCheckedIn;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.headerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    type == StatisticType.vip
                        ? Assets.svg.svgSpark.path
                        : Assets.svg.svgProfile.path,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type == StatisticType.vip
                          ? 'VIP Guests'
                          : 'Regular Guests',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    isLoading
                        ? const ShimmerBox(width: 80, height: 12)
                        : Text(
                            '$attended/$total attended',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.greyColor.withAlpha(80),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Placeholder for statistic number
            CircularGauge(
              isLoading: isLoading,
              progress: total != null && total! > 0
                  ? (checkedIn ?? 0) / total!
                  : 0.0,
              color: type == StatisticType.vip
                  ? AppColors.primaryColor
                  : AppColors.purpleColor,
              size: 150,
            ),

            /// END
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tamu Masuk',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.greyColor.withAlpha(80),
                    ),
                  ),
                ),
                isLoading
                    ? const ShimmerBox(width: 32, height: 12)
                    : Text(
                        '$checkedIn',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Belum Masuk',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.greyColor.withAlpha(80),
                    ),
                  ),
                ),
                isLoading
                    ? const ShimmerBox(width: 32, height: 12)
                    : Text(
                        '$notCheckedIn',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color get color {
    switch (type) {
      case StatisticType.vip:
        return AppColors.primaryColor;
      case StatisticType.regular:
        return AppColors.purpleColor;
    }
  }
}
