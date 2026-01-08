import 'package:flutter/material.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

class GuestLoadingWidget extends StatelessWidget {
  const GuestLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Memuat data tamu...', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
