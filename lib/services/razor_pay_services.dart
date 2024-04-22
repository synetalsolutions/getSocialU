import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/payment/razorpay_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/screens/pmp_order_detail_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class RazorPayServices {
  static late Razorpay razorPay;
  static late String razorKeys;
  static late String razorUrl;
  static late String razorSecret;
  static num totalAmount = 0;
  static String levelId = '';
  static String? discountCode = '';
  static late BuildContext context;
  static String mode = '';

  static init({
    required String razorKey,
    required String url,
    required String secret,
    required num amount,
    required String planId,
    required String? disCode,
    required BuildContext ctx,
    required String paymentMode,
  }) {
    razorKeys = razorKey;
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, RazorPayServices.handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, RazorPayServices.handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, RazorPayServices.handleExternalWallet);
    totalAmount = amount;
    levelId = planId;
    discountCode = disCode;
    context = ctx;
    mode = paymentMode;
    razorUrl = url;
    razorSecret = secret;
  }

  static void handlePaymentSuccess(PaymentSuccessResponse response) async {
    getRazorPaymentDetails(
      amount: totalAmount,
      id: response.paymentId.validate(),
      levelId: levelId,
      disCode: discountCode,
      context: context,
      mode: mode,
      key: razorKeys,
      secretKey: razorSecret,
      url: razorUrl,
    );
  }

  static void handlePaymentError(PaymentFailureResponse response) {
    toast("Error: " + response.code.toString() + " - " + response.message!, print: true);
    appStore.setLoading(false);
  }

  static void handleExternalWallet(ExternalWalletResponse response) {
    getRazorPaymentDetails(
      amount: totalAmount,
      externalWallet: response.walletName!,
      levelId: levelId,
      disCode: discountCode,
      context: context,
      mode: mode,
      key: razorKeys,
      secretKey: razorSecret,
      url: razorUrl,
    );
    toast("externalWallet: " + response.walletName!);
  }

  static void razorPayCheckout(num mAmount) async {
    log('razorPay AMOUNT: $mAmount');
    var options = {
      'key': razorKeys,
      'amount': (mAmount * 100),
      'name': APP_NAME,
      'theme.color': appColorPrimary.toHex(),
      'description': '',
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'currency': RAZORPAY_CURRENCY_CODE,
      'prefill': {'contact': '', 'email': appStore.loginEmail},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future<void> getRazorPaymentDetails({
  String? id,
  String? externalWallet,
  required String levelId,
  required num amount,
  String? disCode,
  required BuildContext context,
  required String mode,
  required String url,
  required String key,
  required String secretKey,
}) async {
  final String apiUrl = '$url/$id';
  final String keyId = key;
  final String keySecret = secretKey;
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));
  print(basicAuth);

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Authorization': basicAuth},
  );
  if (response.statusCode.isSuccessful()) {
    RazorPayModel res = RazorPayModel.fromJson(await handleResponse(response));

    String meta = '';
    String transactionId = '';

    if (res.method == PaymentMethods.upi) {
      meta = res.vpa.validate();
      transactionId = res.acquirerData!.upiTransactionId.validate();
    } else if (res.method == PaymentMethods.netBanking) {
      meta = res.bank.validate();
      transactionId = res.acquirerData!.bankTransactionId.validate();
    } else if (res.method == PaymentMethods.paylater) {
      meta = res.wallet.validate();
    } else {
      //
    }

    Map request = {
      "billing_amount": amount,
      "billing_details": '',
      "card_details": res.method == 'card'
          ? {"card_name": "${res.card!.network}", "account_number": res.card!.last4.validate(), "exp_month": "", "exp_year": "", "type": res.card!.type.validate()}
          : null, // for card payment else null
      "gateway": "razorpay",
      "payment_by": res.method,
      "email": appStore.loginEmail,
      "contact": '',
      "meta_value": meta,
      "transaction_id": transactionId,
      "level_id": levelId,
      "discount_code": disCode,
      "gateway_mode": mode,
      "coupon_amount": amount,
    };

    log('REQ: $request');

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
}
