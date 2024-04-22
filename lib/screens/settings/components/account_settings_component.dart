import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/gamipress/screens/rewards_screen.dart';
import 'package:socialv/screens/membership/screens/my_membership_screen.dart';
import 'package:socialv/screens/profile/screens/edit_profile_screen.dart';
import 'package:socialv/screens/settings/screens/change_password_screen.dart';
import 'package:socialv/screens/settings/screens/notification_settings.dart';
import 'package:socialv/screens/settings/screens/profile_visibility_screen.dart';
import 'package:socialv/screens/shop/screens/coupon_list_screen.dart';
import 'package:socialv/screens/shop/screens/edit_shop_details_screen.dart';

import '../../../utils/app_constants.dart';

class AccountSettingsComponent extends StatelessWidget {
  final Function(bool) callback;

  const AccountSettingsComponent({required this.callback});

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: Text('${language.account.toUpperCase()} ${language.settings.toUpperCase()}', style: boldTextStyle(color: context.primaryColor)),
      headingDecoration: BoxDecoration(color: context.cardColor),
      items: [
        if (appStore.showMemberShip)
          SettingItemWidget(
            title: language.membership,
            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
            leading: Image.asset(ic_ticket_star, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
            trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
            onTap: () {
              if (!appStore.isLoading) {
                MyMembershipScreen().launch(context);
              }
            },
          ),
        if (appStore.showGamiPress)
          SettingItemWidget(
            title: language.myRewards,
            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
            leading: Image.asset(ic_star, height: 16, width: 16, color: context.primaryColor, fit: BoxFit.cover),
            trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
            onTap: () {
              RewardsScreen(userID: appStore.loginUserId.toInt()).launch(context);
            },
          ),
        SettingItemWidget(
          title: language.editProfile,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_edit, height: 16, width: 16, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading)
              EditProfileScreen().launch(context).then((value) {
                callback.call(value ?? false);
              });
          },
        ),
        if (appStore.showShop)
          SettingItemWidget(
            title: language.editShopDetails,
            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
            leading: Image.asset(ic_bag, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
            trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
            onTap: () {
              if (!appStore.isLoading)
                EditShopDetailsScreen().launch(context).then((value) {
                  callback.call(value ?? false);
                });
            },
          ),
        if (appStore.showWoocommerce == 1)
          SettingItemWidget(
            title: language.coupons,
            titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
            leading: Image.asset(ic_coupon, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
            trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
            onTap: () {
              CouponListScreen().launch(context);
            },
          ),
        SettingItemWidget(
          title: language.changePassword,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_lock, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) ChangePasswordScreen().launch(context);
          },
        ),
        SettingItemWidget(
          title: language.notificationSettings,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_notification, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) NotificationSettings().launch(context);
          },
        ),
        SettingItemWidget(
          title: language.profileVisibility,
          titleTextStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
          leading: Image.asset(ic_profile, height: 18, width: 18, color: context.primaryColor, fit: BoxFit.cover),
          trailing: Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
          onTap: () {
            if (!appStore.isLoading) ProfileVisibilityScreen().launch(context);
          },
        ),
      ],
    );
  }
}
