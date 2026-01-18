import 'dart:convert';
import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/helper/image_picker_helper.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/datasource/local/guest_photo_local_datasource.dart';
import 'package:sun_scan/data/datasource/local/souvenir_local_datasource.dart';
import 'package:sun_scan/data/model/guest_photo_model.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/bloc/guest/guest_bloc.dart';
import 'package:sun_scan/features/guest/bloc/souvenir/souvenir_bloc.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/scan/dialog/camera_external_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../core/sync/sync_dispatcher.dart';

class GuestCheckinSuccess extends StatefulWidget {
  const GuestCheckinSuccess({super.key, required this.guest});

  final GuestsModel guest;

  @override
  State<GuestCheckinSuccess> createState() => _GuestCheckinSuccessState();
}

class _GuestCheckinSuccessState extends State<GuestCheckinSuccess> {
  final GlobalKey qrKey = GlobalKey();

  bool _hasSouvenirReceived = false;

  String? _photoPath;

  @override
  Widget build(BuildContext context) {
    bool isCheckedIn = widget.guest.isCheckedIn;
    bool isVip = widget.guest.guestCategoryName == 'VIP';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.headerColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGreyColor, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  'Scan ${isCheckedIn ? 'Masuk' : 'Keluar'} Berhasil',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                isVip
                    ? Assets.svg.svgVip.svg(width: 280, height: 207)
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.greenColor.withAlpha(30),
                          border: Border.all(
                            color: AppColors.greenColor,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Tamu Biasa',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.greenColor,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final base64 = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const CameraExternalDialog(),
                            );

                            if (base64 != null) {
                              final path = await saveCapturedPhoto(base64);
                              setState(() {
                                _photoPath = path;
                              });
                            }
                          },
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreyColor.withAlpha(50),
                              border: Border.all(
                                color: AppColors.lightBlackColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                _photoPath != null &&
                                    File(_photoPath!).existsSync()
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_photoPath!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.camera_alt_outlined,
                                    size: 60,
                                    color: AppColors.lightGreyColor,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Container(
                          width: 180,

                          decoration: BoxDecoration(
                            color: AppColors.lightGreyColor.withAlpha(50),
                            border: Border.all(
                              color: AppColors.lightBlackColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 180,
                          child: RepaintBoundary(
                            key: qrKey,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: BarcodeWidget(
                                barcode: Barcode.qrCode(),
                                data: widget.guest.qrValue,
                                width: 150,
                                height: 150,
                                drawText: false,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Terima kasih telah menghadiri acara kami, ${widget.guest.name}!',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGreyColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.guest.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.guest.phone ?? '-',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGreyColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isCheckedIn
                      ? 'Scan Masuk: ${CustomDateFormat().getFormattedEventDate(date: widget.guest.checkedInAt!)}'
                      : 'Waktu Check-Out: ${CustomDateFormat().getFormattedEventDate(date: widget.guest.checkedOutAt!)}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGreyColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox.adaptive(
                      value: _hasSouvenirReceived,
                      onChanged: (value) {
                        setState(() {
                          _hasSouvenirReceived = value ?? false;
                        });
                      },
                      activeColor: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tamu telah menerima Souvenir',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGreyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {},
                        title: 'Tambahkan Selfie',
                        buttonType: ButtonType.outline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        onPressed: () async {
                          final souvenirLocalDataSource =
                              SouvenirLocalDataSource.create();
                          final guestPhotoLocalDataSource =
                              GuestPhotoLocalDatasource.create();
                          if (_hasSouvenirReceived) {
                            // Here you can handle the logic to mark souvenir as received
                            await souvenirLocalDataSource
                                .markSouvenirToReceivedByGuestUuid(
                                  widget.guest.guestUuid ?? '',
                                  DateTime.now(),
                                );
                            SyncDispatcher.onLocalChange();
                          }

                          if (_photoPath != null) {
                            final file = File(_photoPath!);
                            final fileName = _photoPath!.split('/').last;
                            final fileSize = await file.length();

                            await guestPhotoLocalDataSource.insertPhoto(
                              GuestPhotoModel(
                                photoUuid: const Uuid().v4(),
                                guestUuid: widget.guest.guestUuid ?? '',
                                eventUuid: widget.guest.eventUuid,
                                photoType: PhotoType.checkIn,
                                fileName: fileName,
                                filePath: _photoPath!,
                                fileSize: fileSize,
                                mimeType: 'image/jpeg',
                                source: PickImageSource.camera,
                                isPrimary: false,
                                createdAt: DateTime.now(),
                              ),
                            );
                            SyncDispatcher.onLocalChange();
                          }

                          Navigator.of(context).pop();
                          context.read<GuestBloc>().loadGuests(
                            widget.guest.eventUuid,
                          );
                          context.read<SouvenirBloc>().loadSouvenirs(
                            widget.guest.eventUuid,
                          );
                        },
                        title: 'Selesai',
                        buttonType: ButtonType.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> saveCapturedPhoto(String base64) async {
    final bytes = base64Decode(base64.split(',').last);

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/guest_photos');
    await folder.create(recursive: true);

    final file = File(
      '${folder.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes);

    return file.path;
  }
}
