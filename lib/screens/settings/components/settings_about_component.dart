import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_constants.dart';

class SettingsAboutComponent extends StatelessWidget {
  const SettingsAboutComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: Text(language.about.toUpperCase(), style: boldTextStyle(color: context.primaryColor)),
      headingDecoration: BoxDecoration(color: context.cardColor),
      items: [
        SnapHelperWidget<PackageInfoData>(
          future: getPackageInfo(),
          onSuccess: (d) => SettingItemWidget(
            title: language.rateUs,
            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
            leading: Image.asset(ic_star, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
            trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
            onTap: () {
              if (isAndroid) {
                log('$playStoreBaseURL${d.packageName}');
                launchUrl(Uri.parse('$playStoreBaseURL${d.packageName}'), mode: LaunchMode.externalApplication);
              } else if (isIOS) {
                launchUrl(Uri.parse(IOS_APP_LINK), mode: LaunchMode.externalApplication);
              }
            },
          ),
        ),
        SettingItemWidget(
          title: language.shareApp,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_send, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) onShareTap(context);
          },
        ),
        SettingItemWidget(
          title: language.privacyPolicy,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_shield_done, height: 16, width: 18, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) openWebPage(context, url: PRIVACY_POLICY_URL);
          },
        ),
        SettingItemWidget(
          title: language.termsCondition,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_document, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) openWebPage(context, url: TERMS_AND_CONDITIONS_URL);
          },
        ),
        SettingItemWidget(
          title: language.helpSupport,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_question_circle, height: 18, width: 18, color: appColorPrimary, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) openWebPage(context, url: SUPPORT_URL);
          },
        ),
      ],
    );
  }
}
