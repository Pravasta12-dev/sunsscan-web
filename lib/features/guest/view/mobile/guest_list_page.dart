import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_empty_widget.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_error_widget.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_loading_widget.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/guest_status_badge.dart';

import '../../../../core/routes/app_transition.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../bloc/guest/guest_bloc.dart';
import 'guest_detail_page.dart';

class GuestListPage extends StatefulWidget {
  final String eventId;

  const GuestListPage({super.key, required this.eventId, required this.eventName});
  final String eventName;

  @override
  State<GuestListPage> createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<GuestsModel> _filteredGuests = [];
  List<GuestsModel> _allGuests = [];

  @override
  void initState() {
    super.initState();
    context.read<GuestBloc>().loadGuests(widget.eventId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGuests(List<GuestsModel> guests) {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _allGuests = guests;
      if (keyword.isEmpty) {
        _filteredGuests = guests;
      } else {
        _filteredGuests = guests.where((g) => g.name.toLowerCase().contains(keyword)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tamu', style: AppTextStyles.bodyLarge),
        centerTitle: true,
        leading: InkWell(
          onTap: () => AppTransition.popTransition(context),
          child: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor, size: 12),
        ),
      ),
      body: BlocBuilder<GuestBloc, GuestState>(
        builder: (context, state) {
          if (state is GuestLoading || state is GuestInitial) {
            return GuestLoadingWidget();
          }

          if (state is GuestError) {
            return GuestErrorWidget();
          }

          if (state is GuestLoaded) {
            final guests = state.guests;

            // Update filtered guests ketika data berubah
            if (_allGuests != guests) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _filterGuests(guests);
              });
            }

            if (guests.isEmpty) {
              return GuestEmptyWidget();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<GuestBloc>().loadGuests(widget.eventId);
              },
              child: Column(
                children: [
                  /// SEARCH BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomFormWidget().buildTextFormInput(
                      controller: _searchController,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      hintText: 'Cari Tamu',
                      prefixIcon: Icon(Icons.search),
                      onChanged: (_) => _filterGuests(guests),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// LIST TAMU
                  Expanded(
                    child: _filteredGuests.isEmpty
                        ? GuestEmptyWidget()
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredGuests.length,
                            separatorBuilder: (_, _) => SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final guest = _filteredGuests[index];

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.lightBlackColor,
                                  backgroundImage:
                                      guest.photoPath != null && File(guest.photoPath!).existsSync()
                                      ? FileImage(File(guest.photoPath!))
                                      : null,
                                  child: guest.photoPath == null
                                      ? Assets.svg.svgUser.svg(
                                          width: 24,
                                          height: 24,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(guest.name, style: AppTextStyles.body),
                                subtitle: guest.phone != null
                                    ? Text(guest.phone!, style: AppTextStyles.body)
                                    : null,
                                onTap: () {
                                  AppTransition.pushTransition(
                                    context,
                                    GuestDetailPage(
                                      guest: guest.copyWith(eventName: widget.eventName),
                                    ),
                                  );
                                },
                                trailing: GuestStatusBadge(
                                  isCheckedIn: guest.isCheckedIn,
                                  isCheckedOut: guest.checkedOutAt != null,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: AppColors.lightGreyColor),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
