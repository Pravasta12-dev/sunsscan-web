import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/data/model/souvenir_model.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/utils/shimmer_box.dart';
import '../../../../../bloc/souvenir/souvenir_bloc.dart';

class GuestSouvenirHeader extends StatelessWidget {
  const GuestSouvenirHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SouvenirBloc, SouvenirState>(
      builder: (context, state) {
        bool isLoading = state is SouvenirLoading;

        if (state is SouvenirError) {
          return Center(
            child: Text('Error: ${state.message}', style: AppTextStyles.body),
          );
        }

        final List<SouvenirModel> souvenirs = (state is SouvenirLoaded)
            ? state.souvenirs
            : [];

        final int totalPreparedSouvenir = souvenirs.length;

        final int distributedSouvenir = souvenirs
            .where((souvenir) => souvenir.status == SouvenirStatus.delivered)
            .length;

        final int remainingSouvenir =
            totalPreparedSouvenir - distributedSouvenir;

        return Row(
          children: [
            _ActionData.buildWidget(
              _ActionData(
                title: 'Total Prepared Souvenir',
                description: 'Semua Souvenir Tersedia',
                assetPath: Assets.svg.svgSpark.path,
                onTap: () {},
                count: totalPreparedSouvenir,
                color: AppColors.primaryColor,
              ),
              isLoading: isLoading,
            ),
            const SizedBox(width: 30),
            _ActionData.buildWidget(
              _ActionData(
                title: 'Distributed Souvenir',
                description:
                    '${distributedSouvenir != 0 ? distributedSouvenir * 100 ~/ totalPreparedSouvenir : 0}% Souvenir Telah Didistribusikan',
                assetPath: Assets.svg.svgCheckCircle.path,
                onTap: () {},
                count: distributedSouvenir,
                color: AppColors.greenColor,
              ),
              isLoading: isLoading,
            ),
            const SizedBox(width: 30),
            _ActionData.buildWidget(
              _ActionData(
                title: 'Remaining Souvenir',
                description: 'Total Souvenir yang Tersisa',
                assetPath: Assets.svg.svgPackage.path,
                onTap: () {},
                count: remainingSouvenir,
                color: AppColors.primaryColor,
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
            Row(
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
                const SizedBox(width: 12),
                isLoading
                    ? const ShimmerBox(width: 120, height: 14)
                    : Expanded(
                        child: Text(
                          data.title,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ],
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
