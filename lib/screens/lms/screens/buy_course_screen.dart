import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lms_payment_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/screens/lms_order_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class BuyCourseScreen extends StatefulWidget {
  final String? courseImage;
  final String? courseName;
  final String? coursePriseRendered;
  final int? coursePrise;
  final int courseId;
  final VoidCallback? callback;

  const BuyCourseScreen({
    this.courseImage,
    this.courseName,
    this.coursePrise,
    required this.courseId,
    this.coursePriseRendered,
    this.callback,
  });

  @override
  State<BuyCourseScreen> createState() => _BuyCourseScreenState();
}

class _BuyCourseScreenState extends State<BuyCourseScreen> {
  TextEditingController note = TextEditingController();
  LmsPaymentModel? selectedPaymentMethod;

  bool isPaymentGatewayLoading = true;

  List<LmsPaymentModel> paymentGateways = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isPaymentGatewayLoading = true;
    setState(() {});

    await getLmsPayments().then((value) {
      paymentGateways.addAll(value);
      selectedPaymentMethod = paymentGateways.firstWhere((element) => element.isSelected.validate());
      isPaymentGatewayLoading = false;
      setState(() {});
    }).catchError((e) {
      isPaymentGatewayLoading = false;
      isError = true;
      toast(e.toString(), print: true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.checkout,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${language.yourOrder}:', style: boldTextStyle(size: 18)),
                  16.height,
                  Row(
                    children: [
                      cachedImage(widget.courseImage, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
                      16.width,
                      Text(widget.courseName.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                    ],
                  ),
                  Divider(color: context.dividerColor, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.subTotal, style: boldTextStyle(size: 14)),
                      Text(widget.coursePriseRendered.validate(), style: secondaryTextStyle()),
                    ],
                  ),
                  Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.total, style: boldTextStyle()),
                      Text(widget.coursePriseRendered.validate(), style: boldTextStyle(size: 20, color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                    ],
                  ),
                ],
              ),
            ),
            AppTextField(
              controller: note,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.MULTILINE,
              textStyle: boldTextStyle(),
              decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: language.noteToAdministrator),
              minLines: 5,
            ).paddingSymmetric(horizontal: 16),
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${language.paymentMethod}:', style: boldTextStyle()),
                  16.height,
                  if (isPaymentGatewayLoading)
                    ThreeBounceLoadingWidget().paddingSymmetric(vertical: 16)
                  else if (isError)
                    Row(
                      children: [
                        Icon(Icons.payment, color: context.iconColor, size: 20),
                        16.width,
                        Text(language.paymentGatewaysNotFound, style: primaryTextStyle()),
                      ],
                    ).paddingSymmetric(vertical: 16)
                  else
                    ListView.builder(
                      itemCount: paymentGateways.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        LmsPaymentModel payment = paymentGateways[index];
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (selectedPaymentMethod != payment) {
                              selectedPaymentMethod = payment;
                              setState(() {});
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                selectedPaymentMethod!.id == payment.id ? Icons.check_circle_rounded : Icons.circle_outlined,
                                color: selectedPaymentMethod!.id == payment.id ? context.primaryColor : context.iconColor,
                              ),
                              16.width,
                              Text(
                                payment.description.validate(),
                                style: primaryTextStyle(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).expand(),
                            ],
                          ),
                        ).paddingSymmetric(vertical: 4);
                      },
                    ),
                ],
              ),
            ),
            16.height,
            appButton(
              context: context,
              text: language.placeOrder,
              onTap: () async {
                ifNotTester(() async {
                  if (selectedPaymentMethod != null) {
                    if (selectedPaymentMethod!.id.validate() == 'offline-payment') {
                      appStore.setLoading(true);
                      await lmsPlaceOrder(
                        courseIds: [widget.courseId],
                        subTotal: widget.coursePrise.validate().toDouble(),
                        total: widget.coursePrise.validate().toDouble(),
                        paymentMethod: selectedPaymentMethod!.id.validate(),
                      ).then((value) {
                        appStore.setLoading(false);
                        finish(context);
                        LmsOrderScreen(orderDetail: value, isFromCheckOutScreen: true).launch(context).then((value) {
                          widget.callback?.call();
                        });
                      }).catchError((e) {
                        toast(e.toString());
                        appStore.setLoading(true);
                      });
                    } else {
                      toast(language.paymentNotSupportedText);
                    }
                  } else {
                    toast(language.paymentMethodIsRequired);
                  }
                });
              },
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
