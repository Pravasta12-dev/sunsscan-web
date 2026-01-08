import 'package:flutter/material.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/routes/app_transition.dart';
import 'guest_scan_page.dart';

class GuestScanSuccessPage extends StatelessWidget {
  final String guestName;
  final bool isCheckOut;

  const GuestScanSuccessPage({
    super.key,
    required this.guestName,
    this.isCheckOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// =====================
              /// ICON SUCCESS
              /// =====================
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isCheckOut ? AppColors.redColor : AppColors.greenColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCheckOut ? Icons.waving_hand : Icons.check,
                  size: 64,
                  color: AppColors.whiteColor,
                ),
              ),

              const SizedBox(height: 32),

              /// =====================
              /// TEXT
              /// =====================
              Text(
                isCheckOut ? 'Terima Kasih' : 'Selamat Datang',
                style: AppTextStyles.bodyLarge,
              ),

              const SizedBox(height: 8),

              Text(
                guestName,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 64),

              /// =====================
              /// BUTTON
              /// =====================
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: 'Lanjut Scan',
                  buttonType: ButtonType.primary,
                  onPressed: () {
                    AppTransition.popTransition(
                      context,
                      result: GuestScanResult.scanAgain,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: 'Selesai',
                  buttonType: ButtonType.primary,
                  onPressed: () {
                    AppTransition.popTransition(
                      context,
                      result: GuestScanResult.finish,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
