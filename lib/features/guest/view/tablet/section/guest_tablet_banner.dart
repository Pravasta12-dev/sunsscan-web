import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/utils/shimmer_box.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/guest/view/tablet/section/guest_tablet_tabbar.dart';

import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../event/bloc/event/event_bloc.dart';
import '../../../../event/views/tablet/dialog/event_create_dialog.dart';

class GuestTabletBanner extends StatelessWidget {
  final String eventUuid;

  const GuestTabletBanner({super.key, required this.eventUuid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                child: BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    bool isLoading = state is EventLoading;

                    if (state is EventError) {
                      return Text('Error loading event', style: AppTextStyles.bodyLarge);
                    }

                    final EventModel event = (state is EventLoaded)
                        ? state.events.firstWhere(
                            (event) => event.eventUuid == eventUuid,
                            orElse: () => EventModel.empty(),
                          )
                        : EventModel.empty();

                    return Row(
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
                        const SizedBox(width: 20),
                        if (!isLoading)
                          CustomButton(
                            onPressed: () {
                              CustomDialog.showMainDialog(
                                context: context,
                                child: EventCreateDialog(activeEvent: event),
                              );
                            },
                            title: 'Ubah Informasi',
                            buttonType: ButtonType.outline,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.lightGreyColor, width: 0.5)),
            ),
            child: GuestTabletTabbar(),
          ),
        ],
      ),
    );
  }
}
