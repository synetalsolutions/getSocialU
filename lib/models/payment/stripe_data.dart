import 'package:socialv/models/payment/stripe_payment_details_model.dart';

class StripeData {
  StripeData({
    this.id,
    this.object,
    this.amount,
    this.amountCaptured,
    this.amountRefunded,
    this.balanceTransaction,
    this.calculatedStatementDescriptor,
    this.captured,
    this.created,
    this.currency,
    this.description,
    this.disputed,
    this.paymentIntent,
    this.paymentMethod,
    this.paymentMethodDetails,
    this.paid,
    this.status,
  });

  StripeData.fromJson(dynamic json) {
    id = json['id'];
    object = json['object'];
    amount = json['amount'];
    amountCaptured = json['amount_captured'];
    amountRefunded = json['amount_refunded'];
    balanceTransaction = json['balance_transaction'];
    calculatedStatementDescriptor = json['calculated_statement_descriptor'];
    captured = json['captured'];
    created = json['created'];
    currency = json['currency'];
    description = json['description'];
    disputed = json['disputed'];
    paid = json['paid'];
    paymentIntent = json['payment_intent'];
    paymentMethod = json['payment_method'];
    paymentMethodDetails = (json['payment_method_details'] != null ? PaymentDetail.fromJson(json['payment_method_details']) : null)!;
    status = json['status'];
  }

  String? id;
  String? object;
  int? amount;
  int? amountCaptured;
  int? amountRefunded;
  String? balanceTransaction;
  String? calculatedStatementDescriptor;
  bool? captured;
  int? created;
  String? currency;
  String? description;
  bool? disputed;
  bool? paid;
  String? paymentIntent;
  String? paymentMethod;
  PaymentDetail? paymentMethodDetails;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['object'] = object;
    map['amount'] = amount;
    map['amount_captured'] = amountCaptured;
    map['amount_refunded'] = amountRefunded;
    map['balance_transaction'] = balanceTransaction;
    map['calculated_statement_descriptor'] = calculatedStatementDescriptor;
    map['captured'] = captured;
    map['created'] = created;
    map['currency'] = currency;
    map['description'] = description;
    map['disputed'] = disputed;
    map['paid'] = paid;
    map['payment_intent'] = paymentIntent;
    map['payment_method'] = paymentMethod;
    if (paymentMethodDetails != null) {
      map['payment_method_details'] = paymentMethodDetails!.toJson();
    }
    map['status'] = status;
    return map;
  }
}
