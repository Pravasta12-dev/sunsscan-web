import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/utils/export_to_gallery.dart';
import 'package:sun_scan/data/model/guests_model.dart';

import '../../../../core/routes/app_transition.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/generate_qr_code.dart';
import '../../../../core/utils/open_whatsapp_utils.dart';
import '../../../../core/utils/share_qr_image.dart';
import 'insert_guest_page.dart';

class GuestInsertSuccessPage extends StatelessWidget {
  GuestInsertSuccessPage({super.key, required this.guest});

  final GuestsModel guest;
  final GlobalKey qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            spacing: 24.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor.withAlpha(50),
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  width: 240,
                                  height: 240,
                                  drawText: false,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          guest.name,
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guest.phone ?? '-',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withAlpha(50),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          topRight: Radius.circular(12.0),
                        ),
                        border: Border.all(color: AppColors.greenColor),
                      ),
                      child: Text(
                        guest.guestCategoryName ?? 'Tamu Biasa',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          exportQrToGallery(context, qrKey, 'qr_${guest.guestUuid}');
                        },
                        title: 'Export',
                        assetsPath: Assets.svg.svgDownload.path,
                        buttonType: ButtonType.outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        assetsPath: Assets.svg.svgShare.path,
                        onPressed: () async {
                          await shareQrToWhatsApp();
                        },
                        title: 'Share',
                        buttonType: ButtonType.outline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    AppTransition.popTransition(context, result: CreateGuestResult.createAnother);
                  },
                  title: 'Generate Another',
                  buttonType: ButtonType.primary,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    AppTransition.popTransition(context, result: CreateGuestResult.backToList);
                  },
                  title: 'Back to List',
                  buttonType: ButtonType.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shareQrToWhatsApp() async {
    try {
      // 1. buka chat WA dulu
      if (guest.phone != null && guest.phone!.isNotEmpty) {
        await openWhatsApp(
          phone: guest.phone!,
          message:
              'Halo Saudara/i ${guest.name}, Anda diundang pada acara "${guest.eventName}". Kehadiran anda sangat berarti bagi acara kami.',
        );
      }

      // 2. capture QR jadi image
      final file = await captureQrToImage(qrKey, 'qr_${guest.guestUuid}');

      // 3. share image (user pilih WA)
      await shareQrImage(file: file, guestName: guest.name);
    } catch (e) {
      print('Error sharing QR: $e');
    }
  }
}
