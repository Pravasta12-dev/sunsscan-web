import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/utils/date_format.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/view/mobile/guest_detail_page.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_status_badge.dart';
import 'package:sun_scan/features/guest/view/tablet/dialog/guest_insert_dialaog.dart';

import '../../../../../../../core/components/custom_form_widget.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../bloc/guest/guest_bloc.dart';

class GuestListContent extends StatefulWidget {
  const GuestListContent({super.key});

  @override
  State<GuestListContent> createState() => _GuestListContentState();
}

class _GuestListContentState extends State<GuestListContent> {
  List<GuestsModel> _filteredGuests = [];
  List<GuestsModel> _allGuests = [];
  final TextEditingController _searchController = TextEditingController();

  void _filterGuests() {
    final keyword = _searchController.text.toLowerCase();
    if (keyword.isEmpty) {
      _filteredGuests = _allGuests;
    } else {
      _filteredGuests = _allGuests
          .where((g) => g.name.toLowerCase().contains(keyword))
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
      child: BlocBuilder<GuestBloc, GuestState>(
        builder: (context, state) {
          if (state is GuestLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is GuestLoaded) {
            _allGuests = state.guests;
            _filterGuests();
          }

          if (state is GuestError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${state.message}',
                style: AppTextStyles.bodyLarge,
              ),
            );
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        hintText: 'Cari Tamu',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ],
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              columnSpacing: 16,
                              columns:
                                  [
                                        'Nama Tamu',
                                        'No. Whatsapp',
                                        'Kategori Tamu',
                                        'Tag',
                                        'Status',
                                        'Waktu Masuk',
                                        'Waktu Keluar',
                                        'Aksi',
                                      ]
                                      .map(
                                        (column) =>
                                            DataColumn(label: Text(column)),
                                      )
                                      .toList(),
                              rows: [
                                for (final guest in _filteredGuests)
                                  DataRow(
                                    cells: [
                                      DataCell(Text(guest.name)),
                                      DataCell(Text(guest.phone ?? '-')),
                                      DataCell(
                                        Text(guest.guestCategoryName ?? '-'),
                                      ),
                                      DataCell(Text(guest.tag ?? '-')),
                                      DataCell(
                                        GuestStatusBadge(
                                          isCheckedIn: guest.isCheckedIn,
                                          isCheckedOut:
                                              guest.checkedOutAt != null,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          guest.checkedInAt != null
                                              ? CustomDateFormat()
                                                    .getFormattedTime(
                                                      date: guest.checkedInAt!,
                                                    )
                                              : '-',
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          guest.checkedOutAt != null
                                              ? CustomDateFormat()
                                                    .getFormattedTime(
                                                      date: guest.checkedOutAt!,
                                                    )
                                              : '-',
                                        ),
                                      ),

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
                                                    child: GuestDetailPage(
                                                      guest: guest,
                                                    ),
                                                  );
                                                },
                                                child: Assets.svg.svgEye.svg(
                                                  width: 16,
                                                  height: 16,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                        AppColors.whiteColor,
                                                        BlendMode.srcIn,
                                                      ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  CustomDialog.showMainDialog(
                                                    context: context,
                                                    child: GuestInsertDialaog(
                                                      eventId: guest.eventUuid,
                                                      guestToEdit: guest,
                                                    ),
                                                  );
                                                },
                                                child: Assets.svg.svgPencil.svg(
                                                  width: 16,
                                                  height: 16,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                        AppColors.whiteColor,
                                                        BlendMode.srcIn,
                                                      ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  CustomDialog.showConfirmationRemoveDialog(
                                                    context: context,
                                                    title: 'Hapus Tamu',
                                                    message:
                                                        'Apakah Anda yakin ingin menghapus "${guest.name}?"\nTindakan ini tidak dapat dibatalkan.',
                                                    onConfirmed: () {
                                                      context
                                                          .read<GuestBloc>()
                                                          .deleteGuest(
                                                            guest.guestUuid ??
                                                                '',
                                                            guest.eventUuid,
                                                          );
                                                    },
                                                  );
                                                },
                                                child: Assets.svg.svgTrash.svg(
                                                  width: 16,
                                                  height: 16,
                                                  colorFilter:
                                                      const ColorFilter.mode(
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
}
