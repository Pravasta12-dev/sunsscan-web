import 'package:barcode_widget/barcode_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/data/model/guests_model.dart';

import '../../../../../../core/components/custom_button.dart';
import '../../../../../../core/components/custom_form_widget.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/export_to_gallery.dart';
import '../../../../../../core/utils/generate_qr_code.dart';
import '../../../../../../core/utils/open_whatsapp_utils.dart';
import '../../../../../../core/utils/share_qr_image.dart';
import '../../../../bloc/guest/guest_bloc.dart';

class InsertResult extends StatelessWidget {
  const InsertResult({super.key, required this.eventId, this.guest});

  final String eventId;
  final GuestsModel? guest;

  @override
  Widget build(BuildContext context) {
    final qrKey = GlobalKey();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
            color: AppColors.lightBlackColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: guest?.qrValue.isNotEmpty ?? false
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: BarcodeWidget(
                            key: qrKey,
                            barcode: Barcode.qrCode(),
                            data: guest?.qrValue ?? '',
                            width: 200,
                            height: 200,
                            drawText: false,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        guest?.name ?? '-',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guest?.phone ?? '-',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.qr_code_scanner_outlined,
                        size: 50,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QR akan muncul disini',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lengkapi informasi pengguna dan klik ‘Generate QR’',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 16),
        if (guest?.qrValue.isNotEmpty ?? false)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {
                      exportQrToGallery(
                        context,
                        qrKey,
                        'qr_${guest?.guestUuid}',
                      );
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
                      await shareQrToWhatsApp(qrKey);
                    },
                    title: 'Share',
                    buttonType: ButtonType.outline,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Divider(color: AppColors.lightGreyColor),
        const SizedBox(height: 16),
        Column(
          children: [
            CustomFormWidget().buildFormSelectFile(
              title: 'IMPORT DARI CSV',
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                );

                if (result == null || result.files.single.path == null) {
                  return;
                }

                final path = result.files.single.path!;

                context.read<GuestBloc>().importGuests(eventId, path);
              },
            ),

            const SizedBox(height: 12),
            // banner tips
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBlackColor,
                border: Border.all(color: AppColors.primaryColor.withAlpha(50)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.svg.svgSparkles.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Tips: Pastikan file CSV memiliki kolom "name", "phone", "gender", dan "category" agar impor berjalan lancar.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.greyColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> shareQrToWhatsApp(GlobalKey qrKey) async {
    try {
      // 1. buka chat WA dulu
      if (guest?.phone != null && guest?.phone?.isNotEmpty == true) {
        await openWhatsApp(
          phone: guest!.phone!,
          message:
              'Halo Saudara/i ${guest!.name}, Anda diundang pada acara "${guest!.eventName}". Kehadiran anda sangat berarti bagi acara kami.',
        );
      }

      // 2. capture QR jadi image
      final file = await captureQrToImage(qrKey, 'qr_${guest!.guestUuid}');

      // 3. share image (user pilih WA)
      await shareQrImage(file: file, guestName: guest!.name);
    } catch (e) {
      print('Error sharing QR: $e');
    }
  }
}
