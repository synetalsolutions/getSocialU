import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

part 'pmp_store.g.dart';

class PmpStore = PmpStoreBase with _$PmpStore;

abstract class PmpStoreBase with Store {
  @observable
  String? pmpMembership;

  @observable
  String? pmpCurrency = '\$';

  @observable
  bool pmpEnable = false;

  @observable
  bool canCreateGroup = true;

  @observable
  bool viewSingleGroup = true;

  @observable
  bool viewGroups = true;

  @observable
  bool canJoinGroup = true;

  @observable
  bool privateMessaging = true;

  @observable
  bool publicMessaging = true;

  @observable
  bool sendFriendRequest = true;

  @observable
  bool memberDirectory = true;

  @action
  Future<void> setCanCreateGroup(bool val) async {
    canCreateGroup = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setMemberDirectory(bool val) async {
    memberDirectory = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setSendFriendRequest(bool val) async {
    sendFriendRequest = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setPublicMessaging(bool val) async {
    publicMessaging = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setPrivateMessaging(bool val) async {
    privateMessaging = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setCanJoinGroup(bool val) async {
    canJoinGroup = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setViewGroups(bool val) async {
    viewGroups = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setViewSingleGroup(bool val) async {
    viewSingleGroup = val || appStore.loginEmail == DEMO_USER_EMAIL;
  }

  @action
  Future<void> setPmpEnable(bool val, {bool isInitializing = false}) async {
    pmpEnable = val;
    if (!isInitializing) await setValue(SharePreferencesKey.PMP_ENABLE, val);
  }

  @action
  Future<void> setPmpCurrency(String? currency) async {
    pmpCurrency = currency;
    await setValue(SharePreferencesKey.PMP_CURRENCY, currency);
  }

  @action
  Future<void> setPmpMembership(String? val, {bool isInitializing = false}) async {
    pmpMembership = val;
    if (!isInitializing) await setValue(SharePreferencesKey.PMP_MEMBERSHIP, val);
  }
}
