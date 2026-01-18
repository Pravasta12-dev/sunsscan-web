import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/scan/section/guest_scan_in.dart';

import '../../../../../../core/components/custom_dialog.dart';
import '../../../../../../core/helper/barcode/barcode_scanner.dart';
import '../../../../bloc/guest/guest_bloc.dart';
import 'dialog/guest_checkin_success.dart';
import 'section/guest_scan_out.dart';
import 'section/guest_scan_tabbar.dart';

class GuestScanTab extends StatefulWidget {
  const GuestScanTab({super.key});

  @override
  State<GuestScanTab> createState() => _GuestScanTabState();
}

class _GuestScanTabState extends State<GuestScanTab> {
  int selectedIndex = 0;

  BarcodeScanner? _barcodeScanner;

  @override
  void dispose() {
    _barcodeScanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _barcodeScanner = BarcodeScannerFactory.createHidBarcodeScanner(
      onBarcodeScanned: (barcode) {
        if (selectedIndex == 0) {
          GuestScanIn.handleBarcodeScan(context, barcode);
        } else {
          GuestScanOut.handleBarcodeScan(context, barcode);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuestBloc, GuestState>(
      listenWhen: (previous, current) {
        if (current is GuestScanSuccess || current is GuestScanFailure) {
          return previous != current;
        }
        return false;
      },
      listener: (context, stateListener) {
        if (stateListener is GuestScanFailure) {
          setState(() {
            // Reset any state if needed after scan failure
          });
          CustomDialog.showCustomDialog(
            context: context,
            dialogType: DialogEnum.error,
            title: 'Gagal Scan',
            message: stateListener.message,
          );
          return;
        }

        if (stateListener is GuestScanSuccess) {
          setState(() {
            // Reset any state if needed after scan success
          });
          if (selectedIndex == 0) {
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 40),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  GuestScanTabbar(
                    selectedIndex: selectedIndex,
                    onTabChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: const [GuestScanIn(), GuestScanOut()],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_barcodeScanner != null) _barcodeScanner!.build(),
        ],
      ),
    );
  }
}
