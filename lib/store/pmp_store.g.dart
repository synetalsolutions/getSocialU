// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pmp_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PmpStore on PmpStoreBase, Store {
  late final _$pmpMembershipAtom =
      Atom(name: 'PmpStoreBase.pmpMembership', context: context);

  @override
  String? get pmpMembership {
    _$pmpMembershipAtom.reportRead();
    return super.pmpMembership;
  }

  @override
  set pmpMembership(String? value) {
    _$pmpMembershipAtom.reportWrite(value, super.pmpMembership, () {
      super.pmpMembership = value;
    });
  }

  late final _$pmpCurrencyAtom =
      Atom(name: 'PmpStoreBase.pmpCurrency', context: context);

  @override
  String? get pmpCurrency {
    _$pmpCurrencyAtom.reportRead();
    return super.pmpCurrency;
  }

  @override
  set pmpCurrency(String? value) {
    _$pmpCurrencyAtom.reportWrite(value, super.pmpCurrency, () {
      super.pmpCurrency = value;
    });
  }

  late final _$pmpEnableAtom =
      Atom(name: 'PmpStoreBase.pmpEnable', context: context);

  @override
  bool get pmpEnable {
    _$pmpEnableAtom.reportRead();
    return super.pmpEnable;
  }

  @override
  set pmpEnable(bool value) {
    _$pmpEnableAtom.reportWrite(value, super.pmpEnable, () {
      super.pmpEnable = value;
    });
  }

  late final _$canCreateGroupAtom =
      Atom(name: 'PmpStoreBase.canCreateGroup', context: context);

  @override
  bool get canCreateGroup {
    _$canCreateGroupAtom.reportRead();
    return super.canCreateGroup;
  }

  @override
  set canCreateGroup(bool value) {
    _$canCreateGroupAtom.reportWrite(value, super.canCreateGroup, () {
      super.canCreateGroup = value;
    });
  }

  late final _$viewSingleGroupAtom =
      Atom(name: 'PmpStoreBase.viewSingleGroup', context: context);

  @override
  bool get viewSingleGroup {
    _$viewSingleGroupAtom.reportRead();
    return super.viewSingleGroup;
  }

  @override
  set viewSingleGroup(bool value) {
    _$viewSingleGroupAtom.reportWrite(value, super.viewSingleGroup, () {
      super.viewSingleGroup = value;
    });
  }

  late final _$viewGroupsAtom =
      Atom(name: 'PmpStoreBase.viewGroups', context: context);

  @override
  bool get viewGroups {
    _$viewGroupsAtom.reportRead();
    return super.viewGroups;
  }

  @override
  set viewGroups(bool value) {
    _$viewGroupsAtom.reportWrite(value, super.viewGroups, () {
      super.viewGroups = value;
    });
  }

  late final _$canJoinGroupAtom =
      Atom(name: 'PmpStoreBase.canJoinGroup', context: context);

  @override
  bool get canJoinGroup {
    _$canJoinGroupAtom.reportRead();
    return super.canJoinGroup;
  }

  @override
  set canJoinGroup(bool value) {
    _$canJoinGroupAtom.reportWrite(value, super.canJoinGroup, () {
      super.canJoinGroup = value;
    });
  }

  late final _$privateMessagingAtom =
      Atom(name: 'PmpStoreBase.privateMessaging', context: context);

  @override
  bool get privateMessaging {
    _$privateMessagingAtom.reportRead();
    return super.privateMessaging;
  }

  @override
  set privateMessaging(bool value) {
    _$privateMessagingAtom.reportWrite(value, super.privateMessaging, () {
      super.privateMessaging = value;
    });
  }

  late final _$publicMessagingAtom =
      Atom(name: 'PmpStoreBase.publicMessaging', context: context);

  @override
  bool get publicMessaging {
    _$publicMessagingAtom.reportRead();
    return super.publicMessaging;
  }

  @override
  set publicMessaging(bool value) {
    _$publicMessagingAtom.reportWrite(value, super.publicMessaging, () {
      super.publicMessaging = value;
    });
  }

  late final _$sendFriendRequestAtom =
      Atom(name: 'PmpStoreBase.sendFriendRequest', context: context);

  @override
  bool get sendFriendRequest {
    _$sendFriendRequestAtom.reportRead();
    return super.sendFriendRequest;
  }

  @override
  set sendFriendRequest(bool value) {
    _$sendFriendRequestAtom.reportWrite(value, super.sendFriendRequest, () {
      super.sendFriendRequest = value;
    });
  }

  late final _$memberDirectoryAtom =
      Atom(name: 'PmpStoreBase.memberDirectory', context: context);

  @override
  bool get memberDirectory {
    _$memberDirectoryAtom.reportRead();
    return super.memberDirectory;
  }

  @override
  set memberDirectory(bool value) {
    _$memberDirectoryAtom.reportWrite(value, super.memberDirectory, () {
      super.memberDirectory = value;
    });
  }

  late final _$setCanCreateGroupAsyncAction =
      AsyncAction('PmpStoreBase.setCanCreateGroup', context: context);

  @override
  Future<void> setCanCreateGroup(bool val) {
    return _$setCanCreateGroupAsyncAction
        .run(() => super.setCanCreateGroup(val));
  }

  late final _$setMemberDirectoryAsyncAction =
      AsyncAction('PmpStoreBase.setMemberDirectory', context: context);

  @override
  Future<void> setMemberDirectory(bool val) {
    return _$setMemberDirectoryAsyncAction
        .run(() => super.setMemberDirectory(val));
  }

  late final _$setSendFriendRequestAsyncAction =
      AsyncAction('PmpStoreBase.setSendFriendRequest', context: context);

  @override
  Future<void> setSendFriendRequest(bool val) {
    return _$setSendFriendRequestAsyncAction
        .run(() => super.setSendFriendRequest(val));
  }

  late final _$setPublicMessagingAsyncAction =
      AsyncAction('PmpStoreBase.setPublicMessaging', context: context);

  @override
  Future<void> setPublicMessaging(bool val) {
    return _$setPublicMessagingAsyncAction
        .run(() => super.setPublicMessaging(val));
  }

  late final _$setPrivateMessagingAsyncAction =
      AsyncAction('PmpStoreBase.setPrivateMessaging', context: context);

  @override
  Future<void> setPrivateMessaging(bool val) {
    return _$setPrivateMessagingAsyncAction
        .run(() => super.setPrivateMessaging(val));
  }

  late final _$setCanJoinGroupAsyncAction =
      AsyncAction('PmpStoreBase.setCanJoinGroup', context: context);

  @override
  Future<void> setCanJoinGroup(bool val) {
    return _$setCanJoinGroupAsyncAction.run(() => super.setCanJoinGroup(val));
  }

  late final _$setViewGroupsAsyncAction =
      AsyncAction('PmpStoreBase.setViewGroups', context: context);

  @override
  Future<void> setViewGroups(bool val) {
    return _$setViewGroupsAsyncAction.run(() => super.setViewGroups(val));
  }

  late final _$setViewSingleGroupAsyncAction =
      AsyncAction('PmpStoreBase.setViewSingleGroup', context: context);

  @override
  Future<void> setViewSingleGroup(bool val) {
    return _$setViewSingleGroupAsyncAction
        .run(() => super.setViewSingleGroup(val));
  }

  late final _$setPmpEnableAsyncAction =
      AsyncAction('PmpStoreBase.setPmpEnable', context: context);

  @override
  Future<void> setPmpEnable(bool val, {bool isInitializing = false}) {
    return _$setPmpEnableAsyncAction
        .run(() => super.setPmpEnable(val, isInitializing: isInitializing));
  }

  late final _$setPmpCurrencyAsyncAction =
      AsyncAction('PmpStoreBase.setPmpCurrency', context: context);

  @override
  Future<void> setPmpCurrency(String? currency) {
    return _$setPmpCurrencyAsyncAction
        .run(() => super.setPmpCurrency(currency));
  }

  late final _$setPmpMembershipAsyncAction =
      AsyncAction('PmpStoreBase.setPmpMembership', context: context);

  @override
  Future<void> setPmpMembership(String? val, {bool isInitializing = false}) {
    return _$setPmpMembershipAsyncAction
        .run(() => super.setPmpMembership(val, isInitializing: isInitializing));
  }

  @override
  String toString() {
    return '''
pmpMembership: ${pmpMembership},
pmpCurrency: ${pmpCurrency},
pmpEnable: ${pmpEnable},
canCreateGroup: ${canCreateGroup},
viewSingleGroup: ${viewSingleGroup},
viewGroups: ${viewGroups},
canJoinGroup: ${canJoinGroup},
privateMessaging: ${privateMessaging},
publicMessaging: ${publicMessaging},
sendFriendRequest: ${sendFriendRequest},
memberDirectory: ${memberDirectory}
    ''';
  }
}
