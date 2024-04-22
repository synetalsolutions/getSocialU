import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/discount_code_model.dart';
import 'package:socialv/models/pmp_models/membership_model.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/components/plan_subtitle_component.dart';

import '../../../utils/app_constants.dart';

class DiscountCodesScreen extends StatefulWidget {
  final String planID;
  final Function(String, MembershipModel) onApply;

  const DiscountCodesScreen({required this.planID, required this.onApply});

  @override
  State<DiscountCodesScreen> createState() => _DiscountCodesScreenState();
}

class _DiscountCodesScreenState extends State<DiscountCodesScreen> {
  DiscountCode? selectedCode;

  List<DiscountCode> codeList = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    getCodeList();
  }

  Future<void> getCodeList() async {
    isError = false;

    appStore.setLoading(true);
    codeList.clear();
    await getDiscountCodeList(planId: widget.planID).then((value) {
      codeList.addAll(value.validate());
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      log(e.toString());
      setState(() {});
      appStore.setLoading(false);
    });
  }

  Color getColor(DiscountCode code) {
    if (selectedCode == code) {
      return context.primaryColor;
    } else if (appStore.isDarkMode) {
      return bodyDark;
    } else {
      return bodyWhite;
    }
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
      appBarTitle: language.discountCodes,
      child: Stack(
        children: [
          if (codeList.isNotEmpty)
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: codeList.length,
              itemBuilder: (ctx, index) {
                DiscountCode code = codeList[index];
                return GestureDetector(
                  onTap: () {
                    if (selectedCode != code)
                      selectedCode = code;
                    else
                      selectedCode = null;

                    setState(() {});
                  },
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: getColor(code), width: 1),
                          color: selectedCode == code ? getColor(code).withAlpha(30) : context.cardColor,
                          borderRadius: radius(commonRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(code.code.validate(), style: boldTextStyle()),
                            8.height,
                            PlanSubtitleComponent(plan: code.plans.validate().first),
                            8.height,
                            Text('${language.validTill} ${code.expires}', style: secondaryTextStyle()),
                          ],
                        ),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: () {
                            if (selectedCode != code)
                              selectedCode = code;
                            else
                              selectedCode = null;

                            setState(() {});
                          },
                          icon: Icon(
                            selectedCode == code ? Icons.radio_button_checked : Icons.circle_outlined,
                            color: selectedCode == code ? context.primaryColor : context.iconColor,
                          ),
                        ),
                        right: 0,
                        top: 8,
                      )
                    ],
                  ),
                );
              },
            ),
          if (codeList.isEmpty && !appStore.isLoading && !isError)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.noDataFound,
            ).center(),
          if (isError && !appStore.isLoading)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.somethingWentWrong,
              onRetry: () {
                getCodeList();
              },
              retryText: '   ${language.clickToRefresh}   ',
            ).center(),
        ],
      ),
      bottomNavigationBar: selectedCode != null
          ? AppButton(
              width: context.width() - 32,
              text: language.select,
              elevation: 0,
              textStyle: boldTextStyle(color: Colors.white),
              color: context.primaryColor,
              onTap: () {
                widget.onApply(selectedCode!.code.validate(), selectedCode!.plans.validate().first);
              },
            ).paddingAll(16)
          : Offstage(),
    );
  }
}
