import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';

import '../../../utils/app_constants.dart';

enum GroupType { FILTER, OFF }

class SafeContentSettingsScreen extends StatefulWidget {
  const SafeContentSettingsScreen({super.key});

  @override
  State<SafeContentSettingsScreen> createState() => _SafeContentSettingsScreenState();
}

class _SafeContentSettingsScreenState extends State<SafeContentSettingsScreen> {
  GroupType? groupType;

  @override
  void initState() {
    super.initState();

    if (appStore.filterContent) {
      groupType = GroupType.FILTER;
    } else {
      groupType = GroupType.OFF;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.contentSafety,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              language.contentSafetyText,
              style: secondaryTextStyle(),
            ).paddingSymmetric(horizontal: 16),
            16.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  value: GroupType.FILTER,
                  groupValue: groupType,
                  onChanged: (GroupType? value) {
                    if (!appStore.isLoading) {
                      setState(() {
                        groupType = value;
                      });
                      appStore.setFilterContent(true);
                    }
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.filter, style: boldTextStyle()).paddingTop(12),
                    6.height,
                    Text(language.contentFilterText, style: secondaryTextStyle(size: 12)),
                    8.height,
                  ],
                ).expand(),
              ],
            ).onTap(() {
              if (!appStore.isLoading) {
                setState(() {
                  groupType = GroupType.FILTER;
                });
                appStore.setFilterContent(true);
              }
            }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  value: GroupType.OFF,
                  groupValue: groupType,
                  onChanged: (GroupType? value) {
                    if (!appStore.isLoading) {
                      appStore.setFilterContent(false);
                      setState(() {
                        groupType = value;
                      });
                    }
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.off, style: boldTextStyle()).paddingTop(12),
                    6.height,
                    Text(language.contentFilterText, style: secondaryTextStyle(size: 12)),
                    8.height,
                  ],
                ).expand(),
              ],
            ).onTap(() {
              if (!appStore.isLoading) {
                appStore.setFilterContent(false);
                setState(() {
                  groupType = GroupType.OFF;
                });
              }
            }),
            16.height,
            ExpansionTile(
              title: Text(language.moreAboutContentSafety, style: primaryTextStyle()),
              iconColor: context.primaryColor,
              collapsedIconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
              childrenPadding: EdgeInsets.all(16),
              children: <Widget>[
                Text(
                  language.contentSafetyIsDesigned,
                  style: secondaryTextStyle(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
