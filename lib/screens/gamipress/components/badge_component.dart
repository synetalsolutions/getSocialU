import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/rewards_model.dart';
import 'package:socialv/screens/gamipress/screens/earned_badges_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

class BadgeComponent extends StatelessWidget {
  final List<Rank> badgeList;
  final int achievementCount;
  final int userId;
  const BadgeComponent({required this.badgeList, required this.achievementCount, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (badgeList.isEmpty)
      return SizedBox(
        height: context.height() * 0.7,
        child: NoDataWidget(
          imageWidget: NoDataLottieWidget(),
          title: language.userNotAchievedBadges,
        ),
      );
    else
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${language.earnedBadges}: $achievementCount", style: primaryTextStyle()).paddingAll(16),
            AnimatedListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: badgeList.length,
              itemBuilder: (ctx, index) {
                Rank badge = badgeList[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: Text(badge.name.validate(), style: secondaryTextStyle(size: 16)),
                  leading: cachedImage(badge.image.validate(), height: 50, width: 50, fit: BoxFit.cover),
                );
              },
            ),
            if (achievementCount > 10)
              TextButton(
                onPressed: () {
                  EarnedBadgesScreen(userID: userId).launch(context);
                },
                child: Text(language.viewAll, style: primaryTextStyle(color: context.primaryColor)),
              ).center(),
            30.height,
          ],
        ),
      );
  }
}
