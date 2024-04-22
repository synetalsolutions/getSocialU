import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class CancelMembershipScreen extends StatefulWidget {
  final String currentLevelId;

  const CancelMembershipScreen({required this.currentLevelId});

  @override
  State<CancelMembershipScreen> createState() => _CancelMembershipScreenState();
}

class _CancelMembershipScreenState extends State<CancelMembershipScreen> {
  bool isCancelled = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.cancelMembership,
      onBack: () {
        finish(context, isCancelled);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.height,
          cachedImage(
            ic_shield_fail,
            color: context.primaryColor,
            height: 100,
            width: 100,
          ),
          if (isCancelled)
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withAlpha(30),
                    border: Border(left: BorderSide(color: context.primaryColor, width: 2)),
                  ),
                  child: Text(
                    language.yourMembershipCancelled,
                    style: primaryTextStyle(color: context.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                16.height,
                InkWell(
                  onTap: () {
                    DashboardScreen().launch(context, isNewTask: true);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                    child: Text(language.clickHereToVisitHomePage, style: secondaryTextStyle(color: Colors.white)).center(),
                  ),
                ),
                16.height,
              ],
            )
          else
            Column(
              children: [
                Text(
                  language.cancelMembershipConfirmation,
                  style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                  textAlign: TextAlign.center,
                ),
                16.height,
                InkWell(
                  onTap: () {
                    ifNotTester(() {
                      appStore.setLoading(true);
                      cancelMembershipLevel(levelId: widget.currentLevelId).then((value) {
                        pmpStore.pmpMembership = null;
                        setRestrictions();

                        isCancelled = true;
                        setState(() {});
                        appStore.setLoading(false);
                      }).catchError((e) {
                        appStore.setLoading(false);
                        toast(e.toString());
                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: radius(4)),
                    child: Text(language.yesCancelThisMembership, style: secondaryTextStyle(color: Colors.white)).center(),
                  ),
                ),
                8.height,
                InkWell(
                  onTap: () {
                    finish(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                    child: Text(language.noKeepThisMembership, style: secondaryTextStyle(color: Colors.white)).center(),
                  ),
                ),
                16.height,
              ],
            ),
        ],
      ).paddingAll(16),
    );
  }
}
