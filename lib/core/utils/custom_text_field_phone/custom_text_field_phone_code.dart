import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/utils/locale_keys.dart';

import 'countries.dart';

class PhoneNumber {
  const PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
  });

  final String countryISOCode;
  final String countryCode;
  final String number;

  String get completeNumber => '$countryCode$number';
}

class CustomTextFieldPhoneCode extends StatefulWidget {
  const CustomTextFieldPhoneCode({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.initialValue,
    this.initialCountryCode,
    this.countries,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.validateFunc,
    this.onChange,
    this.onCountryChanged,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.isRequired = true,
    this.disableLengthCheck = false,
    this.showCountryFlag = true,
    this.showCountryCode = true,
    this.isCountryEditable = true,
    this.egyptIsInitial = false,
    this.invalidNumberMessage,
    this.keyboardType = TextInputType.phone,
    this.textInputAction,
    this.prefixIcon,
    this.borderRadius = 16,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding,
    this.onTap,
  });

  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? initialCountryCode;
  final List<String>? countries;

  final ValueChanged<PhoneNumber>? onChanged;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  final String? Function(String?)? validateFunc;
  final ValueChanged<String>? onChange;
  final ValueChanged<Country2>? onCountryChanged;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool isRequired;
  final bool disableLengthCheck;
  final bool showCountryFlag;
  final bool showCountryCode;
  final bool isCountryEditable;
  final bool egyptIsInitial;

  final String? invalidNumberMessage;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;

  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onTap;

  @override
  State<CustomTextFieldPhoneCode> createState() =>
      _CustomTextFieldPhoneCodeState();
}

class _CustomTextFieldPhoneCodeState extends State<CustomTextFieldPhoneCode> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  late final List<Country2> _countryList;
  late Country2 _selectedCountry;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();

    if (_controller.text.isEmpty && widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _countryList = widget.countries == null
        ? countries
        : countries
            .where((country) => widget.countries!.contains(country.code))
            .toList();

    if (_countryList.isEmpty) {
      _countryList.addAll(countries);
    }

    _selectedCountry = _resolveInitialCountry();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Country2 _resolveInitialCountry() {
    if (widget.egyptIsInitial) {
      return _countryList.firstWhere(
        (item) => item.code == 'EG',
        orElse: () => _countryList.first,
      );
    }

    final raw = (widget.initialCountryCode ?? '').trim();
    if (raw.isNotEmpty) {
      final iso = raw.toUpperCase();
      final byIso = _countryList.where((item) => item.code == iso);
      if (byIso.isNotEmpty) return byIso.first;

      final normalizedDial = raw.replaceAll('+', '');
      final byDial =
          _countryList.where((item) => item.dialCode == normalizedDial);
      if (byDial.isNotEmpty) return byDial.first;
    }

    return _countryList.firstWhere(
      (item) => item.code == 'SA',
      orElse: () => _countryList.first,
    );
  }

  PhoneNumber _buildPhoneNumber(String number) {
    return PhoneNumber(
      countryISOCode: _selectedCountry.code,
      countryCode: '+${_selectedCountry.dialCode}',
      number: number,
    );
  }

  List<TextInputFormatter> _inputFormatters() {
    if (_selectedCountry.code == 'EG') {
      return [FilteringTextInputFormatter.digitsOnly, EgyptPhoneFormatter()];
    }
    return [FilteringTextInputFormatter.digitsOnly];
  }

  String? _validate(String? value) {
    final text = (value ?? '').trim();

    if (widget.isRequired && text.isEmpty) {
      return LocaleKeys.validation_required.tr();
    }
    if (text.isEmpty) {
      return null;
    }

    if (_selectedCountry.code == 'EG' && !text.startsWith('0')) {
      return widget.invalidNumberMessage ??
          LocaleKeys.validation_invalidPhone.tr();
    }

    if (!widget.disableLengthCheck) {
      final validLength = text.length >= _selectedCountry.minLength &&
          text.length <= _selectedCountry.maxLength;
      if (!validLength) {
        return widget.invalidNumberMessage ??
            LocaleKeys.validation_invalidPhone.tr();
      }
    }

    if (widget.validateFunc != null) {
      return widget.validateFunc!(text);
    }

    final customValidation = widget.validator?.call(_buildPhoneNumber(text));
    if (customValidation is String?) {
      return customValidation;
    }

    return null;
  }

  Future<void> _openCountryPicker() async {
    if (!widget.enabled || !widget.isCountryEditable) return;

    final selected = await showModalBottomSheet<Country2>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(
        countries: _countryList,
        selectedCountry: _selectedCountry,
      ),
    );

    if (selected == null || !mounted) return;
    setState(() => _selectedCountry = selected);
    widget.onCountryChanged?.call(selected);

    final currentValue = _controller.text.trim();
    widget.onChanged?.call(_buildPhoneNumber(currentValue));
  }

  @override
  Widget build(BuildContext context) {
    const defaultFillColor = Color(0xFFE7EAE6);
    const defaultBorderColor = Color(0xFFD4D9D3);
    const defaultTextColor = Color(0xFF2C3430);

    final enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: widget.borderColor ?? defaultBorderColor),
    );

    final textField = TextFormField(
      controller: _controller,
      validator: _validate,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: _inputFormatters(),
      maxLength: widget.disableLengthCheck ? null : _selectedCountry.maxLength,
      onChanged: (value) {
        widget.onChange?.call(value);
        widget.onChanged?.call(_buildPhoneNumber(value.trim()));
      },
      onSaved: (value) =>
          widget.onSaved?.call(_buildPhoneNumber((value ?? '').trim())),
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: defaultTextColor,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        counterText: '',
        filled: true,
        fillColor: widget.fillColor ?? defaultFillColor,
        border: enabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color:
                widget.focusedBorderColor ?? AppColors.primaryColor.themeColor,
            width: 1.2,
          ),
        ),
        disabledBorder: enabledBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: AppColors.errorColor.themeColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide:
              BorderSide(color: AppColors.errorColor.themeColor, width: 1.2),
        ),
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        prefixIcon: widget.prefixIcon,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: _CountrySuffix(
          country: _selectedCountry,
          showCountryFlag: widget.showCountryFlag,
          showCountryCode: widget.showCountryCode,
          enabled: widget.enabled && widget.isCountryEditable,
          onTap: _openCountryPicker,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.primaryColor.themeColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: textField,
        ),
      ],
    );
  }
}

