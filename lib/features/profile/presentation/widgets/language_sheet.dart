import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/option_tile.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  Future<void> _set(BuildContext context, String code) async {
    await getIt<LocalStorage>().setLang(code);
    if (!context.mounted) return;
    await context.setLocale(Locale(code));
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.settings_languageTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 10.h),
        OptionTile(
          leading: AppEmojis.egypt,
          title: LocaleKeys.settings_arabic.tr(),
          selected: current == 'ar',
          onTap: () => _set(context, 'ar'),
        ),
        OptionTile(
          leading: AppEmojis.globe,
          title: LocaleKeys.settings_english.tr(),
          selected: current == 'en',
          onTap: () => _set(context, 'en'),
        ),
      ],
    );
  }
}
