import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/helper/responsive_builder.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/view/mobile/insert_guest_page.dart';
import 'package:sun_scan/features/guest/view/tablet/dialog/guest_detail_dialog.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/export_to_gallery.dart';
import '../../../../core/utils/generate_qr_code.dart';
import '../../../../core/utils/share_qr_image.dart';
import '../../bloc/guest/guest_bloc.dart';

class GuestDetailPage extends StatelessWidget {
  final GuestsModel guest;

  const GuestDetailPage({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    debugPrint('Qr Value: ${guest.qrValue}');
    debugPrint('Event Name: ${guest.eventName}');

    return BlocBuilder<GuestBloc, GuestState>(
      builder: (context, state) {
        // Cari guest yang ter-update berdasarkan ID
        GuestsModel currentGuest = guest;
        if (state is GuestLoaded) {
          final updatedGuest = state.guests.firstWhere(
            (g) => g.guestUuid == guest.guestUuid,
            orElse: () => guest,
          );
          // Preserve eventName dari guest asli karena tidak disimpan di database
          currentGuest = updatedGuest.copyWith(eventName: guest.eventName);
        }

        return ResponsiveBuilder(
          mobile: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Detail Tamu', style: AppTextStyles.bodyLarge),
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
                child: _GuestDetailContent(guest: currentGuest),
              ),
            ),
          ),
          tabletUp: Container(
            width: 600,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.headerColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGreyColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [GuestDetailDialog(guest: currentGuest)],
            ),
          ),
        );
      },
    );
  }
}

class _GuestDetailContent extends StatelessWidget {
  _GuestDetailContent({required this.guest});

  final GuestsModel guest;
  final GlobalKey qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBlackColor,
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    CustomDialog.showConfirmationRemoveDialog(
                      context: context,
                      title: 'Hapus Tamu',
                      message: 'Apakah Anda yakin ingin menghapus tamu ini?',
                      onConfirmed: () {
                        context.read<GuestBloc>().deleteGuest(
                          guest.guestUuid ?? '',
                          guest.eventUuid,
                        );
                        AppTransition.popTransition(context);
                      },
                    );
                  },
                  child: Assets.svg.svgTrash.svg(
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// ======================
              /// QR CARD
              /// ======================
              RepaintBoundary(
                key: qrKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: guest.qrValue,
                    width: 150,
                    height: 150,
                    drawText: false,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                guest.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                guest.phone ?? '-',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Jam Masuk', style: AppTextStyles.body),
                        const SizedBox(height: 4),
                        Text(
                          guest.checkedInAt != null
                              ? CustomDateFormat().getFormattedTime(
                                  date: guest.checkedInAt!,
                                )
                              : '-',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Jam Keluar', style: AppTextStyles.body),
                        const SizedBox(height: 4),
                        Text(
                          guest.checkedOutAt != null
                              ? CustomDateFormat().getFormattedTime(
                                  date: guest.checkedOutAt!,
                                )
                              : '-',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// UPDATE DETAILS CARD
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () {
              AppTransition.pushTransition(
                context,
                GuestInsertPage(
                  eventId: guest.eventUuid,
                  eventName: guest.eventName ?? '',
                  existingGuest: guest,
                ),
              );
            },
            title: 'Ubah Detail',
            buttonType: ButtonType.primary,
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () {
              exportQrToGallery(context, qrKey, 'qr_${guest.guestUuid}');
            },
            title: 'Export',
            buttonType: ButtonType.outline,
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () async {
              await shareQrToWhatsApp();
            },
            title: 'Share',
            buttonType: ButtonType.outline,
          ),
        ),
      ],
    );
  }

  Future<void> shareQrToWhatsApp() async {
    try {
      // 1. capture QR jadi image
      final file = await captureQrToImage(qrKey, 'qr_${guest.guestUuid ?? ''}');

      // 2. share image dengan caption (user pilih WA atau sosmed lain)
      final caption =
          'Halo Saudara/i ${guest.name}, Anda diundang pada acara "${guest.eventName ?? '-'}". Kehadiran anda sangat berarti bagi acara kami.';

      await shareQrImage(file: file, guestName: guest.name, caption: caption);
    } catch (e) {
      print('Error sharing QR: $e');
    }
  }
}
