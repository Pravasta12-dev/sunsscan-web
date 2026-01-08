import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/features/guest/view/mobile/guest_scan_page.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/action_card.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_empty_widget.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_error_widget.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_loading_widget.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/model/event_model.dart';
import '../../bloc/guest/guest_bloc.dart';
import 'guest_list_page.dart';
import 'insert_guest_page.dart';
import 'widgets/guest_banner.dart';

class GuestView extends StatefulWidget {
  final EventModel activeEvent;
  final String eventName;

  const GuestView({
    super.key,
    required this.activeEvent,
    required this.eventName,
  });

  @override
  State<GuestView> createState() => _GuestViewState();
}

class _GuestViewState extends State<GuestView> {
  @override
  void initState() {
    super.initState();
    print(
      '[GuestView] Loading guests for event location: ${widget.activeEvent.location}',
    );
    context.read<GuestBloc>().loadGuests(widget.activeEvent.eventUuid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tamu', style: AppTextStyles.bodyLarge),
        centerTitle: false,
        leading: InkWell(
          onTap: () => AppTransition.popTransition(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
            size: 12,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GuestBloc, GuestState>(
            builder: (context, state) {
              if (state is GuestLoading || state is GuestInitial) {
                return GuestLoadingWidget();
              }

              if (state is GuestError) {
                return GuestErrorWidget();
              }

              if (state is GuestLoaded) {
                final guests = state.guests;
                if (guests.isEmpty) {
                  return Column(
                    children: [
                      GuestBanner(
                        activeEvent: widget.activeEvent,
                        totalGuest: 0,
                        checkedIn: 0,
                        checkOut: 0,
                      ),
                      Expanded(child: GuestEmptyWidget()),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          title: 'Tambah Tamu',
                          buttonType: ButtonType.primary,
                          onPressed: () {
                            if (widget.activeEvent.isLocked) {
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
                              GuestInsertPage(
                                eventId: widget.activeEvent.eventUuid ?? '',
                                eventName: widget.eventName,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                final totalGuest = state.guests.length;
                final checkedIn = state.guests
                    .where((guest) => guest.isCheckedIn)
                    .length;

                return Column(
                  spacing: 24,
                  children: [
                    /// 1️⃣ BANNER INFO
                    GuestBanner(
                      activeEvent: widget.activeEvent,
                      totalGuest: totalGuest,
                      checkedIn: checkedIn,
                      checkOut: state.guests
                          .where((guest) => guest.checkedOutAt != null)
                          .length,
                    ),

                    /// 2️⃣ ACTION CARDS
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 30,
                        children: [
                          ActionCard(
                            icon: Icons.qr_code_scanner_outlined,
                            title: 'Scan QR',
                            subtitle: 'Scan QR masuk',
                            onTap: () {
                              AppTransition.pushTransition(
                                context,
                                GuestScanPage(
                                  scanType: GuestScanType.checkIn,
                                  activeEventId:
                                      widget.activeEvent.eventUuid ?? '',
                                ),
                              );
                            },
                          ),
                          if (widget.activeEvent.outActive)
                            ActionCard(
                              icon: Icons.qr_code_scanner_outlined,
                              title: 'Scan QR',
                              subtitle: 'Scan QR keluar',
                              onTap: () {
                                AppTransition.pushTransition(
                                  context,
                                  GuestScanPage(
                                    scanType: GuestScanType.checkOut,
                                    activeEventId:
                                        widget.activeEvent.eventUuid ?? '',
                                  ),
                                );
                              },
                            ),
                          ActionCard(
                            icon: Icons.qr_code_scanner_outlined,
                            title: 'Generate QR',
                            subtitle: 'Input tamu baru',
                            onTap: () {
                              if (widget.activeEvent.isLocked) {
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
                                GuestInsertPage(
                                  eventId: widget.activeEvent.eventUuid ?? '',
                                  eventName: widget.eventName,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    /// 3️⃣ BOTTOM BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: 'Lihat Semua Tamu',
                        buttonType: ButtonType.primary,
                        onPressed: () {
                          AppTransition.pushTransition(
                            context,
                            GuestListPage(
                              eventId: widget.activeEvent.eventUuid ?? '',
                              eventName: widget.eventName,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
