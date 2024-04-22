
import 'package:socialv/models/payment/razorpay_card.dart';

class RazorPayModel {
  RazorPayModel({
    this.id,
    this.amount,
    this.currency,
    this.status,
    this.international,
    this.method,
    this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.acquirerData,
    this.createdAt,
    this.card,
  });

  RazorPayModel.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    international = json['international'];
    method = json['method'];
    cardId = json['card_id'];
    bank = json['bank'];
    wallet = json['wallet'];
    vpa = json['vpa'];
    email = json['email'];
    contact = json['contact'];
    acquirerData = json['acquirer_data'] != null ? AcquirerData.fromJson(json['acquirer_data']) : null;
    createdAt = json['created_at'];
    card = json['card'] != null ? RazorpayCard.fromJson(json['card']) : null;
  }

  String? id;
  int? amount;
  String? currency;
  String? status;
  bool? international;
  String? method;
  String? cardId;
  String? bank;
  String? wallet;
  String? vpa;
  String? email;
  String? contact;
  AcquirerData? acquirerData;
  RazorpayCard? card;
  int? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['currency'] = currency;
    map['status'] = status;
    map['international'] = international;
    map['method'] = method;
    map['card_id'] = cardId;
    map['bank'] = bank;
    map['wallet'] = wallet;
    map['vpa'] = vpa;
    map['email'] = email;
    map['contact'] = contact;
    if (acquirerData != null) {
      map['acquirer_data'] = acquirerData!.toJson();
    }
    if (card != null) {
      map['card'] = card!.toJson();
    }
    map['created_at'] = createdAt;
    return map;
  }
}

class AcquirerData {
  AcquirerData({this.transactionId, this.upiTransactionId});

  AcquirerData.fromJson(dynamic json) {
    transactionId = json['transaction_id'];
    upiTransactionId = json['upi_transaction_id'];
    bankTransactionId = json['bank_transaction_id'];
  }

  String? transactionId;
  String? upiTransactionId;
  String? bankTransactionId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transaction_id'] = transactionId;
    map['upi_transaction_id'] = upiTransactionId;
    map['bank_transaction_id'] = bankTransactionId;
    return map;
  }
}
