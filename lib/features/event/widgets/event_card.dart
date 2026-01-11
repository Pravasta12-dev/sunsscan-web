import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_icon_popup.dart';
import 'package:sun_scan/core/helper/responsive_builder.dart';
import 'package:sun_scan/features/event/views/tablet/dialog/event_create_dialog.dart';

import '../../../core/components/custom_dialog.dart';
import '../../../core/helper/assets/assets.gen.dart';
import '../../../core/routes/app_transition.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../data/model/event_model.dart';
import '../../guest/pages/guest_page.dart';
import '../bloc/event/event_bloc.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _EventCardMobile(event: event),
      tabletUp: _EventCardTablet(event: event),
    );
  }
}

class _EventCardTablet extends StatelessWidget {
  const _EventCardTablet({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: event.isLocked
            ? AppColors.greyColor.withAlpha(100)
            : AppColors.lightBlackColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 2),
                //date
                Text(
                  CustomDateFormat().getFormattedEventDateRange(
                    startDate: event.eventDateStart,
                    endDate: event.eventDateEnd,
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.greyColor.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'ID#${event.eventCode} ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.greyColor.withAlpha(200),
                      ),
                    ),
                    if (event.location != null || event.location!.isNotEmpty)
                      Expanded(
                        child: Text(
                          '| Lokasi: ${event.location}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.greyColor.withAlpha(200),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          event.isLocked
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyColor,
                    shape: BoxShape.circle,
                  ),
                  child: Assets.svg.svgLock.svg(
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : CustomButton(
                  onPressed: () {
                    AppTransition.pushTransition(
                      context,
                      GuestPage(activeEvent: event),
                    );
                  },
                  title: 'Masuk Event',
                  buttonType: ButtonType.outline,
                ),
          const SizedBox(width: 12),
          CustomIconPopup(
            iconSize: 16,
            assetsItems: [
              Assets.svg.svgPencil.path,
              Assets.svg.svgCircleRemove.path,
              Assets.svg.svgUpload.path,
            ],
            onMenuSelected: [
              () {
                // EDIT EVENT
                CustomDialog.showMainDialog(
                  context: context,
                  child: EventCreateDialog(activeEvent: event),
                );
              },
              () {
                // LOCK EVENT
                CustomDialog.showConfirmationRemoveDialog(
                  context: context,
                  title: 'Nonaktifkan Acara',
                  message:
                      'Apakah Anda yakin ingin menonaktifkan "${event.name}"?\n'
                      'Tindakan ini akan menandai acara sebagai kadaluarsa dan mencegah proses check-in lebih lanjut.',
                  onConfirmed: () {
                    // DISPATCH BLOC UNTUK UPDATE ISLOCKED
                    final updatedEvent = event.copyWith(
                      isLocked: !event.isLocked,
                    );
                    context.read<EventBloc>().updateEvent(updatedEvent);
                  },
                );
              },
              () {
                // EXPORT EVENT
              },
            ],
            menuItems: [
              'Edit Event',
              event.isLocked ? 'Buka Kunci Acara' : 'Kunci Acara',
              'Export Event',
            ],
            icon: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.more_vert,
                color: AppColors.whiteColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCardMobile extends StatelessWidget {
  const _EventCardMobile({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppTransition.pushTransition(context, GuestPage(activeEvent: event));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.lightBlackColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGreyColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 2),
                  //date
                  Text(
                    CustomDateFormat().getFormattedEventDateRange(
                      startDate: event.eventDateStart,
                      endDate: event.eventDateEnd,
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.greyColor.withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'ID#${event.eventCode} ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.greyColor.withAlpha(200),
                        ),
                      ),
                      if (event.location != null || event.location!.isNotEmpty)
                        Expanded(
                          child: Text(
                            '| Lokasi: ${event.location}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.greyColor.withAlpha(200),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.whiteColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
