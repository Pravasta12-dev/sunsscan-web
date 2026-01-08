import 'package:flutter/material.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/event_model.dart';

import '../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class WebGuestBanner extends StatelessWidget {
  final EventModel activeEvent;

  const WebGuestBanner({super.key, required this.activeEvent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
            child: Assets.svg.svgCalendar.svg(
              width: 16,
              height: 16,
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
                  activeEvent.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  'Tanggal: ${CustomDateFormat().getFormattedFullDate(date: activeEvent.eventDateStart)} - ${CustomDateFormat().getFormattedFullDate(date: activeEvent.eventDateEnd)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  'ID#${activeEvent.eventUuid} ${activeEvent.location != null ? '- Lokasi: ${activeEvent.location}' : '-'}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
