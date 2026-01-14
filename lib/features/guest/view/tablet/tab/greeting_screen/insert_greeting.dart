import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/data/model/greeting_screen_model.dart';
import 'package:sun_scan/features/guest/bloc/greeting/greeting_bloc.dart';

import '../../../../../../core/theme/app_colors.dart';

class InsertGreeting extends StatefulWidget {
  const InsertGreeting({super.key, required this.eventUuid, this.existingGreeting});

  final String eventUuid;
  final GreetingScreenModel? existingGreeting;

  @override
  State<InsertGreeting> createState() => _InsertGreetingState();
}

class _InsertGreetingState extends State<InsertGreeting> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();

  GreetingAddingBy _addingBy = GreetingAddingBy.admin;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingGreeting != null) {
      _contentController.text = widget.existingGreeting!.name;
      _addingBy = widget.existingGreeting!.addedBy;
      isEdit = true;
    }
  }

  bool _isFormValid = false;

  void _validateForm() {
    final isValid = _contentController.text.isNotEmpty;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: AppColors.headerColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGreyColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? 'Update Content' : 'Add New Content',
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'All content added here is for documentation purposes only.',
                    style: AppTextStyles.body.copyWith(color: AppColors.textGreyColor),
                  ),
                  const SizedBox(height: 24),
                  CustomFormWidget().buildTextFormInput(
                    controller: _contentController,
                    label: 'Content Name',
                    hintText: 'Enter content name here',
                    onChanged: (_) => _validateForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Content name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {},
                          title: 'Image',
                          buttonType: ButtonType.outline,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {},
                          title: 'Video',
                          buttonType: ButtonType.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            if (_isFormValid) {
                              _submit();
                            }
                          },
                          title: isEdit ? 'Update' : 'Add',
                          buttonType: _isFormValid ? ButtonType.primary : ButtonType.disable,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          title: 'Cancel',
                          buttonType: ButtonType.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final data = GreetingScreenModel(
      greetingUuid: widget.existingGreeting?.greetingUuid ?? '',
      eventUuid: widget.eventUuid,
      greetingType: GreetingType.image,
      name: _contentController.text,
      contentPath: '',
      addedBy: _addingBy,
      createdAt: DateTime.now(),
    );

    if (widget.existingGreeting != null) {
      context.read<GreetingBloc>().updateGreeting(data);
    } else {
      context.read<GreetingBloc>().addGreeting(data);
    }
    Navigator.of(context).pop();
  }
}
