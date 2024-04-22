import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/screens/settings/components/account_settings_component.dart';
import 'package:socialv/screens/settings/components/manage_account_settings_component.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/settings/components/change_theme_dialog.dart';
import 'package:socialv/screens/settings/components/settings_about_component.dart';
import 'package:socialv/screens/settings/screens/language_screen.dart';
import 'package:socialv/screens/settings/screens/safe_content_settings_screen.dart';
import 'package:socialv/utils/app_constants.dart';


class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    int themeModeIndex = getIntAsync(SharePreferencesKey.APP_THEME, defaultValue: AppThemeMode.ThemeModeSystem);

    window.onPlatformBrightnessChanged = () {
      if (themeModeIndex == AppThemeMode.ThemeModeSystem) {
        appStore.toggleDarkMode(value: MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, isUpdate);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.settings, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Observer(
          builder: (_) => Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SettingSection(
                      title: Text(language.appSetting.toUpperCase(), style: boldTextStyle(color: context.primaryColor)),
                      headingDecoration: BoxDecoration(color: context.cardColor),
                      items: [
                        SettingItemWidget(
                          title: language.appTheme,
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_dark_mode, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
                          onTap: () async {
                            await showGeneralDialog(
                              context: context,
                              transitionDuration: Duration(milliseconds: 250),
                              barrierColor: Colors.black26,
                              transitionBuilder: (ctx, a1, a2, widget) {
                                return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                    opacity: a1.value,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.repeated),
                                      child: ChangeThemeDialog(
                                        voidCallback: () {
                                          finish(ctx);
                                        },
                                        width: ctx.width(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              pageBuilder: (context, animation1, animation2) => Offstage(),
                            );
                          },
                        ),
                        SettingItemWidget(
                          title: language.appLanguage,
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_network, height: 16, width: 16, color: context.primaryColor, fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
                          onTap: () {
                            LanguageScreen().launch(context);
                          },
                        ),
                        SettingItemWidget(
                          title: language.contentSafety,
                          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_shield_done, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
                          onTap: () {
                            SafeContentSettingsScreen().launch(context);
                          },
                        ),
                      ],
                    ),
                    AccountSettingsComponent(callback: (value) => isUpdate = value),
                    SettingsAboutComponent(),
                    ManageAccountSettingsComponent(),
                    TextButton(
                      onPressed: () {
                        showConfirmDialogCustom(
                          context,
                          primaryColor: appColorPrimary,
                          title: language.logoutConfirmation,
                          onAccept: (s) {
                            logout(context);
                          },
                        );
                      },
                      child: Text(language.logout, style: boldTextStyle(color: context.primaryColor)),
                    ).paddingAll(16),
                    30.height,
                  ],
                ),
              ),
              LoadingWidget().center().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
