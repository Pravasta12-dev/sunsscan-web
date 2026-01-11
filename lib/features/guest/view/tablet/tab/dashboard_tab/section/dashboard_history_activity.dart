import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/core/utils/shimmer_box.dart';

import '../../../../../../../core/helper/assets/assets.gen.dart';
import '../../../../../../../data/model/guests_model.dart';
import '../../../../../bloc/guest/guest_bloc.dart';

class DashboardHistoryActivity extends StatefulWidget {
  const DashboardHistoryActivity({super.key});

  @override
  State<DashboardHistoryActivity> createState() =>
      _DashboardHistoryActivityState();
}

class _DashboardHistoryActivityState extends State<DashboardHistoryActivity> {
  final TextEditingController _searchController = TextEditingController();
  List<GuestsModel> _filteredGuests = [];
  List<GuestsModel> _allGuests = [];

  void _filterGuests() {
    final keyword = _searchController.text.toLowerCase();
    if (keyword.isEmpty) {
      _filteredGuests = _allGuests;
    } else {
      _filteredGuests = _allGuests
          .where(
            (g) =>
                g.name.toLowerCase().contains(keyword) ||
                (g.phone?.toLowerCase().contains(keyword) ?? false),
          )
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.headerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktifiitas Tamu',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CustomFormWidget().buildTextFormInput(
            controller: _searchController,
            hintText: 'Cari Acara...',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          Expanded(
            child: BlocBuilder<GuestBloc, GuestState>(
              builder: (context, state) {
                if (state is GuestError) {
                  return Center(
                    child: Text(
                      'Terjadi kesalahan saat memuat data tamu.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  );
                }

                if (state is GuestLoaded) {
                  _allGuests = state.guests;
                  _filterGuests();
                }

                if (_filteredGuests.isEmpty) {
                  return Center(
                    child: Text(
                      'Tamu tidak ditemukan',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: _filteredGuests.length,
                    itemBuilder: (context, index) {
                      final guest = _filteredGuests[index];
                      return _GuestActivityCard(
                        guest: guest,
                        isLoading: state is GuestLoading,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestActivityCard extends StatelessWidget {
  const _GuestActivityCard({required this.guest, required this.isLoading});

  final GuestsModel guest;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: guest.photo != null && File(guest.photo!).existsSync()
            ? FileImage(File(guest.photo!))
            : null,
        backgroundColor: AppColors.lightBlackColor,
        child: guest.photo == null
            ? Assets.svg.svgUser.svg(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.whiteColor,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
      title: isLoading
          ? ShimmerBox(height: 16, width: 20)
          : Text(guest.name, style: AppTextStyles.body),
      subtitle: guest.phone != null
          ? isLoading
                ? ShimmerBox(height: 14, width: 40)
                : Text(guest.phone!, style: AppTextStyles.body)
          : null,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.lightGreyColor),
      ),
    );
  }
}
