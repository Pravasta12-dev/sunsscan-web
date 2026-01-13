import 'package:flutter/material.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/web/pages/web_dashboard_tabbar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../core/routes/app_transition.dart';
import '../../../core/utils/shimmer_box.dart';

class WebDashboardBanner extends StatelessWidget {
  const WebDashboardBanner({super.key, required this.isLoading, required this.event});

  final bool isLoading;
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.headerColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  AppTransition.popTransition(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isLoading
                              ? ShimmerBox(width: 200, height: 24)
                              : Text(event.name, style: AppTextStyles.bodyLarge),
                          const SizedBox(height: 2),
                          //date
                          isLoading
                              ? ShimmerBox(width: 150, height: 16)
                              : Text(
                                  CustomDateFormat().getFormattedEventDateRange(
                                    startDate: event.eventDateStart,
                                    endDate: event.eventDateEnd,
                                  ),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.greyColor.withAlpha(200),
                                  ),
                                ),
                          const SizedBox(height: 4),
                          isLoading
                              ? ShimmerBox(width: 250, height: 16)
                              : Row(
                                  children: [
                                    Text(
                                      'ID#${event.eventCode} ',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.greyColor.withAlpha(200),
                                      ),
                                    ),
                                    if (event.location != null || event.location!.isNotEmpty)
                                      Text(
                                        '| Lokasi: ${event.location}',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.greyColor.withAlpha(200),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.lightGreyColor, width: 0.5)),
            ),
            child: WebDashboardTabbar(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
