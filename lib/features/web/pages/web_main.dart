import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/features/web/pages/web_main_form.dart';

class WebMain extends StatelessWidget {
  const WebMain({super.key});

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
            Container(
              width: 500,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.lightBlackColor,
                border: Border.all(color: AppColors.lightGreyColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Image.asset(Assets.images.logoSun.path, width: 100, height: 100),
                  const SizedBox(height: 16),
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
                  const WebMainForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
