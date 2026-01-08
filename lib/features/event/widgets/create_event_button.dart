import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/features/event/views/tablet/dialog/event_create_dialog.dart';

import '../../../core/routes/app_transition.dart';
import '../pages/create_event_page.dart';

enum CreateEventButtonType { mobile, tabletUp }

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({
    super.key,
    this.buttonType = CreateEventButtonType.mobile,
  });

  final CreateEventButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = buttonType == CreateEventButtonType.mobile;

    return Container(
      padding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          : EdgeInsets.zero,
      width: isMobile ? double.infinity : 300,
      child: CustomButton(
        onPressed: () {
          if (isMobile) {
            AppTransition.pushTransition(context, const CreateEventPage());
          } else {
            CustomDialog.showMainDialog(
              context: context,
              child: EventCreateDialog(),
            );
          }
        },
        title: 'Tambah Acara',
        buttonType: ButtonType.primary,
      ),
    );
  }
}
