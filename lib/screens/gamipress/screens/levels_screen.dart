import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gamipress/common_gamipress_model.dart';
import 'package:socialv/network/gamipress_reporitory.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  List<CommonGamiPressModel> levels = [];
  late Future<List<CommonGamiPressModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getList();

    super.initState();
  }

  Future<List<CommonGamiPressModel>> getList() async {
    appStore.setLoading(true);

    await levelsList(page: mPage).then((value) {
      if (mPage == 1) levels.clear();

      mIsLastPage = value.length != 20;
      levels.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return levels;
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
      appBarTitle: language.levels,
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
                title: isError ? language.somethingWentWrong : language.noDataFound,
                onRetry: () {
                  mPage = 1;
                  future = getList();
                },
                retryText: '   ${language.clickToRefresh}   ',
              ).center();
            }

            if (snap.hasData) {
              if (snap.data.validate().isEmpty) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: isError ? language.somethingWentWrong : language.noDataFound,
                  onRetry: () {
                    mPage = 1;
                    future = getList();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center();
              } else {
                return AnimatedListView(
                  shrinkWrap: true,
                  slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    CommonGamiPressModel level = levels[index];

                    return Container(
                      width: context.width() - 32,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                      child: Column(
                        children: [
                          if (level.image.validate().isNotEmpty) cachedImage(level.image.validate(), height: 100, fit: BoxFit.cover),
                          16.height,
                          Text(parseHtmlString(level.title!.rendered.validate()), style: primaryTextStyle()),
                          8.height,
                          Text(
                            parseHtmlString(level.content!.rendered.validate()),
                            style: secondaryTextStyle(),
                            textAlign: TextAlign.center,
                          ),
                          if (level.requirements.validate().isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${language.requirements}:', style: primaryTextStyle()),
                                Text('${level.requirements.validate().length}', style: primaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Column(
                              children: level.requirements.validate().map((e) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('•', style: secondaryTextStyle()),
                                    8.width,
                                    Text(
                                      ' ${parseHtmlString(e.title.validate())}',
                                      style: secondaryTextStyle(decoration: e.hasEarned.validate() ? TextDecoration.overline : TextDecoration.none),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ).expand(),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
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
