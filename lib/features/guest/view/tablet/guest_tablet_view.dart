import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_error_widget.dart';
import 'package:sun_scan/features/guest/view/tablet/section/guest_tablet_banner.dart';
import 'package:sun_scan/features/guest/view/tablet/section/guest_tablet_content_header.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/model/event_model.dart';
import '../../bloc/guest/guest_bloc.dart';
import '../mobile/widgets/guest_loading_widget.dart';
import 'section/guest_tablet_content_bottom.dart';

class GuestTabletView extends StatefulWidget {
  const GuestTabletView({super.key, required this.activeEvent});

  final EventModel activeEvent;

  @override
  State<GuestTabletView> createState() => _GuestTabletViewState();
}

class _GuestTabletViewState extends State<GuestTabletView> {
  @override
  void initState() {
    super.initState();
    context.read<GuestBloc>().loadGuests(widget.activeEvent.eventUuid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 16,
              children: [
                InkWell(
                  onTap: () => AppTransition.popTransition(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.whiteColor,
                    size: 24,
                  ),
                ),
                Text(
                  'SUN SCAN',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<GuestBloc, GuestState>(
                builder: (context, state) {
                  if (state is GuestLoading) {
                    return GuestLoadingWidget();
                  }

                  if (state is GuestError) {
                    return GuestErrorWidget();
                  }

                  if (state is GuestLoaded) {
                    final guests = state.guests;

                    return Column(
                      spacing: 30.0,
                      children: [
                        GuestTabletBanner(
                          eventName: widget.activeEvent.name,
                          totalGuest: guests.length,
                          checkedIn: guests
                              .where((guest) => guest.isCheckedIn)
                              .length,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Flexible(
                                flex: 1,
                                child: GuestTabletContentHeader(
                                  eventId: widget.activeEvent.eventUuid ?? '',
                                ),
                              ),
                              SizedBox(height: 24),
                              Flexible(
                                flex: 3,
                                child: GuestTabletContentBottom(guests: guests),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
