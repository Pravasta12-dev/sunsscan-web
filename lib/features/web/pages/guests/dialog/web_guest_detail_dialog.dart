import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/components/custom_button.dart';
import '../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../data/model/guests_model.dart';

class WebGuestDetailDialog extends StatelessWidget {
  const WebGuestDetailDialog({super.key, required this.guest});
  final GuestsModel guest;

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey();

    List<_RowText> infoRows = [
      _RowText(label: 'Name Tamu', value: guest.name),
      _RowText(label: 'WhatsApp', value: guest.phone ?? '-'),
      _RowText(label: 'Jenis Kelamin', value: guest.gender.name.toUpperCase()),
      _RowText(label: 'Tag', value: guest.tag ?? '-'),
      _RowText(
        label: 'Scan Masuk',
        value: guest.checkedInAt != null
            ? CustomDateFormat().getFormattedEventDate(date: guest.checkedInAt!)
            : '-',
      ),
      _RowText(
        label: 'Scan Keluar',
        value: guest.checkedOutAt != null
            ? CustomDateFormat().getFormattedEventDate(date: guest.checkedOutAt!)
            : '-',
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, size: 24, color: AppColors.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(50),
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    guest.guestCategoryName ?? 'No Category',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor.withAlpha(50),
                        border: Border.all(color: AppColors.greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 190,
                      child: Assets.svg.svgUser.svg(
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor.withAlpha(50),
                        border: Border.all(color: AppColors.greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 190,
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
                            data: guest.qrValue,
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
              const SizedBox(height: 16),
              ...infoRows.map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _RowText.buildText(row.label, row.value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              title: 'Tutup',
              buttonType: ButtonType.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _RowText {
  final String label;
  final String value;

  _RowText({required this.label, required this.value});

  static Widget buildText(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.greyColor)),
        ),
        const SizedBox(width: 8),
        Text(value, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
