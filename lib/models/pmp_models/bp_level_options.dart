class BpLevelOptions {
  BpLevelOptions({
    this.pmproBpRestrictions,
    this.pmproBpGroupCreation,
    this.pmproBpGroupSingleViewing,
    this.pmproBpGroupsPageViewing,
    this.pmproBpGroupsJoin,
    this.pmproBpPrivateMessaging,
    this.pmproBpPublicMessaging,
    this.pmproBpSendFriendRequest,
    this.pmproBpMemberDirectory,
    this.pmproBpGroupAutomaticAdd,
    this.pmproBpGroupCanRequestInvite,
    this.pmproBpMemberTypes,
  });

  BpLevelOptions.fromJson(dynamic json) {
    pmproBpRestrictions = json['pmpro_bp_restrictions'];
    pmproBpGroupCreation = json['pmpro_bp_group_creation'];
    pmproBpGroupSingleViewing = json['pmpro_bp_group_single_viewing'];
    pmproBpGroupsPageViewing = json['pmpro_bp_groups_page_viewing'];
    pmproBpGroupsJoin = json['pmpro_bp_groups_join'];
    pmproBpPrivateMessaging = json['pmpro_bp_private_messaging'];
    pmproBpPublicMessaging = json['pmpro_bp_public_messaging'];
    pmproBpSendFriendRequest = json['pmpro_bp_send_friend_request'];
    pmproBpMemberDirectory = json['pmpro_bp_member_directory'];
    pmproBpGroupAutomaticAdd = json['pmpro_bp_group_automatic_add'];
    pmproBpGroupCanRequestInvite = json['pmpro_bp_group_can_request_invite'];
    pmproBpMemberTypes = json['pmpro_bp_member_types'];
  }

  int? pmproBpRestrictions;
  int? pmproBpGroupCreation;
  int? pmproBpGroupSingleViewing;
  int? pmproBpGroupsPageViewing;
  int? pmproBpGroupsJoin;
  int? pmproBpPrivateMessaging;
  int? pmproBpPublicMessaging;
  int? pmproBpSendFriendRequest;
  int? pmproBpMemberDirectory;
  var pmproBpGroupAutomaticAdd;
  var pmproBpGroupCanRequestInvite;
  var pmproBpMemberTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pmpro_bp_restrictions'] = pmproBpRestrictions;
    map['pmpro_bp_group_creation'] = pmproBpGroupCreation;
    map['pmpro_bp_group_single_viewing'] = pmproBpGroupSingleViewing;
    map['pmpro_bp_groups_page_viewing'] = pmproBpGroupsPageViewing;
    map['pmpro_bp_groups_join'] = pmproBpGroupsJoin;
    map['pmpro_bp_private_messaging'] = pmproBpPrivateMessaging;
    map['pmpro_bp_public_messaging'] = pmproBpPublicMessaging;
    map['pmpro_bp_send_friend_request'] = pmproBpSendFriendRequest;
    map['pmpro_bp_member_directory'] = pmproBpMemberDirectory;
    map['pmpro_bp_group_automatic_add'] = pmproBpGroupAutomaticAdd;
    map['pmpro_bp_group_can_request_invite'] = pmproBpGroupCanRequestInvite;
    map['pmpro_bp_member_types'] = pmproBpMemberTypes;
    return map;
  }
}
