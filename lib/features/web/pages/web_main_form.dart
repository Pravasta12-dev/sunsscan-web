import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_button.dart';

import '../../../core/components/custom_form_widget.dart';
import 'web_dashboard.dart';

class WebMainForm extends StatefulWidget {
  const WebMainForm({super.key});

  @override
  State<WebMainForm> createState() => _WebMainFormState();
}

class _WebMainFormState extends State<WebMainForm> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomFormWidget().buildTextFormInput(
            controller: _idController,
            hintText: 'Masukkan ID Event',
            label: 'ID Acara',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebDashboard(eventCode: _idController.text),
                  ),
                );
              },
              title: 'Masuk',
              buttonType: ButtonType.primary,
            ),
          ),
        ],
      ),
    );
  }
}
