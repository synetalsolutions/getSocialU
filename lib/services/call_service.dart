import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/calls/call_model.dart';
import 'package:socialv/services/base_service.dart';

class CallService extends BaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  CallService() {
    ref = fireStore.collection("call");
  }

  Stream<DocumentSnapshot> callStream({String? uid}) {
    return ref!.doc(uid).snapshots();
  }

  Future<bool> makeCall({required CallModel callModel, bool isVoiceCall = false}) async {
    try {
      callModel.hasDialed = true;
      callModel.isVoice = isVoiceCall;
      Map<String, dynamic> hasDialedMap = callModel.toJson();
      callModel.hasDialed = false;

      Map<String, dynamic> hasNotDialedMap = callModel.toJson();

      log("=========================$hasDialedMap =========================");
      log("=========================$hasNotDialedMap =========================");

      await ref!.doc(callModel.callerId).set(hasDialedMap);
      await ref!.doc(callModel.receiverId).set(hasNotDialedMap);
      return true;
    } on Exception catch (e) {
      log(e);
      return false;
    }
  }

  Future<bool> endCall({required CallModel callModel}) async {
    try {
      log('endCall ----------- ');

      await ref!.doc(callModel.callerId).delete();
      await ref!.doc(callModel.receiverId).delete();
      return true;
    } on Exception catch (e) {
      log(e);
      return false;
    }
  }
}
