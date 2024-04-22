import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

import '../../../utils/app_constants.dart';

class ChangeThemeDialog extends StatelessWidget {
  final double? width;
  final VoidCallback voidCallback;

  const ChangeThemeDialog({this.width, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      insetAnimationCurve: Curves.linear,
      insetAnimationDuration: 0.seconds,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: width,
            decoration: BoxDecoration(color: context.primaryColor),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.appTheme, style: boldTextStyle(color: Colors.white, size: 20)),
                Image.asset(ic_close_square, height: 24, width: 24, fit: BoxFit.cover, color: Colors.white).onTap(() {
                  voidCallback.call();
                }, splashColor: Colors.transparent, highlightColor: Colors.transparent)
              ],
            ),
          ),
          RadioListTile(
            value: getIntAsync(SharePreferencesKey.APP_THEME),
            groupValue: AppThemeMode.ThemeModeSystem,
            onChanged: (val) async {
              appStore.toggleDarkMode(value: MediaQuery.of(context).platformBrightness == Brightness.dark);
              await setValue(SharePreferencesKey.APP_THEME, AppThemeMode.ThemeModeSystem);
              await setValue(SharePreferencesKey.IS_DARK_MODE, MediaQuery.of(context).platformBrightness == Brightness.dark);
              voidCallback.call();
            },
            title: Text(language.systemDefault, style: primaryTextStyle()),
          ),
          RadioListTile(
            value: getIntAsync(SharePreferencesKey.APP_THEME),
            groupValue: AppThemeMode.ThemeModeDark,
            onChanged: (val) async {
              appStore.toggleDarkMode(value: true);
              await setValue(SharePreferencesKey.APP_THEME, AppThemeMode.ThemeModeDark);
              await setValue(SharePreferencesKey.IS_DARK_MODE, true);
              voidCallback.call();
            },
            title: Text(language.darkMode, style: primaryTextStyle()),
          ),
          RadioListTile(
            value: getIntAsync(SharePreferencesKey.APP_THEME),
            groupValue: AppThemeMode.ThemeModeLight,
            onChanged: (val) async {
              appStore.toggleDarkMode(value: false);
              await setValue(SharePreferencesKey.APP_THEME, AppThemeMode.ThemeModeLight);
              await setValue(SharePreferencesKey.IS_DARK_MODE, false);
              voidCallback.call();
            },
            title: Text(language.lightMode, style: primaryTextStyle()),
          ),
        ],
      ),
    );
  }
}
