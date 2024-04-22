import 'dart:math';

import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/calls/call_model.dart';
import 'package:socialv/models/calls/user_model.dart';
import 'package:socialv/screens/messages/calls/agora_video_call_screen.dart';

class CallFunctions {
  static dial({
    required context,
    required UserModel from,
    required UserModel to,
    required int messageId,
    required int threadId,
    required String callType,
  }) async {
    CallModel callModel = CallModel(
      callerId: from.uid,
      callerName: from.name,
      callerPhotoUrl: from.photoUrl,
      channelId: Random().nextInt(1000).toString(),
      receiverId: to.uid,
      receiverName: to.name,
      receiverPhotoUrl: to.photoUrl,
      threadId: threadId,
      messageId: messageId,
      callType: callType,
    );

    bool callMade = await callService.makeCall(callModel: callModel);
    callModel.hasDialed = true;
    if (callMade) {
      appStore.setLoading(false);
      AgoraVideoCallScreen(callModel: callModel, isReceiver: false).launch(context);
    }
  }
}
