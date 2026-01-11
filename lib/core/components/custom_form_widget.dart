import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/helper/image_cache_helper.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomFormWidget {
  Widget buildTextFormInput({
    String? label,
    TextEditingController? controller,
    FocusNode? focusNode, // Tambahkan parameter FocusNode
    void Function(String)? onChanged,
    String? initialValue,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    bool isRequired = true,
    TextInputType? keyboardType,
    int? maxLines,
    int? minLines,
    bool? enabled,
    bool? readOnly,
    String? hintText,
    Function()? customAction,
    Color? borderColor,
    Color? focusedBorderColor,
    Widget? prefixIcon,
    Widget? suffix,
    Widget? prefix,
    TextAlign? formTextAlign,
    bool? obscureText,
    EdgeInsetsGeometry? contentPadding,
    Key? key,
    Color? fillColor,
    bool isShowError = true,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              if (prefix != null) prefix,
              if (prefix != null) SizedBox(width: 8),
              Text(
                label,
                textAlign: TextAlign.start,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
        SizedBox(height: 10),
        GestureDetector(
          onTap: customAction,
          child: Stack(
            children: [
              TextFormField(
                key: key,
                enabled: enabled ?? true,
                readOnly: readOnly ?? false,
                controller: controller,
                focusNode: focusNode, // Tambahkan focusNode di sini
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                textAlign: formTextAlign ?? TextAlign.start,
                maxLines: maxLines ?? 1,
                minLines: minLines,
                obscureText: obscureText ?? false,
                initialValue: initialValue,
                onChanged: onChanged,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  focusColor: AppColors.primaryColor,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: hintText ?? 'Masukan $label',
                  prefixIcon: prefixIcon,
                  hintStyle: AppTextStyles.body.copyWith(
                    color: enabled == null || enabled
                        ? AppColors.whiteColor.withAlpha(170)
                        : AppColors.whiteColor,
                  ),
                  filled: true,
                  fillColor: fillColor ?? AppColors.lightGreyColor,
                  labelStyle: AppTextStyles.body,
                  contentPadding:
                      contentPadding ??
                      EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.lightGreyColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Border saat fokus
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: focusedBorderColor ?? AppColors.textSecondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Border saat tidak aktif
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.lightGreyColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Border saat error
                  errorBorder: isShowError
                      ? OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.lightGreyColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),

                  // Border saat error dan fokus
                  focusedErrorBorder: isShowError
                      ? OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),

                  // Disabled border
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: AppColors.greyColor,
                      width: 1.5,
                    ),
                  ),

                  // Tambahkan properti errorStyle
                  errorStyle: isShowError
                      ? null
                      : AppTextStyles.body.copyWith(fontSize: 0),
                ),
                validator:
                    validator ??
                    (val) {
                      if (isRequired && (val == null || val.isEmpty)) {
                        return '$label wajib diisi';
                      }
                      return null;
                    },
              ),
              suffix != null
                  ? Positioned(right: 0, top: 0, bottom: 0, child: suffix)
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDateFormInput(
    DateTime? eventDate,
    Function()? pickDate, {
    required String label,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 10),

        InkWell(
          onTap: pickDate,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.lightGreyColor,
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.whiteColor.withAlpha(170),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.lightGreyColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.lightGreyColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.textSecondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    eventDate == null
                        ? 'Pilih tanggal dan waktu'
                        : DateFormat('dd MMM yyyy, HH:mm').format(eventDate),
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: eventDate == null
                          ? AppColors.whiteColor.withAlpha(170)
                          : AppColors.whiteColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSwitchInput({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.whiteColor,
          activeTrackColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget buildFileFormInput({
    String? label,
    String? hintText,
    String? base64,
    required Function()? onTap,
    required Function()? onRemove,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label,
                textAlign: TextAlign.start,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
        SizedBox(height: 10),
        Row(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  border: Border.all(color: AppColors.whiteColor, width: 0.5),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: base64 != null
                      ? Image.memory(
                          ImageCacheHelper.getImageFromCache(base64)!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Assets.svg.svgProfile.svg(
                            width: 28,
                            height: 28,
                            colorFilter: ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                base64 != null
                    ? 'File terpilih'
                    : (hintText ?? 'Tidak ada file yang dipilih'),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.whiteColor.withAlpha(170),
                ),
              ),
            ),
            SizedBox(width: 16),
            // remove button
            if (base64 != null) ...[
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ],
        ),
      ],
    );
  }

  Widget buildFormSelectFile({String? title, required Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select File',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGreyColor, width: 1.5),
            ),
            child: Row(
              spacing: 10,
              children: [
                Assets.svg.svgUpload.svg(
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                Expanded(
                  child: Text(
                    title ?? 'Pilih File',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDefault({String? hintText, String? label, Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? 'Label',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGreyColor, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hintText ?? 'Hint Text',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor.withAlpha(170),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: AppColors.whiteColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
