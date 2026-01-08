import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/view/mobile/guest_detail_page.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_status_badge.dart';

import '../../../../../core/components/custom_form_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GuestTabletContentBottom extends StatefulWidget {
  const GuestTabletContentBottom({super.key, required this.guests});

  final List<GuestsModel> guests;

  @override
  State<GuestTabletContentBottom> createState() =>
      _GuestTabletContentBottomState();
}

class _GuestTabletContentBottomState extends State<GuestTabletContentBottom> {
  List<GuestsModel> _filteredGuests = [];
  final TextEditingController _searchController = TextEditingController();

  void _filterGuests() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredGuests = widget.guests
          .where((g) => g.name.toLowerCase().contains(keyword))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredGuests = widget.guests;
    _searchController.addListener(_filterGuests);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGuests);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlackColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daftar Tamu', style: AppTextStyles.bodyLarge),
          CustomFormWidget().buildTextFormInput(
            controller: _searchController,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            hintText: 'Cari Tamu',
            prefixIcon: Icon(Icons.search),
            onChanged: (_) => _filterGuests(),
          ),
          const SizedBox(height: 16),
          _filteredGuests.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'Tamu tidak ditemukan',
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                )
              : Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      dataTextStyle: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                      headingTextStyle: AppTextStyles.bodyLarge.copyWith(
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
                      columnSpacing: 16,
                      columns:
                          [
                                'Nama Tamu',
                                'No. Telepon',
                                'Jam Masuk',
                                'Jam Keluar',
                                'Status',
                                'Aksi',
                              ]
                              .map((column) => DataColumn(label: Text(column)))
                              .toList(),
                      rows: [
                        for (final guest in _filteredGuests)
                          DataRow(
                            cells: [
                              DataCell(Text(guest.name)),
                              DataCell(Text(guest.phone ?? '-')),
                              DataCell(
                                Text(
                                  guest.checkedInAt != null
                                      ? CustomDateFormat().getFormattedTime(
                                          date: guest.checkedInAt!,
                                        )
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  guest.checkedOutAt != null
                                      ? CustomDateFormat().getFormattedTime(
                                          date: guest.checkedOutAt!,
                                        )
                                      : '-',
                                ),
                              ),
                              DataCell(
                                GuestStatusBadge(
                                  isCheckedIn: guest.isCheckedIn,
                                  isCheckedOut: guest.checkedOutAt != null,
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      CustomDialog.showMainDialog(
                                        context: context,
                                        child: GuestDetailPage(guest: guest),
                                      );
                                    },
                                    child: Assets.svg.svgEye.svg(
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
