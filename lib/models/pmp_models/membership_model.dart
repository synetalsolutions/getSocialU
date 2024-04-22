import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/pmp_models/bp_level_options.dart';

class MembershipModel {
  MembershipModel({
    this.id,
    this.subscriptionId,
    this.name,
    this.description,
    this.confirmation,
    this.expirationNumber,
    this.expirationPeriod,
    this.allowSignups,
    this.initialPayment,
    this.billingAmount,
    this.cycleNumber,
    this.cyclePeriod,
    this.billingLimit,
    this.trialAmount,
    this.trialLimit,
    this.codeId,
    this.startdate,
    this.enddate,
    this.categories,
    this.bpLevelOptions,
    this.isInitial,
    this.isExpired,
  });

  MembershipModel.fromJson(dynamic json) {
    id = json['id'].toString();
    subscriptionId = json['subscription_id'];
    name = json['name'];
    description = json['description'];
    confirmation = json['confirmation'];
    expirationNumber = json['expiration_number'].toString();
    expirationPeriod = json['expiration_period'];
    allowSignups = json['allow_signups'];
    initialPayment = json['initial_payment'];
    billingAmount = json['billing_amount'];
    cycleNumber = json['cycle_number'].toString();
    cyclePeriod = json['cycle_period'];
    billingLimit = json['billing_limit'].toString();
    trialAmount = json['trial_amount'];
    trialLimit = json['trial_limit'].toString();
    codeId = json['code_id'];
    startdate = json['startdate'];
    isInitial = json['is_initial'];
    isExpired = json['is_expired'];
    enddate = json['enddate'].toString().toInt();
    bpLevelOptions = json['bp_level_options'] != null ? BpLevelOptions.fromJson(json['bp_level_options']) : null;
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(v);
      });
    }
  }

  String? id;
  String? subscriptionId;
  String? name;
  String? description;
  String? confirmation;
  String? expirationNumber;
  String? expirationPeriod;
  String? allowSignups;
  int? initialPayment;
  int? billingAmount;
  String? cycleNumber;
  String? cyclePeriod;
  String? billingLimit;
  int? trialAmount;
  String? trialLimit;
  String? codeId;
  String? startdate;
  int? enddate;
  List<dynamic>? categories;
  BpLevelOptions? bpLevelOptions;
  bool? isInitial;
  bool? isExpired;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['subscription_id'] = subscriptionId;
    map['name'] = name;
    map['description'] = description;
    map['confirmation'] = confirmation;
    map['expiration_number'] = expirationNumber;
    map['expiration_period'] = expirationPeriod;
    map['allow_signups'] = allowSignups;
    map['initial_payment'] = initialPayment;
    map['billing_amount'] = billingAmount;
    map['cycle_number'] = cycleNumber;
    map['cycle_period'] = cyclePeriod;
    map['billing_limit'] = billingLimit;
    map['trial_amount'] = trialAmount;
    map['trial_limit'] = trialLimit;
    map['code_id'] = codeId;
    map['startdate'] = startdate;
    map['enddate'] = enddate;
    map['is_initial'] = isInitial;
    map['is_expired'] = isExpired;
    if (categories != null) {
      map['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (bpLevelOptions != null) {
      map['bp_level_options'] = bpLevelOptions!.toJson();
    }
    return map;
  }
}
