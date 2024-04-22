import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/membership_model.dart';
import 'package:socialv/models/pmp_models/payment_gateway_model.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/components/plan_subtitle_component.dart';
import 'package:socialv/screens/membership/screens/discount_codes_screen.dart';
import 'package:socialv/screens/membership/screens/pmp_order_detail_screen.dart';
import 'package:socialv/services/razor_pay_services.dart';
import 'package:socialv/services/stripe_services.dart';

import '../../../utils/app_constants.dart';

class PmpCheckoutScreen extends StatefulWidget {
  final MembershipModel selectedPlan;

  const PmpCheckoutScreen({required this.selectedPlan});

  @override
  State<PmpCheckoutScreen> createState() => _PmpCheckoutScreenState();
}

class _PmpCheckoutScreenState extends State<PmpCheckoutScreen> {
  TextEditingController discountCodeController = TextEditingController();
  String? discountCode;

  MembershipModel? plan;
  MembershipModel? tempPlan;

  bool showAddDiscount = false;
  int? selectedIndex;

  PaymentGatewayModel? payment;

  @override
  void initState() {
    super.initState();
    plan = widget.selectedPlan;
  }

  Future<void> onApplyDiscount() async {
    if (discountCodeController.text.isNotEmpty) {
      discountCode = discountCodeController.text;
      if (tempPlan != null) {
        plan = tempPlan!;
      }
      showAddDiscount = false;
      setState(() {});
    } else {
      toast(language.pleaseEnterValidCoupon);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.accountDetails,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.width(),
              color: context.cardColor,
              padding: EdgeInsets.all(16),
              child: Text(language.membershipPlan, style: boldTextStyle(color: context.primaryColor)),
            ),
            TextButton(
              onPressed: () {
                finish(context);
              },
              child: Text(language.changePlan, style: primaryTextStyle(color: context.primaryColor)),
            ).paddingSymmetric(horizontal: 8),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(text: language.youHaveSelectedThe, style: secondaryTextStyle(fontFamily: fontFamily)),
                  TextSpan(text: ' ${widget.selectedPlan.name}', style: boldTextStyle(fontFamily: fontFamily, size: 14)),
                  TextSpan(text: ' ${language.membershipPlan.toString().toLowerCase()}.', style: secondaryTextStyle(fontFamily: fontFamily)),
                ],
              ),
            ).paddingSymmetric(horizontal: 16),
            PlanSubtitleComponent(plan: plan!).paddingSymmetric(horizontal: 16),
            if (showAddDiscount)
              Column(
                children: [
                  16.height,
                  Divider(height: 0),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.cancel_outlined, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 20),
                      onPressed: () {
                        if (discountCode == null || discountCode.validate().isEmpty) {
                          showAddDiscount = false;
                          setState(() {});
                        } else {
                          showConfirmDialogCustom(
                            context,
                            onAccept: (c) {
                              showAddDiscount = false;
                              discountCode = null;
                              plan = widget.selectedPlan;
                              discountCodeController.text = '';
                              setState(() {});
                            },
                            dialogType: DialogType.DELETE,
                            title: language.removeCouponConfirmation,
                            positiveText: language.remove,
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width() / 2 - 32,
                        child: TextField(
                          enabled: !appStore.isLoading,
                          controller: discountCodeController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          style: primaryTextStyle(),
                          decoration: inputDecorationFilled(
                            context,
                            label: language.couponCode,
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            fillColor: context.cardColor,
                          ),
                          onSubmitted: (text) async {
                            if (discountCodeController.text.isNotEmpty) {
                              discountCode = discountCodeController.text;
                              showAddDiscount = false;
                              setState(() {});
                            } else {
                              toast(language.pleaseEnterValidCoupon);
                            }
                          },
                        ),
                      ),
                      TextButton(
                        child: Text(language.applyCoupon, style: primaryTextStyle(color: context.primaryColor)),
                        onPressed: () async {
                          onApplyDiscount();
                        },
                      ).paddingLeft(8).expand(),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  TextButton(
                    onPressed: () {
                      DiscountCodesScreen(
                        planID: widget.selectedPlan.id.validate(),
                        onApply: (x, plan) {
                          discountCodeController.text = x;
                          tempPlan = plan;
                          finish(context);
                        },
                      ).launch(context);
                    },
                    child: Text(
                      language.viewDiscountCoupons,
                      style: secondaryTextStyle(color: context.primaryColor),
                    ).center(),
                  ).paddingSymmetric(horizontal: 16),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  if (discountCode != null || discountCode.validate().isNotEmpty)
                    Text('${language.theDiscount} "$discountCode" ${language.codeHasBeenApplied}', style: secondaryTextStyle()).paddingSymmetric(horizontal: 16),
                  TextButton(
                    onPressed: () {
                      showAddDiscount = true;
                      setState(() {});
                    },
                    child: Text(
                        '${language.clickHereTo} ${discountCode != null && discountCode.validate().isNotEmpty ? language.change.toLowerCase() : language.add.toLowerCase()} ${language.yourDiscountCode}',
                        style: secondaryTextStyle(decoration: TextDecoration.underline)),
                  ).paddingSymmetric(horizontal: 8),
                ],
              ),
            Container(
              width: context.width(),
              color: context.cardColor,
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              child: Text(language.paymentMethod, style: boldTextStyle(color: context.primaryColor)),
            ),
            SnapHelperWidget<List<PaymentGatewayModel>>(
              future: paymentsList(),
              onSuccess: (snap) {
                if (snap.validate().isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.validate().length,
                    itemBuilder: (ctx, index) {
                      PaymentGatewayModel temp = snap.validate()[index];

                      return InkWell(
                        onTap: () {
                          if (selectedIndex != index) {
                            payment = snap.validate()[index];
                            selectedIndex = index;
                            setState(() {});
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedIndex == index
                                  ? context.primaryColor
                                  : appStore.isDarkMode
                                      ? bodyDark
                                      : bodyWhite,
                              width: 1,
                            ),
                            color: selectedIndex == index ? context.primaryColor.withAlpha(30) : context.cardColor,
                            borderRadius: radius(commonRadius),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedIndex == index ? Icons.radio_button_checked : Icons.circle_outlined,
                                color: selectedIndex == index
                                    ? context.primaryColor
                                    : appStore.isDarkMode
                                        ? bodyDark
                                        : bodyWhite,
                                size: 20,
                              ),
                              16.width,
                              Text(temp.name.validate(), style: primaryTextStyle()),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.noDataFound,
                  ).center();
                }
              },
              loadingWidget: ThreeBounceLoadingWidget(),
              errorWidget: NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: language.somethingWentWrong,
              ).center(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: selectedIndex != null
          ? appButton(
              text: language.makePayment,
              onTap: () {
                int amount = plan!.isInitial.validate() ? plan!.initialPayment.validate() : plan!.billingAmount.validate();

                if (amount != 0) {
                  ifNotTester(() async {
                    if (payment!.id.validate() == PaymentIds.stripe) {
                      await stripeServices.init(
                        discountCode: discountCode,
                        context: context,
                        stripePaymentPublishKey: payment!.mode.validate() == 'testing' ? payment!.testing!.publicKey.validate() : payment!.live!.publicKey.validate(),
                        totalAmount: plan!.isInitial.validate() ? plan!.initialPayment.validate() : plan!.billingAmount.validate(),
                        stripeURL: payment!.mode.validate() == 'testing' ? payment!.testing!.url.validate() : payment!.live!.url.validate(),
                        stripePaymentKey: payment!.mode.validate() == 'testing' ? payment!.testing!.key.validate() : payment!.live!.key.validate(),
                        levelId: widget.selectedPlan.id.validate(),
                        mode: payment!.mode.validate(),
                      );
                      await 1.seconds.delay;
                      stripeServices.stripePay();
                    } else if (payment!.id.validate() == PaymentIds.razorpay) {
                      appStore.setLoading(true);

                      RazorPayServices.init(
                        disCode: discountCode,
                        razorKey: payment!.mode.validate() == 'testing' ? payment!.testing!.publicKey.validate() : payment!.live!.publicKey.validate(),
                        amount: plan!.isInitial.validate() ? plan!.initialPayment.validate() : plan!.billingAmount.validate(),
                        planId: widget.selectedPlan.id.validate(),
                        ctx: context,
                        paymentMode: payment!.mode.validate(),
                        url: payment!.mode.validate() == 'testing' ? payment!.testing!.url.validate() : payment!.live!.url.validate(),
                        secret: payment!.mode.validate() == 'testing' ? payment!.testing!.key.validate() : payment!.live!.key.validate(),
                      );
                      await 1.seconds.delay;
                      appStore.setLoading(false);
                      RazorPayServices.razorPayCheckout(plan!.isInitial.validate() ? plan!.initialPayment.validate() : plan!.billingAmount.validate());
                    } else {
                      //
                    }
                  });
                } else {
                  Map request = {
                    "billing_amount": amount,
                    "billing_details": '',
                    "card_details": "", // for card payment else null
                    "gateway": payment!.name.validate(),
                    "payment_by": "card",
                    "email": appStore.loginEmail,
                    "contact": '',
                    "meta_value": "",
                    "transaction_id": "",
                    "level_id": widget.selectedPlan.id.validate(),
                    "discount_code": discountCode,
                    "gateway_mode": payment!.mode.validate(),
                    "coupon_amount": plan!.isInitial.validate() ? plan!.initialPayment.validate() : plan!.billingAmount.validate(),
                  };

                  appStore.setLoading(true);
                  generateOrder(request).then((order) async {
                    await getMembershipLevelForUser(userId: appStore.loginUserId.validate().toInt()).then((value) {
                      if (value != null) {
                        pmpStore.setPmpMembership(widget.selectedPlan.id.validate());
                        setRestrictions(levelId: widget.selectedPlan.id.validate());

                        appStore.setLoading(false);
                        PmpOrderDetailScreen(isFromCheckOutScreen: true, orderDetail: order).launch(context);
                      }
                    }).catchError((e) {
                      appStore.setLoading(false);
                      log('Error: ${e.toString()}');
                    });
                  }).catchError((e) {
                    appStore.setLoading(false);
                    toast(e.toString());
                  });
                }
              },
              context: context,
            ).paddingAll(16)
          : Offstage(),
    );
  }
}
