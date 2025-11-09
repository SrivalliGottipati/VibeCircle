import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class MultiLineField extends StatelessWidget {
  const MultiLineField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
    required this.maxWords,
  });

  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final int maxWords;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value)
      ..selection = TextSelection.collapsed(offset: value.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          minLines: 6,
          maxLines: 12,
          maxLength: maxWords,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Txt.body.copyWith(color: AppColors.text3),
            filled: true,
            fillColor: AppColors.surfaceWhite1,
            contentPadding: const EdgeInsets.all(18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primaryAccent),
            ),
          ),
          style: Txt.body.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}
