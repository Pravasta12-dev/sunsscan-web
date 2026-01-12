import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

class GuestGreetingHeader extends StatelessWidget {
  const GuestGreetingHeader({super.key});

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
                'Atur tampilan layar sapa untuk menyambut tamu Anda dengan pesan khusus.',
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
          },
          title: 'Add Content',
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }
}
