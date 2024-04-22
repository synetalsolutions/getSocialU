class PmpOrderModel {
  PmpOrderModel({
    this.id,
    this.code,
    this.userId,
    this.membershipId,
    this.membershipName,
    this.subtotal,
    this.tax,
    this.total,
    this.paymentType,
    this.cardtype,
    this.accountnumber,
    this.expirationmonth,
    this.expirationyear,
    this.status,
    this.gateway,
    this.gatewayEnvironment,
    this.paymentTransactionId,
    this.subscriptionTransactionId,
    this.timestamp,
    this.affiliateId,
    this.affiliateSubid,
    this.notes,
    this.checkoutId,
    this.discountCode,
  });

  PmpOrderModel.fromJson(dynamic json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    subtotal = json['subtotal'];
    tax = json['tax'];
    total = json['total'];
    paymentType = json['payment_type'];
    cardtype = json['cardtype'];
    accountnumber = json['accountnumber'];
    expirationmonth = json['expirationmonth'];
    expirationyear = json['expirationyear'];
    status = json['status'];
    gateway = json['gateway'];
    gatewayEnvironment = json['gateway_environment'];
    paymentTransactionId = json['payment_transaction_id'];
    subscriptionTransactionId = json['subscription_transaction_id'];
    timestamp = json['timestamp'];
    affiliateId = json['affiliate_id'];
    affiliateSubid = json['affiliate_subid'];
    notes = json['notes'];
    checkoutId = json['checkout_id'];
    discountCode = json['discount_code'];
  }

  String? id;
  String? code;
  String? userId;
  String? membershipId;
  String? membershipName;
  String? subtotal;
  String? tax;
  String? total;
  String? paymentType;
  String? cardtype;
  String? accountnumber;
  String? expirationmonth;
  String? expirationyear;
  String? status;
  String? gateway;
  String? gatewayEnvironment;
  String? paymentTransactionId;
  String? subscriptionTransactionId;
  String? timestamp;
  String? affiliateId;
  String? affiliateSubid;
  String? notes;
  String? checkoutId;
  String? discountCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['user_id'] = userId;
    map['membership_id'] = membershipId;
    map['membership_name'] = membershipName;
    map['subtotal'] = subtotal;
    map['tax'] = tax;
    map['total'] = total;
    map['payment_type'] = paymentType;
    map['cardtype'] = cardtype;
    map['accountnumber'] = accountnumber;
    map['expirationmonth'] = expirationmonth;
    map['expirationyear'] = expirationyear;
    map['status'] = status;
    map['gateway'] = gateway;
    map['gateway_environment'] = gatewayEnvironment;
    map['payment_transaction_id'] = paymentTransactionId;
    map['subscription_transaction_id'] = subscriptionTransactionId;
    map['timestamp'] = timestamp;
    map['affiliate_id'] = affiliateId;
    map['affiliate_subid'] = affiliateSubid;
    map['notes'] = notes;
    map['checkout_id'] = checkoutId;
    map['discount_code'] = discountCode;
    return map;
  }
}
