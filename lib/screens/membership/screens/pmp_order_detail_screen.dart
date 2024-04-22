import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/pmp_order_model.dart';
import 'package:socialv/screens/dashboard_screen.dart';

import '../../../utils/app_constants.dart';

class PmpOrderDetailScreen extends StatelessWidget {
  final bool isFromCheckOutScreen;
  final PmpOrderModel orderDetail;

  PmpOrderDetailScreen({this.isFromCheckOutScreen = false, required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isFromCheckOutScreen) {
          push(DashboardScreen(), isNewTask: true);
        } else {
          finish(context);
        }
        return Future.value(true);
      },
      child: AppScaffold(
        appBarTitle: language.orderDetails,
        onBack: () {
          if (isFromCheckOutScreen) {
            push(DashboardScreen(), isNewTask: true);
          } else {
            finish(context);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${language.invoiceId}: #${orderDetail.code}', style: boldTextStyle()),
            16.height,
            Container(
              width: context.width(),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.orderDetails, style: boldTextStyle(size: 18)),
                  Divider(height: 20),
                  Text('${language.plan}: ${orderDetail.membershipName}', style: primaryTextStyle()),
                  12.height,
                  Text('${language.dateCreated}: ${DateFormat(DATE_FORMAT_5).format(DateTime.parse(orderDetail.timestamp.validate()))}', style: primaryTextStyle()),
                  12.height,
                  Text('${language.status}: ${language.paid}', style: primaryTextStyle()),
                  12.height,
                  Text('${language.customer}: ${appStore.loginFullName}', style: primaryTextStyle()),
                  12.height,
                  Text('${language.email}: ${appStore.loginEmail}', style: primaryTextStyle()),
                  12.height,
                ],
              ),
            ),
            16.height,
            Container(
              width: context.width(),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.paymentDetails, style: boldTextStyle(size: 18)),
                  Divider(height: 20),
                  12.height,
                  Text('${language.payVia}: ${orderDetail.cardtype} ending in ${orderDetail.accountnumber.validate().substring(orderDetail.accountnumber.validate().length - 4)}',
                      style: primaryTextStyle()),
                  12.height,
                  if (orderDetail.expirationmonth.validate().isNotEmpty && orderDetail.expirationyear.validate().isNotEmpty)
                    Text(
                      '${language.expiration}: ${orderDetail.expirationmonth}/${orderDetail.expirationyear}',
                      style: primaryTextStyle(),
                    ).paddingBottom(12),
                  if (orderDetail.discountCode.validate().isNotEmpty)
                    Text(
                      '${language.discountCode}: ${orderDetail.discountCode}',
                      style: primaryTextStyle(),
                    ).paddingBottom(12),
                  if (orderDetail.subtotal.validate().isNotEmpty)
                    Text(
                      '${language.subTotal}: ${pmpStore.pmpCurrency}${orderDetail.subtotal}',
                      style: primaryTextStyle(),
                    ).paddingBottom(12),
                  Text('${language.totalAmount}: ${pmpStore.pmpCurrency}${orderDetail.total}', style: primaryTextStyle()),
                  12.height,
                ],
              ),
            ),
            if (isFromCheckOutScreen)
              InkWell(
                onTap: () {
                  DashboardScreen().launch(context, isNewTask: true);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                  child: Text(language.clickHereToVisitHomePage, style: secondaryTextStyle(color: Colors.white)).center(),
                ),
              ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
