import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:math' as math;

import '../../../../shared/constant/assets_manager.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/language_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../../shared/style/theme_manager.dart';
import '../../../di/di.dart';
import '../../../router/app_router.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  bool isTwoSwitched = false;

  final ThemeManager _themeManager = sl<ThemeManager>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.darkPrimary,
        elevation: 0,
        leading: Padding(
            padding:
                const EdgeInsets.fromLTRB(AppPadding.p8, AppPadding.p8, 0, 0),
            child: Bounceable(
              duration: Duration(milliseconds: AppConstants.durationOfBounceable),
              onTap: () async {
                await Future.delayed(
                    Duration(milliseconds: AppConstants.durationOfDelay));
                Navigator.of(context).pop();
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
                },
                child: const Icon(Icons.keyboard_return),
              ),
            )),
        title: Text(
          AppStrings.settings.tr(),
          style: TextStyle(fontSize: AppSize.s25.sp),
        ),
      ),
      body: bodyContent(),
    ));
  }

  Widget bodyContent() {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          ListTile(
            leading: SvgPicture.asset(
              ImageAssets.changeLangIc,
              color: ColorManager.darkPrimary,
              width: AppSize.s40,
            ),
            title: Text(AppStrings.changeLang.tr(),
                style: TextStyle(fontSize: AppSize.s28.sp,color: ColorManager.darkPrimary)),
            trailing: Switch(
              value: AppPreferences.isLangChanged,
              onChanged: (value) {
                setState(() {
                  _changeLanguage();
                });
              },
              activeTrackColor: ColorManager.lightPrimary,
              activeColor: ColorManager.primary,
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              _themeManager.themeMode == ThemeMode.dark
                  ? ImageAssets.darkThemeMode
                  : ImageAssets.lightThemeMode,
              color: ColorManager.darkPrimary,
              width: AppSize.s35,
            ),
            title: Text(
                _themeManager.themeMode == ThemeMode.dark
                    ? AppStrings.darkMode.tr()
                    : AppStrings.lightMode.tr(),
                style: TextStyle(fontSize: AppSize.s28.sp,color: ColorManager.darkPrimary)),
            trailing: Switch(
              value: _themeManager.themeMode == ThemeMode.dark,
              onChanged: (value) {
                _themeManager.toggleTheme(value);
                setState(() {
                  isTwoSwitched = value;
                });
              },
              activeTrackColor: ColorManager.lightPrimary,
              activeColor: ColorManager.primary,
            ),
          ),
        ],
      ),
    );
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}
