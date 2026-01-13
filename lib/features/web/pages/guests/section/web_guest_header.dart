import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import '../../../../../core/components/custom_dialog.dart';
import '../../../../guest/view/tablet/dialog/guest_insert_dialaog.dart';

class WebGuestHeader extends StatelessWidget {
  const WebGuestHeader({super.key, required this.eventId, required this.eventName});

  final String eventId;
  final String eventName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Daftar Tamu',
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500, fontSize: 24),
          ),
        ),
        CustomButton(
          onPressed: () {
            CustomDialog.showMainDialog(
              context: context,
              child: GuestInsertDialaog(eventId: eventId, eventName: eventName),
            );
          },
          title: 'Tambah Tamu',
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }
}
