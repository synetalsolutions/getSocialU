class StripeCard {
  StripeCard({
    this.brand,
    this.country,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.last4,
    this.network,
  });

  StripeCard.fromJson(dynamic json) {
    brand = json['brand'];
    country = json['country'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    last4 = json['last4'];
    network = json['network'];
  }

  String? brand;
  String? country;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  String? last4;
  String? network;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['brand'] = brand;
    map['country'] = country;
    map['exp_month'] = expMonth;
    map['exp_year'] = expYear;
    map['fingerprint'] = fingerprint;
    map['funding'] = funding;
    map['last4'] = last4;
    map['network'] = network;
    return map;
  }
}
