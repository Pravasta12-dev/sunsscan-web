import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/event/widgets/event_empty.dart';
import 'package:sun_scan/features/guest/pages/guest_page.dart';

import '../../../core/routes/app_transition.dart';
import '../../../core/theme/app_colors.dart';

class EventLoadedWidget extends StatefulWidget {
  const EventLoadedWidget({
    super.key,
    required this.events,
    this.isTablet = false,
  });

  final List<EventModel> events;
  final bool isTablet;

  @override
  State<EventLoadedWidget> createState() => _EventLoadedWidgetState();
}

class _EventLoadedWidgetState extends State<EventLoadedWidget> {
  List<EventModel> get events => widget.events;
  List<EventModel> filteredEvents = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredEvents = events;
  }

  @override
  void didUpdateWidget(EventLoadedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filteredEvents ketika widget.events berubah
    if (oldWidget.events != widget.events) {
      _applyFilter();
    }
  }

  void _applyFilter() {
    setState(() {
      if (_searchQuery.isEmpty) {
        filteredEvents = events;
      } else {
        filteredEvents = events
            .where(
              (event) =>
                  event.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.isTablet
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          CustomFormWidget().buildTextFormInput(
            onChanged: (value) {
              _searchQuery = value;
              _applyFilter();
            },
            hintText: 'Cari Acara...',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          const SizedBox(height: 12),
          widget.isTablet
              ? Expanded(
                  child: filteredEvents.isEmpty
                      ? EventEmptyWidget()
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 12,
                              runSpacing: 12,
                              children: filteredEvents.map((event) {
                                return InkWell(
                                  onTap: () {
                                    AppTransition.pushTransition(
                                      context,
                                      GuestPage(activeEvent: event),
                                    );
                                  },
                                  child: Container(
                                    width: 400,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.lightGreyColor,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Assets.svg.svgCalendarDays.svg(
                                            width: 40,
                                            height: 40,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.whiteColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event.name,
                                                style: AppTextStyles.title
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                CustomDateFormat()
                                                    .getFormattedFullDate(
                                                      date:
                                                          event.eventDateStart,
                                                    ),
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                      color: AppColors
                                                          .blackColor
                                                          .withAlpha(200),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                )
              : Expanded(
                  child: filteredEvents.isEmpty
                      ? EventEmptyWidget()
                      : ListView.separated(
                          itemCount: filteredEvents.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];

                            return GestureDetector(
                              onTap: () {
                                AppTransition.pushTransition(
                                  context,
                                  GuestPage(activeEvent: event),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlackColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.lightGreyColor,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.name,
                                            style: AppTextStyles.bodyLarge,
                                          ),
                                          const SizedBox(height: 2),
                                          //date
                                          Text(
                                            CustomDateFormat()
                                                .getFormattedEventDateRange(
                                                  startDate:
                                                      event.eventDateStart,
                                                  endDate: event.eventDateEnd,
                                                ),
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: AppColors.greyColor
                                                      .withAlpha(200),
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                'ID#${event.eventCode} ',
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                      color: AppColors.greyColor
                                                          .withAlpha(200),
                                                    ),
                                              ),
                                              if (event.location != null ||
                                                  event.location!.isNotEmpty)
                                                Expanded(
                                                  child: Text(
                                                    '| Lokasi: ${event.location}',
                                                    style: AppTextStyles.caption
                                                        .copyWith(
                                                          color: AppColors
                                                              .greyColor
                                                              .withAlpha(200),
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
