import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/rewards_model.dart';
import 'package:socialv/network/gamipress_reporitory.dart';
import 'package:socialv/screens/gamipress/components/badge_component.dart';
import 'package:socialv/screens/gamipress/components/level_component.dart';
import 'package:socialv/screens/gamipress/components/points_component.dart';

class RewardsScreen extends StatefulWidget {
  final int userID;
  RewardsScreen({required this.userID});

  @override
  State<RewardsScreen> createState() => _ScreenState();
}

class _ScreenState extends State<RewardsScreen> {
  List<String> tabs = ["${language.points}", "${language.badges}", "${language.levels}"];
  RewardsModel? data;

  int selectedIndex = 0;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    appStore.setLoading(true);

    await rewards(userID: widget.userID).then((value) {
      data = value;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      log("Error: ${e.toString()}");
      isError = true;
      setState(() {});
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
      appBarTitle: language.rewards,
      child: Stack(
        children: [
          if (data != null)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalList(
                    itemCount: tabs.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          selectedIndex = index;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(color: selectedIndex == index ? context.primaryColor : context.cardColor, borderRadius: radius()),
                          child: Text(tabs[index], style: boldTextStyle(color: selectedIndex == index ? Colors.white : context.primaryColor)),
                        ),
                      );
                    },
                  ),
                  if (selectedIndex == 0)
                    PointsComponent(pointsList: data!.points.validate())
                  else if (selectedIndex == 1)
                    BadgeComponent(
                      achievementCount: data!.achievementCount == null ? 0 : data!.achievementCount!,
                      badgeList: data!.achievement.validate(),
                      userId: widget.userID,
                    )
                  else
                    LevelComponent(rank: data!.rank).center(),
                ],
              ),
            )
          else if (isError)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: isError ? language.somethingWentWrong : language.noDataFound,
              onRetry: () {
                isError = false;
                setState(() {});
                getDetails();
              },
              retryText: '   ${language.clickToRefresh}   ',
            ).center(),
        ],
      ),
    );
  }
}
