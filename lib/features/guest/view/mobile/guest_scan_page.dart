import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import '../../../../core/helper/qr_scan_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/guest/guest_bloc.dart';
import 'guest_scan_success_page.dart';

enum GuestScanResult { scanAgain, finish }

enum GuestScanType { checkIn, checkOut }

class GuestScanPage extends StatefulWidget {
  final String activeEventId;
  final GuestScanType scanType;

  const GuestScanPage({
    super.key,
    required this.activeEventId,
    this.scanType = GuestScanType.checkIn,
  });

  @override
  State<GuestScanPage> createState() => _GuestScanPageState();
}

class _GuestScanPageState extends State<GuestScanPage> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    print('[GuestScanPage] Barcode detected: ${capture.barcodes.length}');

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    print('[GuestScanPage] Raw value: $rawValue');

    if (rawValue == null) return;

    setState(() => _isProcessing = true);

    try {
      final qrValue = QrScanHelper.parse(rawValue);

      if (widget.scanType == GuestScanType.checkIn) {
        print('[GuestScanPage] Scanning for check-in');
        context.read<GuestBloc>().scanCheckIn(qrValue.raw);
      } else {
        print('[GuestScanPage] Scanning for check-out');
        context.read<GuestBloc>().scanCheckOut(qrValue.raw);
      }
    } catch (e) {
      _showError(e.toString());
      _reset();
    }
  }

  void _reset() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isProcessing = false);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Scan QR', style: AppTextStyles.bodyLarge),
        centerTitle: true,
        leading: InkWell(
          onTap: () => AppTransition.popTransition(context),
          child: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor, size: 12),
        ),
      ),
      body: Stack(
        children: [
          BlocListener<GuestBloc, GuestState>(
            listener: (context, state) async {
              if (state is GuestScanSuccess) {
                final result = await AppTransition.pushTransition<GuestScanResult>(
                  context,
                  GuestScanSuccessPage(
                    guestName: state.guest.name,
                    isCheckOut: state.guest.checkedOutAt != null,
                  ),
                );

                if (result == GuestScanResult.scanAgain) {
                  setState(() => _isProcessing = false);
                }

                if (result == GuestScanResult.finish) {
                  // Fetch ulang list guest sebelum pop
                  context.read<GuestBloc>().loadGuests(widget.activeEventId);
                  AppTransition.popTransition(context);
                }
              }

              if (state is GuestScanFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), duration: const Duration(seconds: 2)),
                );

                // Semua error, kembali ke halaman sebelumnya
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    context.read<GuestBloc>().loadGuests(widget.activeEventId);
                    AppTransition.popTransition(context);
                  }
                });
              }
            },
            child: MobileScanner(onDetect: _onDetect),
          ),

          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
