import 'package:socialv/models/pmp_models/membership_model.dart';

class DiscountCode {
  DiscountCode({
    this.id,
    this.code,
    this.starts,
    this.expires,
    this.uses,
    this.plans,
  });

  DiscountCode.fromJson(dynamic json) {
    id = json['id'];
    code = json['code'];
    starts = json['starts'];
    expires = json['expires'];
    uses = json['uses'];
    plans = json['plans'] != null ? (json['plans'] as List).map((i) => MembershipModel.fromJson(i)).toList() : null;
  }

  int? id;
  String? code;
  String? starts;
  String? expires;
  int? uses;
  List<MembershipModel>? plans;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['starts'] = starts;
    map['expires'] = expires;
    map['uses'] = uses;
    if (map['plans'] != null) {
      map['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
