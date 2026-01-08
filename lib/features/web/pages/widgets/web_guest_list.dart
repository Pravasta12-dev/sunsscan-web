import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/web/bloc/guest_web/guest_web_bloc.dart';

import '../../../../core/components/custom_form_widget.dart';
import '../../../../core/helper/assets/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/model/guests_model.dart';
import '../../../guest/view/mobile/widgets/guest_empty_widget.dart';
import '../../../guest/view/mobile/widgets/guest_error_widget.dart';
import '../../../guest/view/mobile/widgets/guest_loading_widget.dart';
import '../../../guest/view/mobile/widgets/guest_status_badge.dart';

class WebGuestList extends StatefulWidget {
  const WebGuestList({super.key, required this.eventId});

  final String eventId;

  @override
  State<WebGuestList> createState() => _WebGuestListState();
}

class _WebGuestListState extends State<WebGuestList> {
  final TextEditingController _searchController = TextEditingController();
  List<GuestsModel> _filteredGuests = [];
  List<GuestsModel> _allGuests = [];

  @override
  void initState() {
    super.initState();
    context.read<GuestWebBloc>().fetchGuestsByEventId(widget.eventId);
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
        _filteredGuests = guests
            .where((g) => g.name.toLowerCase().contains(keyword))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestWebBloc, GuestWebState>(
      builder: (context, state) {
        if (state is GuestWebLoading || state is GuestWebInitial) {
          return GuestLoadingWidget();
        }

        if (state is GuestWebError) {
          print(state.message);
          return GuestErrorWidget();
        }

        if (state is GuestWebLoaded) {
          final guests = state.guests;

          // Update filtered guests ketika data berubah
          if (_allGuests != guests) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _filterGuests(guests);
            });
          }

          if (guests.isEmpty) {
            print('no guests ${guests.length}');
            return GuestEmptyWidget();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<GuestWebBloc>().fetchGuestsByEventId(widget.eventId);
            },
            child: Column(
              children: [
                /// SEARCH BAR
                CustomFormWidget().buildTextFormInput(
                  controller: _searchController,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  hintText: 'Cari Tamu',
                  prefixIcon: Icon(Icons.search),
                  onChanged: (_) => _filterGuests(guests),
                ),
                const SizedBox(height: 16),

                /// LIST TAMU
                Expanded(
                  child: _filteredGuests.isEmpty
                      ? GuestEmptyWidget()
                      : ListView.separated(
                          itemCount: _filteredGuests.length,
                          separatorBuilder: (_, _) => SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final guest = _filteredGuests[index];

                            return ListTile(
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    guest.photo != null &&
                                        File(guest.photo!).existsSync()
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
                              title: Text(
                                guest.name,
                                style: AppTextStyles.body,
                              ),
                              subtitle: guest.phone != null
                                  ? Text(
                                      guest.phone!,
                                      style: AppTextStyles.body,
                                    )
                                  : null,
                              onTap: () {},
                              trailing: GuestStatusBadge(
                                isCheckedIn: guest.isCheckedIn,
                                isCheckedOut: guest.checkedOutAt != null,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: AppColors.lightGreyColor,
                                ),
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
    );
  }
}
