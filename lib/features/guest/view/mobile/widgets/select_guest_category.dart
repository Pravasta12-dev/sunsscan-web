import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import '../../../bloc/bloc/guest_category_bloc.dart';

class SelectGuestCategory extends StatefulWidget {
  const SelectGuestCategory({
    super.key,
    this.selectedCategoryUuid,
    required this.eventUuid,
    this.selectedCategoryName,
  });

  final String? selectedCategoryUuid;
  final String eventUuid;
  final String? selectedCategoryName;

  @override
  State<SelectGuestCategory> createState() => _SelectGuestCategoryState();
}

class _SelectGuestCategoryState extends State<SelectGuestCategory> {
  final TextEditingController _newCategoryController = TextEditingController();
  String? selectedCategoryUuid;
  String? selectedCategoryName;

  @override
  void initState() {
    super.initState();
    selectedCategoryUuid = widget.selectedCategoryUuid;
    selectedCategoryName = widget.selectedCategoryName;
    _newCategoryController.text = widget.selectedCategoryName ?? '';
    context.read<GuestCategoryBloc>().loadGuestCategories(widget.eventUuid);
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  bool _isFormValid = false;

  void _validateForm() {
    final isValid = _newCategoryController.text.isNotEmpty;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kategori Tamu',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Pilih Kategori Tamu', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 20),
          // Category List
          Flexible(
            child: BlocBuilder<GuestCategoryBloc, GuestCategoryState>(
              builder: (context, state) {
                if (state.status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status.isSuccess) {
                  final categories = state.categories;
                  if (categories.isEmpty) {
                    return const Center(
                      child: Text('Belum ada kategori tamu.'),
                    );
                  }
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: categories.map((category) {
                        final isSelected =
                            category.categoryUuid == selectedCategoryUuid;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoryUuid = category.categoryUuid;
                              selectedCategoryName = category.name;
                              _newCategoryController.text = category.name;
                            });
                            _validateForm();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Radio indicator
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              // Category name
                              Text(
                                category.name,
                                style: AppTextStyles.body.copyWith(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.whiteColor,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else if (state.status.isFailure) {
                  return Center(
                    child: Text(state.errorMessage ?? 'Terjadi kesalahan.'),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          const SizedBox(height: 20.0),
          CustomFormWidget().buildTextFormInput(
            controller: _newCategoryController,
            label: 'Tambah Kategori Baru',
            hintText: 'Masukkan nama kategori baru',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: 'Batal',
                  buttonType: ButtonType.outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    if (!_isFormValid) return;

                    AppTransition.popTransition(
                      context,
                      result: {
                        'uuid': selectedCategoryUuid,
                        'name': _newCategoryController.text.trim(),
                      },
                    );
                  },
                  title: 'Simpan',
                  buttonType: _isFormValid
                      ? ButtonType.primary
                      : ButtonType.disable,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
