class GeneralSettingsModel {
  GeneralSettingsModel({
    this.isAccountVerificationRequire,
    this.isPaidMembershipEnable,
  });

  GeneralSettingsModel.fromJson(dynamic json) {
    isAccountVerificationRequire = json['is_account_verification_require'];
    isPaidMembershipEnable = json['is_paid_membership_enable'];
    showAds = json['show_ads'];
    showBlogs = json['show_blogs'];
    showSocialLogin = json['show_social_login'];
    showShop = json['show_shop'];
    showGamiPress = json['show_gamipress'];
    showLearnPress = json['show_learnpress'];
    showMemberShip = json['show_membership'];
    showForums = json['show_forums'];
  }

  int? isAccountVerificationRequire;
  bool? isPaidMembershipEnable;

  int? showAds;

  int? showBlogs;

  int? showSocialLogin;

  int? showShop;

  int? showGamiPress;

  int? showLearnPress;

  int? showMemberShip;

  int? showForums;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_account_verification_require'] = isAccountVerificationRequire;
    map['is_paid_membership_enable'] = isPaidMembershipEnable;
    map['show_ads'] = showAds;
    map['show_blogs'] = showBlogs;
    map['show_social_login'] = showSocialLogin;
    map['show_shop'] = showShop;
    map['show_gamipress'] = showGamiPress;
    map['show_learnpress'] = showLearnPress;
    map['show_membership'] = showMemberShip;
    map['show_forums'] = showForums;
    return map;
  }
}
