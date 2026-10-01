import 'package:flutter/material.dart';

import 'app_text_field.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
    this.height = 48,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      height: height,
      prefixIcon: const Icon(Icons.search_rounded),
    );
  }
}
