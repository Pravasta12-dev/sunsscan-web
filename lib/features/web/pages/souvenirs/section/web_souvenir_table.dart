import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';

import '../../../../../../../core/components/custom_form_widget.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/utils/date_format.dart';
import '../../../../../../../data/model/souvenir_model.dart';
import '../../../../../core/utils/shimmer_box.dart';
import '../../../../guest/bloc/souvenir/souvenir_bloc.dart';

class WebSouvenirTable extends StatefulWidget {
  const WebSouvenirTable({super.key});

  @override
  State<WebSouvenirTable> createState() => _WebSouvenirTableState();
}

class _WebSouvenirTableState extends State<WebSouvenirTable> {
  final TextEditingController _searchController = TextEditingController();
  List<SouvenirModel> _filteredSouvenirs = [];
  List<SouvenirModel> _allSouvenirs = [];

  void _filterGuests() {
    final keyword = _searchController.text.toLowerCase();
    if (keyword.isEmpty) {
      _filteredSouvenirs = _allSouvenirs;
    } else {
      _filteredSouvenirs = _allSouvenirs
          .where((g) => g.guestName!.toLowerCase().contains(keyword))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _filterGuests();
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGuests);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomFormWidget().buildTextFormInput(
                controller: _searchController,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                hintText: 'Cari Tamu',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<SouvenirBloc, SouvenirState>(
          builder: (context, state) {
            bool isLoading = state is SouvenirLoading;

            if (state is SouvenirError) {
              return Center(
                child: Text('Error Souvenir: ${state.message}', style: AppTextStyles.body),
              );
            }

            if (state is SouvenirLoaded) {
              _allSouvenirs = state.souvenirs;
              _filterGuests();
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.headerColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGreyColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _filteredSouvenirs.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada data souvenir ditemukan',
                            style: AppTextStyles.bodyLarge,
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            dataTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w300),
                            headingTextStyle: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            headingRowColor: WidgetStateProperty.all(
                              AppColors.lightGreyColor.withAlpha(20),
                            ),
                            showBottomBorder: false,
                            border: TableBorder.all(
                              color: AppColors.lightGreyColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            columnSpacing: 16,
                            columns: [
                              'Guest Name',
                              'Category',
                              'Attendance Status',
                              'Souvenir Status',
                              'Time Received',
                            ].map((column) => DataColumn(label: Text(column))).toList(),
                            rows: isLoading
                                ? List.generate(5, (index) {
                                    return DataRow(
                                      cells: List.generate(5, (cellIndex) {
                                        return DataCell(ShimmerBox(height: 16, width: 100));
                                      }),
                                    );
                                  })
                                : [
                                    for (final souvenir in _filteredSouvenirs)
                                      DataRow(
                                        cells: [
                                          DataCell(
                                            Row(
                                              children: [
                                                Text(souvenir.guestName ?? '-'),
                                                if (souvenir.guestCategoryName == 'VIP') ...[
                                                  const SizedBox(width: 6),
                                                  Assets.svg.svgCrown.svg(
                                                    width: 16,
                                                    height: 16,
                                                    colorFilter: const ColorFilter.mode(
                                                      AppColors.primaryColor,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: souvenir.guestCategoryName == 'VIP'
                                                    ? AppColors.primaryColor.withAlpha(60)
                                                    : AppColors.purpleColor.withAlpha(60),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                souvenir.guestCategoryName ?? '-',
                                                style: AppTextStyles.caption.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: souvenir.guestCategoryName == 'VIP'
                                                      ? AppColors.primaryColor
                                                      : AppColors.purpleColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            _buildCheckinStatusBadge(
                                              souvenir.checkinStatus == true,
                                            ),
                                          ),
                                          DataCell(_buildSouvenirStatusBadge(souvenir.status)),

                                          DataCell(
                                            Text(
                                              souvenir.receivedAt != null
                                                  ? CustomDateFormat().getFormattedTime(
                                                      date: souvenir.receivedAt!,
                                                    )
                                                  : '-',
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCheckinStatusBadge(bool isCheckedIn) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isCheckedIn ? AppColors.greenColor.withAlpha(30) : AppColors.redColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isCheckedIn ? 'IN' : 'OUT',
        style: AppTextStyles.caption.copyWith(
          color: isCheckedIn ? AppColors.greenColor : AppColors.redColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSouvenirStatusBadge(SouvenirStatus status) {
    Color badgeColor;
    switch (status) {
      case SouvenirStatus.delivered:
        badgeColor = AppColors.primaryColor;
        break;
      case SouvenirStatus.pending:
        badgeColor = AppColors.greyColor;
        break;
      default:
        badgeColor = AppColors.greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.caption.copyWith(color: badgeColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
