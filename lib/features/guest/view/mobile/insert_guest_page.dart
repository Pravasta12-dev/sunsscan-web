import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:sun_scan/core/components/custom_dialog.dart';
import 'package:sun_scan/core/components/custom_dropdown.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/components/custom_modal_bottomsheet.dart';
import 'package:sun_scan/core/enum/enum.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/helper/image_picker_helper.dart';
import 'package:sun_scan/data/model/guests_model.dart';
import 'package:sun_scan/features/guest/bloc/guest/guest_bloc.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/select_guest_category.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/routes/app_transition.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/components/custom_button.dart';
import 'insert_guest_success_page.dart';

enum CreateGuestResult { createAnother, backToList }

class GuestInsertPage extends StatefulWidget {
  final String eventId;
  final String eventName;

  final GuestsModel? existingGuest;

  const GuestInsertPage({
    super.key,
    required this.eventId,
    required this.eventName,
    this.existingGuest,
  });

  @override
  State<GuestInsertPage> createState() => _GuestInsertPageState();
}

class _GuestInsertPageState extends State<GuestInsertPage> {
  final _formKey = GlobalKey<FormState>();
  final _loadingKey = GlobalKey<State>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tagController = TextEditingController();
  String? _photoPath;
  bool _isShowingImportDialog = false;

  String? selectedGuestCategoryUuid;
  String? selectedGuestCategoryName;
  Gender selectedGender = Gender.male;

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
      selectedGuestCategoryUuid = widget.existingGuest!.guestCategoryUuid;
      selectedGuestCategoryName = widget.existingGuest!.guestCategoryName;
      selectedGender = widget.existingGuest!.gender;
      _tagController.text = widget.existingGuest!.tag ?? '';
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

  void _submit() async {
    if (!_formKey.currentState!.validate() || !_isValid) return;

    /// 🔥 QR VALUE (sementara auto-generate)

    final qrValue = const Uuid().v4();

    final qrData = 'SUNSCAN|${widget.eventId}|$qrValue';
    debugPrint('Generated QR Data: $qrData');
    debugPrint('Guest Photo Path: $_photoPath');

    final guest = GuestsModel(
      eventUuid: widget.eventId,
      name: _nameController.text.trim(),
      qrValue: qrData,
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),

      createdAt: DateTime.now(),
      tag: _tagController.text.trim().isEmpty ? null : _tagController.text.trim(),
      guestCategoryUuid: selectedGuestCategoryUuid,
      guestCategoryName: selectedGuestCategoryName,
      gender: selectedGender,
    );

    if (widget.existingGuest != null) {
      // Update existing guest
      final updatedGuest = widget.existingGuest!.copyWith(name: guest.name, phone: guest.phone);
      context.read<GuestBloc>().updateGuest(updatedGuest);

      AppTransition.popTransition(context); // Kembali ke guest detail page
    } else {
      // Add new guest
      context.read<GuestBloc>().addGuest(guest);

      final result = await AppTransition.pushTransition<CreateGuestResult>(
        context,
        GuestInsertSuccessPage(guest: guest.copyWith(eventName: widget.eventName)),
      );

      /// =============================
      /// HANDLE INTENT DI SINI
      /// =============================

      if (result == CreateGuestResult.createAnother) {
        _formKey.currentState?.reset();
        _nameController.clear();
        _phoneController.clear();
        _photoPath = null;

        setState(() {
          _isValid = false;
        });
      }

      if (result == CreateGuestResult.backToList) {
        AppTransition.popTransition(context);
      }
    }
  }

  String get _photoFileName {
    if (_photoPath == null) return 'Upload Foto Tamu';
    return p.basename(_photoPath!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuestBloc, GuestState>(
      listener: (context, state) {
        if (state is GuestsImportProgress) {
          // Hanya show dialog sekali saat pertama kali loading
          if (!_isShowingImportDialog) {
            _isShowingImportDialog = true;
            CustomDialog.showMainDialog(
              key: _loadingKey,
              context: context,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'Mengimpor tamu... (${state.current}/${state.total})',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            );
          }
        }

        if (state is GuestsImportSuccess) {
          if (_isShowingImportDialog) {
            CustomDialog.hideLoadingDialog(loadingKey: _loadingKey);
            _isShowingImportDialog = false;
          }

          // Reload guest list

          CustomDialog.showCustomDialog(
            context: context,
            dialogType: DialogEnum.success,
            title: 'Berhasil Mengimpor Tamu',
            message: 'Berhasil mengimpor ${state.importedCount} tamu dari file CSV.',
            onPressed: () {
              AppTransition.popTransition(context); // Tutup dialog success
              AppTransition.popTransition(context); // Kembali ke guest page
              AppTransition.popTransition(context); // Kembali ke guest list
              context.read<GuestBloc>().loadGuests(widget.eventId); // Reload guest list
            },
          );
        }

        if (state is GuestsImportFailure) {
          if (_isShowingImportDialog) {
            CustomDialog.hideLoadingDialog(loadingKey: _loadingKey);
            _isShowingImportDialog = false;
          }

          CustomDialog.showCustomDialog(
            context: context,
            dialogType: DialogEnum.error,
            title: 'Gagal Mengimpor Tamu',
            message: state.message,
            onPressed: () {
              AppTransition.popTransition(context);
              context.read<GuestBloc>().loadGuests(widget.eventId);
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Generate QR', style: AppTextStyles.bodyLarge),
          centerTitle: true,
          leading: InkWell(
            onTap: () => AppTransition.popTransition(context),
            child: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor, size: 12),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  spacing: 24,
                  children: [
                    CustomFormWidget().buildTextFormInput(
                      controller: _nameController,
                      label: 'Nama Tamu',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            await CustomModalBottomSheet.showMain<Map<String, dynamic>>(
                              context,
                              child: SelectGuestCategory(
                                eventUuid: widget.eventId,
                                selectedCategoryUuid: selectedGuestCategoryUuid,
                                selectedCategoryName: selectedGuestCategoryName,
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
                              text: gender.name,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                        final source = await CustomModalBottomSheet.showMain<PickImageSource>(
                          context,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (ImagePickerHelper.canUseCamera())
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
                                    onTap: () => Navigator.pop(context, PickImageSource.camera),
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
                                  title: Text('Pilih dari Galeri', style: AppTextStyles.body),
                                  onTap: () => Navigator.pop(context, PickImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        );

                        if (source == null) return;

                        final photoPath = await ImagePickerHelper.pickAndSave(source: source);

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
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: 'SIMPAN TAMU',
                        buttonType: _isValid ? ButtonType.primary : ButtonType.disable,
                        onPressed: _submit,
                      ),
                    ),

                    /// IMPORT DARI EXCEL
                    if (widget.existingGuest == null)
                      Column(
                        children: [
                          CustomFormWidget().buildFormSelectFile(
                            title: 'IMPORT DARI CSV',
                            onTap: () async {
                              final result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['csv'],
                              );

                              if (result == null || result.files.single.path == null) {
                                return;
                              }

                              final path = result.files.single.path!;

                              context.read<GuestBloc>().importGuests(widget.eventId, path);
                            },
                          ),

                          const SizedBox(height: 12),
                          // banner tips
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlackColor,
                              border: Border.all(color: AppColors.primaryColor.withAlpha(50)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Assets.svg.svgSparkles.svg(
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Tips: Pastikan file CSV memiliki kolom "name", "phone", "gender", dan "category" agar impor berjalan lancar.',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.greyColor,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
