import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/common_gamipress_model.dart';
import 'package:socialv/network/gamipress_reporitory.dart';
import 'package:socialv/screens/gamipress/screens/badge_detail_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class BadgeListScreen extends StatefulWidget {
  const BadgeListScreen({super.key});

  @override
  State<BadgeListScreen> createState() => _BadgeListScreenState();
}

class _BadgeListScreenState extends State<BadgeListScreen> {
  late Future<List<CommonGamiPressModel>> future;
  List<CommonGamiPressModel> badgeList = [];

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    future = getBadgeList();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage && badgeList.isNotEmpty) {
          mPage++;
          future = getBadgeList();
        }
      }
    });
  }

  Future<List<CommonGamiPressModel>> getBadgeList() async {
    appStore.setLoading(true);

    await badgesList(page: mPage).then((value) {
      if (mPage == 1) badgeList.clear();
      mIsLastPage = value.length != PER_PAGE;
      badgeList.addAll(value);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return badgeList;
  }

  Future<void> onRefresh() async {
    mPage = 1;
    future = getBadgeList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.badges,
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: context.primaryColor,
        child: FutureBuilder<List<CommonGamiPressModel>>(
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
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: AnimatedWrap(
                    slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                    itemCount: badgeList.length,
                    itemBuilder: (context, index) {
                      CommonGamiPressModel data = badgeList[index];
                      return GestureDetector(
                        onTap: () {
                          BadgeDetailScreen(data: data).launch(context);
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: context.width() / 2 - 24,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                              child: Column(
                                children: [
                                  if (data.image.validate().isNotEmpty)
                                    cachedImage(
                                      data.image.validate(),
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  8.height,
                                  Text(parseHtmlString(data.title!.rendered.validate()), style: data.hasEarned.validate()?primaryTextStyle():primaryTextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            if(!data.hasEarned.validate())
                             Blur(
                               blur: 0.6,
                               child: Container(
                                 width: context.width() / 2 - 24,
                                 padding: EdgeInsets.symmetric(vertical: 60),
                                 decoration: BoxDecoration(color: appStore.isDarkMode?Colors.white10:Colors.grey.withOpacity(0.3), borderRadius: radius(commonRadius)),
                               ),
                             )
                          ],
                        ),
                      );
                    },
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                  ).paddingAll(16),
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
