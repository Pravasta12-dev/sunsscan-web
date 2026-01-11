import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/features/guest/view/tablet/dialog/guest_insert_dialaog.dart';

import '../../../../../../../core/components/custom_dialog.dart';

class GuestListHeader extends StatelessWidget {
  const GuestListHeader({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Daftar Tamu',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomButton(
          onPressed: () {
            CustomDialog.showMainDialog(
              context: context,
              child: GuestInsertDialaog(eventId: eventId),
            );
          },
          title: 'Tambah Tamu',
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }
}
