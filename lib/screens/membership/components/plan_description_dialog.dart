import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/bp_level_options.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class PlanDescriptionDialog extends StatelessWidget {
  final BpLevelOptions restrictions;

  const PlanDescriptionDialog({required this.restrictions});

  Widget getPrefix(int value) {
    return cachedImage(
      value == 1 ? ic_check : ic_close,
      color: appColorPrimary,
      height: 18,
      width: 18,
      fit: BoxFit.cover,
    );
  }

  Widget getWidget(int value, String text) {
    return TextIcon(
      spacing: 16,
      prefix: getPrefix(value),
      text: text,
      textStyle: secondaryTextStyle(size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(language.allowedActions, style: boldTextStyle(color: context.primaryColor, size: 20)).center(),
          16.height,
          getWidget(restrictions.pmproBpGroupCreation.validate(), language.groupCreation),
          getWidget(restrictions.pmproBpGroupsJoin.validate(), language.joinGroup),
          getWidget(restrictions.pmproBpGroupSingleViewing.validate(), language.viewGroupDetail),
          getWidget(restrictions.pmproBpGroupsPageViewing.validate(), language.viewGroups),
          getWidget(restrictions.pmproBpPrivateMessaging.validate(), language.privateMessages),
          getWidget(restrictions.pmproBpSendFriendRequest.validate(), language.sendFriendRequest),
          getWidget(restrictions.pmproBpMemberDirectory.validate(), language.viewMemberDirectory),
        ],
      ).onTap(() {
        finish(context);
      }),
    );
  }
}
