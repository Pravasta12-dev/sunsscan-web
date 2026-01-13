import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';

import '../../../../../../../core/components/custom_form_widget.dart';
import '../../../../../../../core/enum/enum.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/utils/date_format.dart';
import '../../../../../../../data/model/souvenir_model.dart';
import '../../../../../bloc/souvenir/souvenir_bloc.dart';

class GuestSouvenirTable extends StatefulWidget {
  const GuestSouvenirTable({super.key});

  @override
  State<GuestSouvenirTable> createState() => _GuestSouvenirTableState();
}

class _GuestSouvenirTableState extends State<GuestSouvenirTable> {
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
    return Expanded(
      child: BlocBuilder<SouvenirBloc, SouvenirState>(
        builder: (context, state) {
          if (state is SouvenirLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          }
          if (state is SouvenirError) {
            return Center(child: Text('Error: ${state.message}', style: AppTextStyles.body));
          }

          if (state is SouvenirLoaded) {
            _allSouvenirs = state.souvenirs;
            _filterGuests();
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.headerColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGreyColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                _filteredSouvenirs.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'Tidak ada data souvenir ditemukan',
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      )
                    : Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: DataTable(
                              dataTextStyle: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
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
                                'Actions',
                              ].map((column) => DataColumn(label: Text(column))).toList(),
                              rows: [
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
                                        _buildCheckinStatusBadge(souvenir.checkinStatus == true),
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

                                      DataCell(
                                        Center(child: _buildSouvenirActions(souvenir: souvenir)),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
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

  Widget _buildSouvenirActions({required SouvenirModel souvenir}) {
    final isReceived = souvenir.status == SouvenirStatus.delivered;

    return CustomButton(
      onPressed: () {
        final bloc = context.read<SouvenirBloc>();
        if (isReceived) {
          bloc.updateSouvenir(
            souvenir.copyWith(
              status: SouvenirStatus.pending,
              receivedAt: null,
              syncStatus: SyncStatus.pending,
            ),
          );
        } else {
          bloc.updateSouvenir(
            souvenir.copyWith(
              status: SouvenirStatus.delivered,
              receivedAt: DateTime.now(),
              syncStatus: SyncStatus.pending,
            ),
          );
        }
      },
      title: isReceived ? 'Undo' : 'Mark as Received',
      buttonType: isReceived ? ButtonType.outline : ButtonType.primary,
    );
  }
}
