import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/components/custom_button.dart';
import '../../../../../../core/components/custom_dropdown.dart';
import '../../../../../../core/components/custom_form_widget.dart';
import '../../../../../../core/enum/enum.dart';
import '../../../../../../core/helper/image_picker_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../data/model/guests_model.dart';
import '../../../../bloc/guest/guest_bloc.dart';
import '../../../mobile/widgets/select_guest_category.dart';

class InsertForm extends StatefulWidget {
  const InsertForm({
    super.key,
    this.existingGuest,
    required this.eventId,
    this.onQrGenerated,
  });

  final GuestsModel? existingGuest;
  final String eventId;
  final Function(GuestsModel)? onQrGenerated;

  @override
  State<InsertForm> createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tagController = TextEditingController();
  String? _photoPath;

  String? selectedGuestCategoryUuid;
  String? selectedGuestCategoryName;
  Gender selectedGender = Gender.male;

  String qrCode = '';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingGuest != null) {
      _nameController.text = widget.existingGuest!.name;
      _phoneController.text = widget.existingGuest!.phone ?? '';
      _photoPath = widget.existingGuest!.photo;
      selectedGuestCategoryUuid = widget.existingGuest!.guestCategoryUuid;
      selectedGuestCategoryName = widget.existingGuest!.guestCategoryName;
      selectedGender = widget.existingGuest!.gender;
      _tagController.text = widget.existingGuest!.tag ?? '';
      qrCode = widget.existingGuest!.qrValue;
    }
  }

  bool _isValid = false;

  void _validateForm() {
    final isValid =
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        selectedGuestCategoryName != null &&
        _tagController.text.isNotEmpty;

    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  String get _photoFileName {
    if (_photoPath == null) return 'Upload Foto Tamu';
    return p.basename(_photoPath!);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || !_isValid) return;

    final qrValue = const Uuid().v4();

    final qrData = 'SUNSCAN|${widget.eventId}|$qrValue';
    debugPrint('Generated QR Data: $qrData');
    debugPrint('Guest Photo Path: $_photoPath');

    final guest = GuestsModel(
      eventUuid: widget.eventId,
      name: _nameController.text.trim(),
      qrValue: qrData,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      isCheckedIn: false,
      createdAt: DateTime.now(),
      tag: _tagController.text.trim().isEmpty
          ? null
          : _tagController.text.trim(),
      photo: _photoPath,
      guestCategoryUuid: selectedGuestCategoryUuid,
      guestCategoryName: selectedGuestCategoryName,
      gender: selectedGender,
    );

    if (widget.existingGuest != null) {
      // Update existing guest
      final updatedGuest = widget.existingGuest!.copyWith(
        name: guest.name,
        phone: guest.phone,
        photo: guest.photo,
        qrValue: qrCode,
      );
      context.read<GuestBloc>().updateGuest(updatedGuest);
      if (widget.onQrGenerated != null) {
        widget.onQrGenerated!(updatedGuest);
      }
    } else {
      // Add new guests
      context.read<GuestBloc>().addGuest(guest);
      if (widget.onQrGenerated != null) {
        widget.onQrGenerated!(guest);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            'Buat kode QR untuk Tamu Baru',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyColor.withAlpha(80),
            ),
          ),
          CustomFormWidget().buildTextFormInput(
            controller: _nameController,
            label: 'Nama Tamu',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            hintText: 'Contoh: Agnes Jennifer',
            onChanged: (_) => _validateForm(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama tamu wajib diisi';
              }
              return null;
            },
          ),

          /// NO WA
          CustomFormWidget().buildTextFormInput(
            controller: _phoneController,
            label: 'No. WhatsApp',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            hintText: 'Contoh: 081234567890',
            keyboardType: TextInputType.phone,
            onChanged: (_) => _validateForm(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'No. WhatsApp wajib diisi';
              }
              return null;
            },
          ),

          /// KATEGORI TAMU
          CustomFormWidget().buildDefault(
            hintText: selectedGuestCategoryName ?? 'Pilih Kategori Tamu',
            label: 'Kategori Tamu',
            onTap: () async {
              // open bottomsheet
              final selectedCategory =
                  await CustomDialog.showMainDialog<Map<String, dynamic>>(
                    context: context,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.headerColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectGuestCategory(
                        eventUuid: widget.eventId,
                        selectedCategoryUuid: selectedGuestCategoryUuid,
                        selectedCategoryName: selectedGuestCategoryName,
                      ),
                    ),
                  );

              if (selectedCategory != null) {
                setState(() {
                  selectedGuestCategoryUuid = selectedCategory['uuid'];
                  selectedGuestCategoryName = selectedCategory['name'];
                });

                _validateForm();
              }
            },
          ),

          /// SELECT GENDER
          CustomDropdown().buildDropdown<Gender>(
            label: 'Jenis Kelamin',
            hint: 'Pilih Jenis Kelamin',
            items: Gender.values
                .map(
                  (gender) => CustomDropdown.buildMenuItem<Gender>(
                    value: gender,
                    text: gender.name.toUpperCase(),
                  ),
                )
                .toList(),
            value: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });

              _validateForm();
            },
          ),

          CustomFormWidget().buildTextFormInput(
            controller: _tagController,
            label: 'Tag',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            hintText: 'Contoh: Tamu dari mempelai Pria',
            keyboardType: TextInputType.text,
            onChanged: (_) => _validateForm(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tag wajib diisi';
              }
              return null;
            },
          ),

          /// FOTO TAMU (Opsional)
          CustomFormWidget().buildFormSelectFile(
            title: _photoFileName,
            onTap: () async {
              final source = await CustomDialog.showMainDialog(
                context: context,
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.headerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Assets.svg.svgCamera.svg(
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text('Ambil Foto', style: AppTextStyles.body),
                        onTap: () => Navigator.pop(context, ImageSource.camera),
                      ),
                      ListTile(
                        leading: Assets.svg.svgImage.svg(
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text(
                          'Pilih dari Galeri',
                          style: AppTextStyles.body,
                        ),
                        onTap: () =>
                            Navigator.pop(context, ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              );

              if (source == null) return;

              final photoPath = await ImagePickerHelper.pickAndSaveImage(
                source: source,
              );

              if (photoPath != null) {
                setState(() {
                  _photoPath = photoPath;
                });
                // Validate form in case photo is required in future
                _validateForm();
              }
            },
          ),

          const SizedBox(),

          /// BUTTON SIMPAN
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'Reset Form',
                  buttonType: ButtonType.outline,
                  onPressed: () {
                    _formKey.currentState?.reset();
                    setState(() {
                      _nameController.clear();
                      _phoneController.clear();
                      _photoPath = null;
                      selectedGuestCategoryName = null;
                      selectedGuestCategoryUuid = null;
                      _tagController.clear();
                    });
                    _validateForm();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  title: 'Generate QR',
                  buttonType: _isValid
                      ? ButtonType.primary
                      : ButtonType.disable,
                  onPressed: () {
                    if (_isValid) {
                      _submit();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
