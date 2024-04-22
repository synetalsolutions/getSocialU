class RazorpayCard {
  RazorpayCard({
    this.id,
    this.entity,
    this.name,
    this.last4,
    this.network,
    this.type,
    this.subType,
  });

  RazorpayCard.fromJson(dynamic json) {
    id = json['id'];
    entity = json['entity'];
    name = json['name'];
    last4 = json['last4'];
    network = json['network'];
    type = json['type'];
    subType = json['sub_type'];
  }

  String? id;
  String? entity;
  String? name;
  String? last4;
  String? network;
  String? type;
  String? subType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['entity'] = entity;
    map['name'] = name;
    map['last4'] = last4;
    map['network'] = network;
    map['type'] = type;
    map['sub_type'] = subType;
    return map;
  }
}
