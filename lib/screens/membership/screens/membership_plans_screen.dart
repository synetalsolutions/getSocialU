import 'package:flutter/material.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/pmp_models/membership_model.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/components/plan_subtitle_component.dart';
import 'package:socialv/screens/membership/screens/pmp_checkout_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:socialv/utils/cached_network_image.dart';

import 'package:socialv/utils/app_constants.dart';

// ignore: must_be_immutable
class MembershipPlansScreen extends StatefulWidget {
  String? selectedPlanId;

  MembershipPlansScreen({this.selectedPlanId});

  @override
  State<MembershipPlansScreen> createState() => _MembershipPlansScreenState();
}

class _MembershipPlansScreenState extends State<MembershipPlansScreen> {
  List<MembershipModel> plans = [];

  bool isError = false;

  MembershipModel? selectedPlan;

  @override
  void initState() {
    super.initState();

    if (pmpStore.pmpMembership != null && widget.selectedPlanId == null) {
      widget.selectedPlanId = pmpStore.pmpMembership;
    }
    getPlansList();
  }

  Future<void> getPlansList() async {
    isError = false;

    appStore.setLoading(true);
    plans.clear();
    await getLevelsList().then((value) {
      plans.addAll(value.validate());
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      log(e.toString());
      setState(() {});
      appStore.setLoading(false);
    });
  }

  Color getColor(MembershipModel plan) {
    if (widget.selectedPlanId == plan.id) {
      return appGreenColor;
    } else if (selectedPlan == plan) {
      return context.primaryColor;
    } else if (appStore.isDarkMode) {
      return bodyDark;
    } else {
      return bodyWhite;
    }
  }

  Widget getPrefix(int value) {
    return cachedImage(
      value == 1 ? ic_check : ic_close,
      color: appColorPrimary,
      height: 16,
      width: 16,
      fit: BoxFit.cover,
    );
  }

  Widget getWidget(int value, String text) {
    return TextIcon(
      spacing: 16,
      expandedText: true,
      suffix: getPrefix(value),
      text: text,
      textStyle: secondaryTextStyle(size: 16),
      maxLine: 2,
    ).paddingSymmetric(vertical: 4);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    if (appStore.isLoading) appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.selectPlan,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (plans.isNotEmpty)
            ListView(
              padding: EdgeInsets.symmetric(vertical: 32),
              children: [
                CarouselSlider(
                  items: plans.map((plan) {
                    return Container(
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(commonRadius)),
                      width: context.width(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.selectedPlanId != plan.id ? context.primaryColor : appGreenColor,
                                    borderRadius: radiusOnly(topRight: commonRadius, topLeft: commonRadius),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Text(
                                        plan.name.validate(),
                                        style: boldTextStyle(color: Colors.white, size: 22),
                                      ).center(),
                                      if (plan.description.validate().isNotEmpty)
                                        Text(
                                          parseHtmlString(plan.description.validate()),
                                          style: secondaryTextStyle(color: Colors.white),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ).paddingTop(6),
                                      16.height,
                                      PlanSubtitleComponent(plan: plan, size: 16, color: Colors.white).center(),
                                    ],
                                  ),
                                ),
                                16.height,
                                Text(language.allowedActions, style: primaryTextStyle(color: context.primaryColor)).center(),
                                16.height,
                                UL(
                                  children: [
                                    getWidget(plan.bpLevelOptions!.pmproBpGroupCreation.validate(), language.groupCreation),
                                    getWidget(plan.bpLevelOptions!.pmproBpGroupsJoin.validate(), language.joinGroup),
                                    getWidget(plan.bpLevelOptions!.pmproBpGroupSingleViewing.validate(), language.viewGroupDetail),
                                    getWidget(plan.bpLevelOptions!.pmproBpGroupsPageViewing.validate(), language.viewGroups),
                                    getWidget(plan.bpLevelOptions!.pmproBpPrivateMessaging.validate(), language.privateMessages),
                                    getWidget(plan.bpLevelOptions!.pmproBpSendFriendRequest.validate(), language.sendFriendRequest),
                                    getWidget(plan.bpLevelOptions!.pmproBpMemberDirectory.validate(), language.viewMemberDirectory),
                                  ],
                                  symbolCrossAxisAlignment: CrossAxisAlignment.center,
                                  symbolColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                                ).paddingSymmetric(horizontal: 16),
                              ],
                            ),
                            24.height,
                            AppButton(
                              width: context.width() - 32,
                              text: widget.selectedPlanId != plan.id ? language.selectAndProceed : language.yourPlan,
                              elevation: 0,
                              textStyle: boldTextStyle(color: Colors.white),
                              color: widget.selectedPlanId != plan.id ? context.primaryColor : appGreenColor,
                              onTap: () {
                                if (widget.selectedPlanId != plan.id) PmpCheckoutScreen(selectedPlan: plan).launch(context);
                              },
                            ).paddingAll(16)
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: context.height() * 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                  ),
                ),
              ],
            ),
          if (plans.isEmpty && !appStore.isLoading && !isError)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.noDataFound,
            ).center(),
          if (isError && !appStore.isLoading)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.somethingWentWrong,
              onRetry: () {
                getPlansList();
              },
              retryText: '   ${language.clickToRefresh}   ',
            ).center(),
        ],
      ),
    );
  }
}
