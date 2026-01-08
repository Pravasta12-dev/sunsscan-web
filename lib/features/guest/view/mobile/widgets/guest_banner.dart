import 'package:flutter/material.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/event/pages/create_event_page.dart';

import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GuestBanner extends StatelessWidget {
  final int totalGuest;
  final int checkedIn;
  final EventModel activeEvent;
  final int checkOut;

  const GuestBanner({
    super.key,

    required this.totalGuest,
    required this.checkedIn,
    required this.activeEvent,
    this.checkOut = 0,
  });

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
                  'Tanggal: ${CustomDateFormat().getFormattedFullDate(date: activeEvent.eventDateStart)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  'Total Tamu: $totalGuest • Masuk: $checkedIn • Keluar: $checkOut',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (activeEvent.isLocked) {
                CustomDialog.showCustomDialog(
                  context: context,
                  dialogType: DialogEnum.info,
                  title: 'Acara Terkunci',
                  message:
                      'Acara telah dikunci. Tidak dapat menambahkan tamu baru.',
                );
                return;
              }
              AppTransition.pushTransition(
                context,
                CreateEventPage(activeEvent: activeEvent),
              );
            },
            child: Assets.svg.svgEdit.svg(
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
