import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/user_settings_model.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/screens/set_chat_wallpaper_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  List<Options> options = [];
  List<UserObject> blockedUsers = [];

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    appStore.setLoading(true);
    await userSettings().then((value) {
      if (value.isNotEmpty) {
        value.forEach((element) {
          if (element.id == MessageUserSettings.notifications) {
            options = element.options.validate();
          } else if (element.id == MessageUserSettings.bmBlockedUsers) {
            blockedUsers = element.user.validate();
          }
        });
      }
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.settings,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                SetChatWallpaperScreen(isGeneralSetting: true, wallpaperUrl: messageStore.globalChatBackground).launch(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.wallpaper, style: boldTextStyle(size: 20)),
                  Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
                ],
              ).paddingAll(16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.notifications, style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(right: 16),
                  itemCount: options.validate().length,
                  itemBuilder: (ctx, index) {
                    Options option = options[index];
                    return InkWell(
                      onTap: () async {
                        option.checked = !option.checked.validate();
                        setState(() {});

                        await saveUserSettings(option: option.id.validate(), value: option.checked.validate()).then((value) {
                          toast(value.message);
                        });
                        init();
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            shape: RoundedRectangleBorder(borderRadius: radius(2)),
                            activeColor: context.primaryColor,
                            value: option.checked,
                            onChanged: (val) async {
                              option.checked = !option.checked.validate();
                              setState(() {});
                              await saveUserSettings(option: option.id.validate(), value: option.checked.validate()).then((value) {
                                toast(value.message);
                              });
                              init();
                            },
                          ),
                          Column(
                            children: [
                              Text(option.label.validate(), style: primaryTextStyle()),
                              Text(option.desc.validate(), style: secondaryTextStyle()),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ).expand(),
                        ],
                      ).paddingSymmetric(vertical: 8),
                    );
                  },
                ),
                16.height,
                Text(language.blockedAccounts, style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16),
                8.height,
                Text(
                  language.listOfUsersBlocked,
                  style: secondaryTextStyle(),
                ).paddingSymmetric(horizontal: 16),
                if (blockedUsers.validate().isEmpty && !appStore.isLoading)
                  NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.youHaventBlockedText,
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: blockedUsers.validate().length,
                    itemBuilder: (ctx, index) {
                      UserObject user = blockedUsers[index];
                      return Row(
                        children: [
                          cachedImage(user.memberAvtarImage, height: 40, width: 40).cornerRadiusWithClipRRect(20),
                          16.width,
                          Column(
                            children: [
                              Text(user.name.validate(), style: primaryTextStyle(size: 14)),
                              4.height,
                              Text(user.mentionName.validate(), style: secondaryTextStyle(size: 12)).paddingOnly(right: 8),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ).expand(),
                          AppButton(
                            enabled: true,
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                            text: language.unblock,
                            textStyle: primaryTextStyle(color: Colors.white, size: 12),
                            onTap: () async {
                              await unblockUser(userId: user.id.validate()).then((value) {
                                init();
                              });
                            },
                            color: context.primaryColor,
                            width: 60,
                            padding: EdgeInsets.all(0),
                            elevation: 0,
                          )
                        ],
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
