import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/data/model/guests_model.dart';

import '../../../../../../../core/utils/shimmer_box.dart';
import '../../../../../bloc/guest/guest_bloc.dart';

class DashboardActionTab extends StatelessWidget {
  const DashboardActionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestBloc, GuestState>(
      builder: (context, state) {
        bool isLoading = state is GuestLoading;

        if (state is GuestError) {
          return Center(
            child: Text('Error: ${state.message}', style: AppTextStyles.body),
          );
        }

        final List<GuestsModel> guests = (state is GuestLoaded)
            ? state.guests
            : [];

        final int totalGuests = guests.length;
        final int checkedInGuests = guests
            .where((guest) => guest.checkedInAt != null)
            .length;

        final int vipCheckinGuests = guests
            .where(
              (element) =>
                  element.guestCategoryName == 'VIP' &&
                  element.checkedInAt != null,
            )
            .length;

        return Row(
          spacing: 30,
          children: [
            _ActionData.buildWidget(
              _ActionData(
                title: 'Total Tamu Undangan',
                description: 'Semua Tamu Terdaftar',
                assetPath: Assets.svg.svgUsers.path,
                onTap: () {},
                count: guests.length,
                color: AppColors.blueColor,
              ),
              isLoading: isLoading,
            ),
            _ActionData.buildWidget(
              _ActionData(
                title: 'Total Tamu Masuk',
                description:
                    '${checkedInGuests != 0 ? (checkedInGuests / totalGuests * 100).toStringAsFixed(0) : 0}% dari Tamu Terdaftar',
                assetPath: Assets.svg.svgUserCheck.path,
                onTap: () {},
                count: checkedInGuests,
                color: AppColors.greenColor,
              ),
              isLoading: isLoading,
            ),
            _ActionData.buildWidget(
              _ActionData(
                title: 'VIP Masuk',
                description:
                    'dari ${guests.where((element) => element.guestCategoryName == 'VIP').length} Tamu VIP Terdaftar',
                assetPath: Assets.svg.svgSpark.path,
                onTap: () {},
                count: vipCheckinGuests,
                color: AppColors.primaryColor,
              ),
              isLoading: isLoading,
            ),
            _ActionData.buildWidget(
              _ActionData(
                title: 'Tamu Biasa Masuk',
                description:
                    'dari ${guests.where((element) => element.guestCategoryName != 'VIP').length} Tamu Biasa Terdaftar',
                assetPath: Assets.svg.svgProfile.path,
                onTap: () {},
                count: checkedInGuests - vipCheckinGuests,
                color: AppColors.purpleColor,
              ),
              isLoading: isLoading,
            ),
            _ActionData.buildWidget(
              _ActionData(
                title: 'Total Tamu Keluar',
                description: 'Meninggalkan Acara',
                assetPath: Assets.svg.svgLogout.path,
                onTap: () {},
                count: guests
                    .where((guest) => guest.checkedOutAt != null)
                    .length,
                color: AppColors.greyColor,
              ),
              isLoading: isLoading,
            ),
          ],
        );
      },
    );
  }
}

class _ActionData {
  final String title;
  final String description;
  final String assetPath;
  final VoidCallback onTap;
  final int count;
  final Color color;

  _ActionData({
    required this.title,
    required this.description,
    required this.assetPath,
    required this.onTap,
    required this.count,
    required this.color,
  });

  static Widget buildWidget(_ActionData data, {required bool isLoading}) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.headerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 4.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: data.color.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                data.assetPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(data.color, BlendMode.srcIn),
              ),
            ),
            isLoading
                ? const ShimmerBox(width: 60, height: 34)
                : Text(
                    data.count.toString(),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                      fontSize: 30,
                    ),
                  ),
            isLoading
                ? const ShimmerBox(width: 120, height: 14)
                : Text(
                    data.title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            isLoading
                ? const ShimmerBox(width: double.infinity, height: 12)
                : Text(
                    data.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.greyColor.withAlpha(70),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
