import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/utils/shimmer_box.dart';
import 'package:sun_scan/features/web/bloc/guest_web/guest_web_bloc.dart';
import 'package:sun_scan/features/web/pages/guests/dialog/web_guest_detail_dialog.dart';

import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/components/custom_form_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../data/model/guests_model.dart';
import '../../../../guest/view/mobile/widgets/guest_status_badge.dart';
import '../../../../guest/view/tablet/dialog/guest_insert_dialaog.dart';

class WebGuestTable extends StatefulWidget {
  const WebGuestTable({super.key});

  @override
  State<WebGuestTable> createState() => _WebGuestTableState();
}

class _WebGuestTableState extends State<WebGuestTable> {
  final TextEditingController _searchController = TextEditingController();
  List<GuestsModel> _filteredGuests = [];
  List<GuestsModel> _allGuests = [];

  void _filterGuests() {
    final keyword = _searchController.text.toLowerCase();
    if (keyword.isEmpty) {
      _filteredGuests = _allGuests;
    } else {
      _filteredGuests = _allGuests.where((g) => g.name.toLowerCase().contains(keyword)).toList();
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
        BlocBuilder<GuestWebBloc, GuestWebState>(
          builder: (context, state) {
            bool isLoading = state is GuestWebLoading;

            if (state is GuestWebError) {
              return Center(
                child: Text(
                  'Error loading guests: ${state.message}',
                  style: AppTextStyles.bodyLarge,
                ),
              );
            }

            if (state is GuestWebLoaded) {
              _allGuests = state.guests;
              _filterGuests();
            }

            return SizedBox(
              width: double.infinity,
              child: _filteredGuests.isEmpty
                  ? Center(child: Text('Tidak ada data tamu', style: AppTextStyles.bodyLarge))
                  : DataTable(
                      dataTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w300),
                      headingTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
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
                      columns:
                          [
                            'Nama Tamu',
                            'WhatsApp',
                            'Kategori Tamu',
                            'Tag',
                            'Status',
                            'Waktu Masuk',
                            'Waktu Keluar',
                            'Aksi',
                          ].map((e) {
                            return DataColumn(
                              label: Text(
                                e,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                      rows: isLoading
                          ? List.generate(5, (index) {
                              return DataRow(
                                cells: List.generate(8, (cellIndex) {
                                  return DataCell(ShimmerBox(height: 16, width: 100));
                                }),
                              );
                            })
                          : [
                              for (final guest in _filteredGuests)
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(guest.name),
                                          if (guest.guestCategoryName == 'VIP') ...[
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
                                    DataCell(Text(guest.phone ?? '-')),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: guest.guestCategoryName == 'VIP'
                                              ? AppColors.primaryColor.withAlpha(60)
                                              : AppColors.purpleColor.withAlpha(60),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          guest.guestCategoryName ?? '-',
                                          style: AppTextStyles.caption.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: guest.guestCategoryName == 'VIP'
                                                ? AppColors.primaryColor
                                                : AppColors.purpleColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(guest.tag ?? '-')),
                                    DataCell(
                                      GuestStatusBadge(
                                        isCheckedIn: guest.isCheckedIn,
                                        isCheckedOut: guest.checkedOutAt != null,
                                      ),
                                    ),
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
                                      Center(
                                        child: Row(
                                          spacing: 12,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                CustomDialog.showMainDialog(
                                                  context: context,
                                                  child: Container(
                                                    width: 600,
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 24,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.headerColor,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: AppColors.lightGreyColor,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        WebGuestDetailDialog(guest: guest),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Assets.svg.svgEye.svg(
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
                                                CustomDialog.showMainDialog(
                                                  context: context,
                                                  child: GuestInsertDialaog(
                                                    eventId: guest.eventUuid,
                                                    guestToEdit: guest,
                                                    eventName: guest.eventName ?? '-',
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
                                                  title: 'Hapus Tamu',
                                                  message:
                                                      'Apakah Anda yakin ingin menghapus "${guest.name}?"\nTindakan ini tidak dapat dibatalkan.',
                                                  onConfirmed: () {
                                                    context.read<GuestWebBloc>().deleteGuest(
                                                      guest.guestUuid ?? '',
                                                      guest.eventUuid,
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
                                ),
                            ],
                    ),
            );
          },
        ),
      ],
    );
  }
}
