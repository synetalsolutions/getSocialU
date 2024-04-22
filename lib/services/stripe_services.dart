import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/payment/stripe_pay_model.dart';
import 'package:socialv/models/payment/stripe_payment_details_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/screens/pmp_order_detail_screen.dart';

import '../utils/app_constants.dart';

class StripeServices {
  num totalAmount = 0;
  String stripeURL = "";
  String stripePaymentKey = "";
  bool isTest = false;
  late BuildContext context;
  String levelId = "";
  String? discountCode = "";
  String mode = "";

  init({
    required String stripePaymentPublishKey,
    required num totalAmount,
    required String stripeURL,
    required String stripePaymentKey,
    required BuildContext context,
    required String levelId,
    required String? discountCode,
    required String mode,
  }) async {
    Stripe.publishableKey = stripePaymentPublishKey;
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';

    await Stripe.instance.applySettings().then((value) {}).catchError((e) {
      toast(e.toString(), print: true);

      throw e.toString();
    });

    this.totalAmount = totalAmount;
    this.stripeURL = stripeURL;
    this.stripePaymentKey = stripePaymentKey;
    this.isTest = isTest;
    this.context = context;
    this.levelId = levelId;
    this.discountCode = discountCode;
    this.mode = mode;
    setValue("StripeKeyPayment", stripePaymentKey);
  }

  //StripPayment
  void stripePay() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $stripePaymentKey',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    log('headers : $headers');

    var request = http.Request(HttpMethodType.POST.name, Uri.parse(stripeURL));

    request.bodyFields = {
      'amount': '${(totalAmount.toInt() * 100)}',
      'currency': STRIPE_CURRENCY_CODE,
      'description': 'Name: ${appStore.loginFullName} - Email: ${appStore.loginEmail}',
    };

    log(request.bodyFields);
    request.headers.addAll(headers);

    appStore.setLoading(true);

    await request.send().then((value) {
      appStore.setLoading(false);

      http.Response.fromStream(value).then((response) async {
        if (response.statusCode.isSuccessful()) {
          StripePayModel res = StripePayModel.fromJson(await handleResponse(response));

          log('res : ${res.id}');

          SetupPaymentSheetParameters setupPaymentSheetParameters = SetupPaymentSheetParameters(
            paymentIntentClientSecret: res.clientSecret.validate(),
            style: ThemeMode.dark,
            appearance: PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(primary: context.primaryColor)),
            applePay: PaymentSheetApplePay(merchantCountryCode: kReleaseMode ? STRIPE_MERCHANT_COUNTRY_CODE : STRIPE_MERCHANT_COUNTRY_CODE),
            googlePay: PaymentSheetGooglePay(merchantCountryCode: kReleaseMode ? STRIPE_MERCHANT_COUNTRY_CODE : STRIPE_MERCHANT_COUNTRY_CODE, testEnv: isTest),
            merchantDisplayName: APP_NAME,
            customerId: appStore.loginUserId.toString(),
            customerEphemeralKeySecret: isAndroid ? res.clientSecret.validate() : null,
            setupIntentClientSecret: res.clientSecret.validate(),
          );

          await Stripe.instance.initPaymentSheet(paymentSheetParameters: setupPaymentSheetParameters).then((value) async {
            await Stripe.instance.presentPaymentSheet().then((value) async {
              getStripePaymentDetails(
                totalAmount: totalAmount,
                discountCode: discountCode,
                id: res.id.validate(),
                stripePaymentKey: stripePaymentKey,
                stripeURL: stripeURL,
                levelId: levelId,
                context: context,
                mode: mode,
              );
              //finish(context);
            });
          });
        } else if (response.statusCode == 400) {
          toast("Testing Credential cannot pay more than 500");
        }
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);

      throw e.toString();
    });
  }
}

StripeServices stripeServices = StripeServices();

Future<void> getStripePaymentDetails({
  required String id,
  required num totalAmount,
  required String stripePaymentKey,
  required String stripeURL,
  required String levelId,
  String? discountCode,
  required BuildContext context,
  required String mode,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'Bearer $stripePaymentKey',
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
  };

  var request = http.Request(HttpMethodType.GET.name, Uri.parse('$stripeURL/$id'));
  request.headers.addAll(headers);

  request.send().then((value) async {
    http.Response.fromStream(value).then((response) async {
      if (response.statusCode.isSuccessful()) {
        StripePaymentDetailsModel res = StripePaymentDetailsModel.fromJson(await handleResponse(response));

        Map request = {
          "billing_amount": totalAmount,
          "billing_details": '',
          "card_details": {
            "card_name": "${res.charges!.data.validate().first.paymentMethodDetails!.card!.brand!.validate()}",
            "account_number": "${res.charges!.data.validate().first.paymentMethodDetails!.card!.last4!.validate()}",
            "exp_month": res.charges!.data.validate().first.paymentMethodDetails!.card!.expMonth!.validate(),
            "exp_year": res.charges!.data.validate().first.paymentMethodDetails!.card!.expYear!.validate(),
            "type": res.charges!.data.validate().first.paymentMethodDetails!.card!.funding!.validate()
          }, // for card payment else null
          "gateway": "stripe",
          "payment_by": "card",
          "email": appStore.loginEmail,
          "contact": '',
          "meta_value": "",
          "transaction_id": res.charges!.data.validate().first.balanceTransaction.validate(),
          "level_id": levelId,
          "discount_code": discountCode,
          "gateway_mode": mode,
          "coupon_amount": totalAmount,
        };

        log('REQ: $request');

        appStore.setLoading(true);
        generateOrder(request).then((order) async {
          await getMembershipLevelForUser(userId: appStore.loginUserId.validate().toInt()).then((value) {
            if (value != null) {
              pmpStore.setPmpMembership(levelId);
              setRestrictions(levelId: levelId);

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
    });
  });
}
