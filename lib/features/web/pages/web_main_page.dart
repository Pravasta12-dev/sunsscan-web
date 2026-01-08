import 'package:flutter/material.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import 'widgets/web_main_page_form.dart';

class WebMainPage extends StatelessWidget {
  const WebMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.blackColor,
              AppColors.blackColor,
              AppColors.primaryColor,
              AppColors.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk dengan ID Event anda untuk melanjutkan',
              style: AppTextStyles.body.copyWith(
                color: AppColors.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const WebMainPageForm(),
          ],
        ),
      ),
    );
  }
}
