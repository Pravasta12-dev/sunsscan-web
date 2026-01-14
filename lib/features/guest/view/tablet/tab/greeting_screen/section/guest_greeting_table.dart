import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/utils/shimmer_box.dart';
import 'package:sun_scan/data/model/greeting_screen_model.dart';
import 'package:sun_scan/features/guest/bloc/greeting/greeting_bloc.dart';

import '../../../../../../../core/components/custom_dialog.dart';
import '../../../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../insert_greeting.dart';

class GuestGreetingTable extends StatefulWidget {
  const GuestGreetingTable({super.key});

  @override
  State<GuestGreetingTable> createState() => _GuestGreetingTableState();
}

class _GuestGreetingTableState extends State<GuestGreetingTable> {
  List<GreetingScreenModel> _greetingData = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GreetingBloc, GreetingState>(
        builder: (context, state) {
          bool isLoading = state is GreetingLoadInProgress;

          if (state is GreetingLoadFailure) {
            return Center(
              child: Text(
                'Failed to load greeting data',
                style: AppTextStyles.body.copyWith(color: AppColors.whiteColor),
              ),
            );
          }

          if (state is GreetingLoadSuccess) {
            _greetingData = state.greetingScreens;
          }

          if (_greetingData.isEmpty) {
            return Center(
              child: Text(
                'No greeting data available',
                style: AppTextStyles.body.copyWith(color: AppColors.whiteColor),
              ),
            );
          }

          return SizedBox(
            width: double.infinity,
            child: DataTable(
              dataTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w300),
              headingTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              headingRowColor: WidgetStateProperty.all(AppColors.headerColor),
              showBottomBorder: false,
              border: TableBorder.all(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              columnSpacing: 16,
              columns: ['Name', 'Content', 'Type', 'Added By', 'Actions'].map((e) {
                return DataColumn(headingRowAlignment: MainAxisAlignment.center, label: Text(e));
              }).toList(),
              rows: isLoading
                  ? List.generate(5, (index) {
                      return DataRow(
                        cells: List.generate(5, (cellIndex) {
                          return DataCell(ShimmerBox(height: 16, width: 120));
                        }),
                      );
                    })
                  : List.generate(_greetingData.length, (index) {
                      final greeting = _greetingData[index];

                      final type = greeting.greetingType;
                      bool isImage = type == GreetingType.image;
                      return DataRow(
                        cells: [
                          DataCell(Text(greeting.name)),
                          DataCell(
                            Text(greeting.contentPath.isNotEmpty ? greeting.contentPath : 'N/A'),
                          ),
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isImage
                                        ? AppColors.primaryColor.withAlpha(50)
                                        : AppColors.purpleColor.withAlpha(50),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isImage
                                          ? AppColors.primaryColor
                                          : AppColors.purpleColor,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isImage ? Icons.image : Icons.videocam,
                                        color: isImage
                                            ? AppColors.primaryColor
                                            : AppColors.purpleColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isImage ? 'Image' : 'Video',
                                        style: AppTextStyles.caption.copyWith(
                                          color: isImage
                                              ? AppColors.primaryColor
                                              : AppColors.purpleColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(greeting.addedBy.name)),
                          DataCell(
                            Center(
                              child: Row(
                                spacing: 12,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      CustomDialog.showMainDialog(
                                        context: context,
                                        child: InsertGreeting(
                                          eventUuid: greeting.eventUuid,
                                          existingGreeting: greeting,
                                        ),
                                      );
                                    },
                                    child: Assets.svg.svgPencil.svg(
                                      width: 16,
                                      height: 16,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.whiteColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      CustomDialog.showConfirmationRemoveDialog(
                                        context: context,
                                        title: 'Hapus Gambar/Video',
                                        message:
                                            'Apakah Anda yakin ingin menghapus "${greeting.name}?"\nTindakan ini tidak dapat dibatalkan.',
                                        onConfirmed: () {
                                          context.read<GreetingBloc>().deleteGreeting(
                                            greeting.greetingUuid ?? '',
                                            greeting.eventUuid,
                                          );
                                        },
                                      );
                                    },
                                    child: Assets.svg.svgTrash.svg(
                                      width: 16,
                                      height: 16,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.redColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
            ),
          );
        },
      ),
    );
  }
}
