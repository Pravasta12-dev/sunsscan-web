import 'package:flutter/widgets.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import '../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/model/event_model.dart';

class EventTabletBanner extends StatelessWidget {
  const EventTabletBanner({super.key, this.activeEvent});

  final EventModel? activeEvent;

  @override
  Widget build(BuildContext context) {
    final bool hasActiveEvent = activeEvent != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightPrimaryColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Assets.svg.svgClock.svg(
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasActiveEvent
                      ? 'Event aktif: ${activeEvent!.name}'
                      : 'Belum ada event Tersedia.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  hasActiveEvent
                      ? 'Tanggal: ${activeEvent!}'
                      : 'Tambah event untuk memulai Scan.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
