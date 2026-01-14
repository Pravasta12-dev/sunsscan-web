import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/utils/shimmer_box.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/scan/dialog/guest_checkin_success.dart';

import '../../../../../../../core/components/custom_dropdown.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../bloc/guest/guest_bloc.dart';

enum ScanMode { scanIn, scanOut }

class GuestScanTest extends StatefulWidget {
  const GuestScanTest({super.key, required this.scanMode});

  final ScanMode scanMode;

  @override
  State<GuestScanTest> createState() => _GuestScanTestState();
}

class _GuestScanTestState extends State<GuestScanTest> {
  GuestsModel? selectedGuest;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: BlocListener<GuestBloc, GuestState>(
        listener: (context, stateListener) {
          if (stateListener is GuestScanFailure) {
            CustomDialog.showCustomDialog(
              context: context,
              dialogType: DialogEnum.error,
              title: 'Gagal',
              message: stateListener.message,
            );
          }

          if (stateListener is GuestScanSuccess) {
            setState(() {
              selectedGuest = null; // Reset selected guest after scan success
            });
            if (widget.scanMode == ScanMode.scanIn) {
              CustomDialog.showMainDialog(
                context: context,
                child: GuestCheckinSuccess(guest: stateListener.guest),
              );
              return;
            } else {
              CustomDialog.showCustomDialog(
                context: context,
                dialogType: DialogEnum.success,
                title: 'Berhasil Check-Out',
                message:
                    'Tamu ${stateListener.guest.name} berhasil melakukan check-out.',
              );
              return;
            }
          }
        },
        child: BlocBuilder<GuestBloc, GuestState>(
          builder: (context, state) {
            final isLoading = state is GuestLoading;

            if (isLoading) {
              return ShimmerBox(height: 48, width: double.infinity);
            }

            if (state is GuestError) {
              return Text(
                'Terjadi kesalahan saat memuat data tamu.',
                style: AppTextStyles.body.copyWith(color: AppColors.redColor),
              );
            }

            final List<GuestsModel> guests = state is GuestLoaded
                ? state.guests
                : [];

            if (guests.isEmpty) {
              return CustomDropdown().buildDropdown(
                value: null,
                items: [],
                onChanged: (value) {},
              );
            }

            final guestsCheckin = guests
                .where((element) => element.checkedInAt == null)
                .toList();

            final guestsCheckout = guests
                .where(
                  (element) =>
                      element.checkedInAt != null &&
                      element.checkedOutAt == null,
                )
                .toList();

            print('guestsCheckin: ${guestsCheckin.length}');
            print('guestsCheckout: ${guestsCheckout.length}');

            return Column(
              children: [
                CustomDropdown().buildDropdown<GuestsModel>(
                  hint: 'Pilih Tamu',
                  label: widget.scanMode == ScanMode.scanIn
                      ? 'Tamu Check-In'
                      : 'Tamu Check-Out',
                  value: selectedGuest,
                  items:
                      (widget.scanMode == ScanMode.scanIn
                              ? guestsCheckin
                              : guestsCheckout)
                          .map(
                            (guest) => DropdownMenuItem<GuestsModel>(
                              value: guest,
                              child: Text(
                                guest.name,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGuest = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {
                      if (selectedGuest == null) return;

                      final qrValue = selectedGuest!.qrValue;

                      // Lakukan proses check-in atau check-out di sini
                      if (widget.scanMode == ScanMode.scanIn) {
                        print('Check-In untuk tamu: ${selectedGuest!.name}');
                        context.read<GuestBloc>().scanCheckIn(qrValue);
                      } else {
                        print('Check-Out untuk tamu: ${selectedGuest!.name}');
                        context.read<GuestBloc>().scanCheckOut(qrValue);
                      }
                    },
                    title: widget.scanMode == ScanMode.scanIn
                        ? 'Check-In'
                        : 'Check-Out',
                    buttonType: selectedGuest == null
                        ? ButtonType.disable
                        : ButtonType.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
