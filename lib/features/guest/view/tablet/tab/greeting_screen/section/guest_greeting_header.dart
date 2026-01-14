import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/greeting_screen/insert_greeting.dart';

class GuestGreetingHeader extends StatelessWidget {
  const GuestGreetingHeader({super.key, required this.eventUuid});

  final String eventUuid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Greeting Screen / Layar Sapa',
                style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage content displayed on the greeting screen',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.greyColor.withAlpha(150),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        CustomButton(
          onPressed: () {
            // Handle add content action
            CustomDialog.showMainDialog(
              context: context,
              child: InsertGreeting(eventUuid: eventUuid),
            );
          },
          title: 'Add Content',
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }
}
