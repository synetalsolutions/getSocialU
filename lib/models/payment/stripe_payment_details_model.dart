
import 'package:socialv/models/payment/stripe_card.dart';
import 'package:socialv/models/payment/stripe_data.dart';

class StripePaymentDetailsModel {
  StripePaymentDetailsModel({
    this.id,
    this.object,
    this.amount,
    this.amountReceived,
    this.captureMethod,
    this.charges,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
    this.description,
    this.latestCharge,
    this.paymentMethod,
    this.paymentMethodTypes,
    this.status,
  });

  StripePaymentDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    object = json['object'];
    amount = json['amount'];
    amountReceived = json['amount_received'];
    captureMethod = json['capture_method'];
    charges = (json['charges'] != null ? Charges.fromJson(json['charges']) : null)!;
    clientSecret = json['client_secret'];
    confirmationMethod = json['confirmation_method'];
    created = json['created'];
    currency = json['currency'];
    description = json['description'];
    latestCharge = json['latest_charge'];
    paymentMethod = json['payment_method'];
    paymentMethodTypes = json['payment_method_types'] != null ? json['payment_method_types'].cast<String>() : [];
    status = json['status'];
  }

  String? id;
  String? object;
  int? amount;
  int? amountReceived;
  String? captureMethod;
  Charges? charges;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  String? description;
  String? latestCharge;
  String? paymentMethod;
  List<String>? paymentMethodTypes;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['object'] = object;
    map['amount'] = amount;
    map['amount_received'] = amountReceived;
    map['capture_method'] = captureMethod;
    if (charges != null) {
      map['charges'] = charges!.toJson();
    }
    map['client_secret'] = clientSecret;
    map['confirmation_method'] = confirmationMethod;
    map['created'] = created;
    map['currency'] = currency;
    map['description'] = description;
    map['latest_charge'] = latestCharge;
    map['payment_method'] = paymentMethod;
    map['payment_method_types'] = paymentMethodTypes;
    map['status'] = status;
    return map;
  }
}

class PaymentDetail {
  PaymentDetail({
    this.card,
    this.type,
  });

  PaymentDetail.fromJson(dynamic json) {
    card = json['card'] != null ? StripeCard.fromJson(json['card']) : null;
    type = json['type'];
  }

  StripeCard? card;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (card != null) {
      map['card'] = card!.toJson();
    }
    map['type'] = type;
    return map;
  }
}

class Charges {
  Charges({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  Charges.fromJson(dynamic json) {
    object = json['object'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(StripeData.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    totalCount = json['total_count'];
    url = json['url'];
  }

  String? object;
  List<StripeData>? data;
  bool? hasMore;
  int? totalCount;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['object'] = object;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['has_more'] = hasMore;
    map['total_count'] = totalCount;
    map['url'] = url;
    return map;
  }
}
