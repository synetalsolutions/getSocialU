class PaymentGatewayModel {
  PaymentGatewayModel({
    this.id,
    this.enable,
    this.mode,
    this.name,
    this.testing,
    this.live,
  });

  PaymentGatewayModel.fromJson(dynamic json) {
    id = json['id'];
    enable = json['enable'];
    mode = json['mode'];
    name = json['name'];
    testing = json['testing'] != null ? PaymentKeyModel.fromJson(json['testing']) : null;
    live = json['live'] != null ? PaymentKeyModel.fromJson(json['live']) : null;
  }

  String? id;
  int? enable;
  String? mode;
  String? name;
  PaymentKeyModel? testing;
  PaymentKeyModel? live;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['enable'] = enable;
    map['mode'] = mode;
    map['name'] = name;
    if (testing != null) {
      map['testing'] = testing!.toJson();
    }
    if (live != null) {
      map['live'] = live!.toJson();
    }
    return map;
  }
}

class PaymentKeyModel {
  PaymentKeyModel({
    this.url,
    this.key,
    this.publicKey,
  });

  PaymentKeyModel.fromJson(dynamic json) {
    url = json['url'];
    key = json['key'];
    publicKey = json['public_key'];
  }

  String? url;
  String? key;
  String? publicKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['key'] = key;
    map['public_key'] = publicKey;
    return map;
  }
}
