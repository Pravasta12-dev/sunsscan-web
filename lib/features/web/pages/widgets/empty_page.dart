import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

enum EmptyPageType { noData, noInternet, error }

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, required this.type, this.onRetry, this.errorMessage});

  final EmptyPageType type;
  final Function(EmptyPageType type)? onRetry;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    String message;
    switch (type) {
      case EmptyPageType.noData:
        message = errorMessage ?? 'No data available.';
        break;
      case EmptyPageType.noInternet:
        message = errorMessage ?? 'No internet connection.';
        break;
      case EmptyPageType.error:
        message = errorMessage ?? 'An unexpected error occurred.';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 32.0),
            decoration: BoxDecoration(
              color: AppColors.headerColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.lightGreyColor),
            ),
            child: Column(
              children: [
                Image.asset(Assets.images.logoSun.path, width: 70, height: 70),
                const SizedBox(height: 16),
                Text(
                  'Terjadi Kesalahan',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(message, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                if (onRetry != null) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () => onRetry!(type),
                      title: 'Retry',
                      buttonType: ButtonType.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () => Navigator.pop(context),
                      title: 'Kembali',
                      buttonType: ButtonType.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
