import 'package:flutter/material.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/view/tablet/dialog/section/insert_form.dart';
import 'package:sun_scan/features/guest/view/tablet/dialog/section/insert_result.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GuestInsertDialaog extends StatefulWidget {
  const GuestInsertDialaog({
    super.key,
    required this.eventId,
    this.guestToEdit,
  });

  final String eventId;
  final GuestsModel? guestToEdit;

  @override
  State<GuestInsertDialaog> createState() => _GuestInsertDialaogState();
}

class _GuestInsertDialaogState extends State<GuestInsertDialaog> {
  GuestsModel? guest;
  @override
  void initState() {
    super.initState();
    guest = widget.guestToEdit;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: AppColors.headerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header dengan tombol close
            Container(
              padding: const EdgeInsets.all(16),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Generate QR Code',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: InsertForm(
                      eventId: widget.eventId,
                      existingGuest: widget.guestToEdit,
                      onQrGenerated: (guests) {
                        setState(() {
                          guest = guests;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InsertResult(eventId: widget.eventId, guest: guest),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