class _CountrySuffix extends StatelessWidget {
  const _CountrySuffix({
    required this.country,
    required this.showCountryFlag,
    required this.showCountryCode,
    required this.enabled,
    required this.onTap,
  });

  final Country2 country;
  final bool showCountryFlag;
  final bool showCountryCode;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1,
              height: 24,
              color: const Color(0xFFD4D9D3),
            ),
            const SizedBox(width: 10),
            if (showCountryFlag) ...[
              _CountryFlag(countryCode: country.code, emoji: country.flag),
              const SizedBox(width: 8),
            ],
            if (showCountryCode)
              Text(
                '+${country.dialCode}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
            if (enabled) ...[
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: AppColors.textSecondaryColor.themeColor,
              ),
            ],
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({
    required this.countries,
    required this.selectedCountry,
  });

  final List<Country2> countries;
  final Country2 selectedCountry;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<Country2> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.countries;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filtered = widget.countries);
      return;
    }

    final isArabic = context.locale.languageCode == 'ar';
    setState(() {
      _filtered = widget.countries.where((country) {
        final localizedName = isArabic ? country.nameAr : country.name;
        return localizedName.toLowerCase().contains(query) ||
            country.dialCode.contains(query) ||
            country.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4D9D3),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.common_search.tr(),
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: const Color(0xFFE7EAE6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFD4D9D3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFD4D9D3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor.themeColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color:
                        AppColors.hintColor.themeColor.withValues(alpha: 0.25),
                  ),
                  itemBuilder: (context, index) {
                    final country = _filtered[index];
                    final isSelected =
                        country.code == widget.selectedCountry.code &&
                            country.dialCode == widget.selectedCountry.dialCode;
                    final isArabic = context.locale.languageCode == 'ar';

                    return ListTile(
                      leading: _CountryFlag(
                        countryCode: country.code,
                        emoji: country.flag,
                      ),
                      title: Text(
                        isArabic ? country.nameAr : country.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '+${country.dialCode}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor.themeColor,
                            )
                          : null,
                      onTap: () => Navigator.pop(context, country),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  const _CountryFlag({required this.countryCode, required this.emoji});

  final String countryCode;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        'assets/images/flags/${countryCode.toLowerCase()}.png',
        height: 18,
        width: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Text(
          emoji,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class EgyptPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (text.isEmpty) return newValue;

    if (!text.startsWith('0')) {
      text = '0$text';
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    return newValue;
  }
}
