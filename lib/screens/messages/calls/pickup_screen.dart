import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/calls/call_model.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/call/permissions.dart';
import 'agora_video_call_screen.dart';

bool isPickUpScreenLaunched = false;

class PickUpScreen extends StatefulWidget {
  final CallModel? callModel;

  PickUpScreen({this.callModel});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  @override
  void initState() {
    isPickUpScreenLaunched = true;
    super.initState();
  }

  Future<void> onCallReject() async {
    await callService.endCall(callModel: widget.callModel!);

    if (appStore.isWebsocketEnable == 1 && messageStore.webSocketReady) {
      String message = '42["${SocketEvents.mediaEvent}",{"event":"${SocketEvents.rejected}","to":${widget.callModel!.callerId},"thread_id":${widget.callModel!.threadId}}]';
      log('Send Message: $message');

      channel?.sink.add(message);
    }
  }

  @override
  void dispose() {
    isPickUpScreenLaunched = false;
    onCallReject();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            SizedBox(
              width: context.width(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  80.height,
                  cachedImage(
                    widget.callModel!.callerPhotoUrl.validate(),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    radius: 80,
                  ).cornerRadiusWithClipRRect(80),
                  16.height,
                  Text(
                    widget.callModel!.callerName.validate(),
                    style: boldTextStyle(size: 18),
                  ),
                  20.height,
                  Text('Incoming'.toUpperCase(), style: boldTextStyle()),
                ],
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      onCallReject();
                    },
                    child: Icon(Icons.call_end, color: Colors.redAccent),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: context.cardColor,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  6.width,
                  RawMaterialButton(
                    onPressed: () async {
                      if (appStore.isWebsocketEnable == 1 && messageStore.webSocketReady) {
                        String messageOne = '42["${SocketEvents.mediaEvent}",{"event":"${SocketEvents.answered}","thread_id":${widget.callModel!.threadId},"to":${widget.callModel!.callerId}}]';
                        String messageTwo = '42["${SocketEvents.mediaEvent}",{"event":"${SocketEvents.selfReject}","thread_id":${widget.callModel!.threadId},"to":${appStore.loginUserId}}]';

                        log('Send Message: $messageOne');
                        log('Send Message: $messageTwo');

                        channel?.sink.add(messageOne);
                        channel?.sink.add(messageTwo);
                      }

                      if (isAndroid) {
                        if (await Permissions.cameraAndMicrophonePermissionsGranted()) {
                          isPickUpScreenLaunched = false;
                          AgoraVideoCallScreen(callModel: widget.callModel!).launch(context).then((value) {
                            finish(context);
                          });
                        }
                      } else {
                        isPickUpScreenLaunched = false;
                        AgoraVideoCallScreen(callModel: widget.callModel!).launch(context).then((value) {
                          finish(context);
                        });
                      }
                    },
                    child: Icon(Icons.call, color: Colors.green),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    padding: const EdgeInsets.all(12.0),
                    fillColor: context.cardColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
