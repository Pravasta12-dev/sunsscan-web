import 'package:flutter/material.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/theme/app_colors.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../data/model/event_model.dart';
import '../widgets/create_event_form.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key, this.activeEvent});

  final EventModel? activeEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: InkWell(
          onTap: () => AppTransition.popTransition(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
            size: 14,
          ),
        ),
        title: Text('Kembali', style: AppTextStyles.bodyLarge),
      ),
      body: CreateEventForm(activeEvent: activeEvent),
    );
  }
}
