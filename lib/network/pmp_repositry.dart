import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/bp_level_options.dart';
import 'package:socialv/models/pmp_models/discount_code_model.dart';
import 'package:socialv/models/pmp_models/membership_model.dart';
import 'package:socialv/models/pmp_models/payment_gateway_model.dart';
import 'package:socialv/models/pmp_models/pmp_order_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/utils/app_constants.dart';

Future<dynamic> getMembershipLevelForUser({required int userId}) async {
  var value = await handleResponse(await buildHttpResponse('${PMPAPIEndPoint.getMembershipLevelForUser}?user_id=$userId'));

  if (value == false) {
    return null;
  } else {
    return value;
  }
}

Future<void> changeMembershipLevel({required String levelId}) async {
  await handleResponse(await buildHttpResponse('${PMPAPIEndPoint.changeMembershipLevel}?user_id=${appStore.loginUserId}&level_id=$levelId', method: HttpMethod.POST));
}

Future<void> cancelMembershipLevel({required String levelId}) async {
  await handleResponse(await buildHttpResponse('${PMPAPIEndPoint.cancelMembershipLevel}?user_id=${appStore.loginUserId}&level_id=$levelId', method: HttpMethod.POST));
}

Future<List<MembershipModel>> getLevelsList() async {
  Iterable it = await (await handleResponse(await buildHttpResponse(PMPAPIEndPoint.membershipLevels)));
  return it.map((e) => MembershipModel.fromJson(e)).toList();
}

Future<PmpOrderModel> generateOrder(Map request) async {
  return PmpOrderModel.fromJson(await handleResponse(await buildHttpResponse(PMPAPIEndPoint.order, request: request, method: HttpMethod.POST)));
}

Future<List<PmpOrderModel>> pmpOrders({int page = 1}) async {
  Iterable it = await (handleResponse(await buildHttpResponse('${PMPAPIEndPoint.membershipOrders}?page=$page&per_page=20')));
  return it.map((e) => PmpOrderModel.fromJson(e)).toList();
}

Future<List<PaymentGatewayModel>> paymentsList() async {
  Iterable it = await (await handleResponse(await buildHttpResponse(PMPAPIEndPoint.paymentGateway)));
  return it.map((e) => PaymentGatewayModel.fromJson(e)).toList();
}

Future<BpLevelOptions> restrictions({String? levelId}) async {
  return BpLevelOptions.fromJson(
    await handleResponse(await buildHttpResponse('${PMPAPIEndPoint.restrictions}${levelId.validate().isNotEmpty ? '?level_id=$levelId' : ''}')),
  );
}

Future<List<DiscountCode>> getDiscountCodeList({required String planId}) async {
  Iterable it = await (await handleResponse(await buildHttpResponse('${PMPAPIEndPoint.discountCodes}?level_id=$planId')));
  return it.map((e) => DiscountCode.fromJson(e)).toList();
}
