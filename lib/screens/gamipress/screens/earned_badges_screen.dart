import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/rewards_model.dart';
import 'package:socialv/network/gamipress_reporitory.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class EarnedBadgesScreen extends StatefulWidget {
  final int userID;
  const EarnedBadgesScreen({required this.userID});

  @override
  State<EarnedBadgesScreen> createState() => _EarnedBadgesScreenState();
}

class _EarnedBadgesScreenState extends State<EarnedBadgesScreen> {
  late Future<List<Rank>> future;
  List<Rank> badgeList = [];
  bool isError = false;

  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    future = getList();

    super.initState();
  }

  Future<List<Rank>> getList() async {
    appStore.setLoading(true);

    await userAchievements(userID: widget.userID, page: mPage).then((value) {
      if (mPage == 1) badgeList.clear();

      mIsLastPage = value.validate().length != PER_PAGE;
      badgeList.addAll(value.validate());
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return badgeList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.earnedBadges,
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: context.primaryColor,
        child: FutureBuilder<List<Rank>>(
          future: future,
          builder: (ctx, snap) {
            if (snap.hasError) {
              return NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: language.somethingWentWrong,
                onRetry: () {
                  onRefresh();
                },
                retryText: '   ${language.clickToRefresh}   ',
              ).center();
            }

            if (snap.hasData) {
              if (snap.data.validate().isEmpty) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: language.noDataFound,
                  onRetry: () {
                    onRefresh();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center();
              } else {
                return AnimatedListView(
                  shrinkWrap: true,
                  slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                  itemCount: badgeList.length,
                  itemBuilder: (context, index) {
                    Rank badge = badgeList[index];

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      title: Text(badge.name.validate(), style: secondaryTextStyle(size: 16)),
                      leading: cachedImage(badge.image.validate(), height: 50, width: 50, fit: BoxFit.cover),
                    );
                  },
                  onNextPage: () {
                    if (!mIsLastPage) {
                      mPage++;
                      future = getList();
                    }
                  },
                );
              }
            }
            return Offstage();
          },
        ),
      ),
    );
  }
}
