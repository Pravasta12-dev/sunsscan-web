import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/guest/bloc/guest_session/guest_session_bloc.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/scan/section/guest_scan_in.dart';

import '../../../../../../core/components/custom_dialog.dart';
import '../../../../../../core/helper/barcode/barcode_scanner.dart';
import 'dialog/guest_checkin_success.dart';

class GuestScanTab extends StatefulWidget {
  const GuestScanTab({super.key});

  @override
  State<GuestScanTab> createState() => _GuestScanTabState();
}

class _GuestScanTabState extends State<GuestScanTab> {
  final GlobalKey _loadingKey = GlobalKey();

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
        GuestScanIn.handleBarcodeScan(context, barcode);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GuestSessionBloc, GuestSessionState>(
          listener: (context, stateSession) {
            if (stateSession is GuestSessionChecking) {
              CustomDialog.showLoadingDialog(
                context: context,
                loadingKey: _loadingKey,
              );
            }

            if (stateSession is GuestCheckInSuccess) {
              CustomDialog.hideLoadingDialog(loadingKey: _loadingKey);
              CustomDialog.showMainDialog(
                context: context,
                child: GuestCheckinSuccess(guest: stateSession.guest),
              );
            }

            if (stateSession is GuestCheckOutSuccess) {
              CustomDialog.hideLoadingDialog(loadingKey: _loadingKey);
              CustomDialog.showCustomDialog(
                context: context,
                dialogType: DialogEnum.success,
                title: 'Check-Out Berhasil',
                message: 'Anda berhasil checkout, semoga hari mu menyenangkan!',
              );
            }

            if (stateSession is GuestSessionError) {
              CustomDialog.hideLoadingDialog(loadingKey: _loadingKey);
              CustomDialog.showCustomDialog(
                context: context,
                dialogType: DialogEnum.error,
                title: 'Gagal Scan',
                message: stateSession.message,
              );
            }
          },
        ),
      ],
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

                  Expanded(child: GuestScanIn()),
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
