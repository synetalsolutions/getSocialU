import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/calls/call_model.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class AgoraVideoCallScreen extends StatefulWidget {
  final CallModel callModel;
  final bool isReceiver;

  AgoraVideoCallScreen({required this.callModel, this.isReceiver = true});

  @override
  _AgoraVideoCallScreenState createState() => _AgoraVideoCallScreenState();
}

class _AgoraVideoCallScreenState extends State<AgoraVideoCallScreen> {
  List<int> _users = [];
  bool muted = false;
  late RtcEngine _engine;
  bool switchRender = true;
  bool isUserJoined = false;
  bool isVideoCall = false;

  Offset offset = Offset(120, 16);

  String callStatus = "Ringing";

  int seconds = 0;
  int missCallSeconds = 0;
  bool startTimer = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> startTime() async {
    if (startTimer) {
      await 1.seconds.delay;
      seconds = seconds + 1;
      int sec = seconds % 60;
      int min = (seconds / 60).floor();
      String minute = min.toString().length <= 1 ? "0$min" : "$min";
      String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
      callStatus = "$minute : $second";
      setState(() {});
      log('seconds -- $seconds');
      startTime();
    } else {
      seconds = 0;
      startTimer = false;
      callStatus = 'Call End';
      setState(() {});

      log('seconds -- $seconds --- Stop');
    }
  }

  Future<void> startMissCallTime() async {
    if (!isUserJoined && missCallSeconds < 30 && mounted) {
      await 1.seconds.delay;
      missCallSeconds = missCallSeconds + 1;

      startMissCallTime();
    } else {
      if (!isUserJoined) {
        callService.endCall(callModel: widget.callModel);

        Map request = {"thread_id": widget.callModel.threadId, "message_id": widget.callModel.messageId, "type": widget.callModel.callType, "duration": missCallSeconds};
        callMissed(request: request).catchError(onError);
      }
    }
  }

  late StreamSubscription callStreamSubscription;

  init() async {
    if (widget.callModel.callType == BetterMessageCallType.video) isVideoCall = true;
    addPostFrameCallBack();
    initialize();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();

    await _engine.joinChannel(
      null,
      widget.callModel.channelId.validate(),
      null,
      0,
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(AGORA_APP_ID));

    this._addAgoraEventHandlers();
    if (isVideoCall) {
      await _engine.enableVideo();
      await _engine.startPreview();
    }
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          log('Error: ${code.name}');
          setState(() {});
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          log('joinChannelSuccess -------------');

          if (!widget.isReceiver) startMissCallTime();

          setState(() {
            log(uid);
            log(_users);
          });
        },
        leaveChannel: (stats) {
          log('leaveChannel -------------');
          setState(() {
            _users.clear();
          });
        },
        userJoined: (uid, elapsed) async {
          startTimer = true;
          startTime();
          Map request = {"thread_id": widget.callModel.threadId, "message_id": widget.callModel.messageId, "type": widget.callModel.callType};
          await callStarted(request: request).then((value) {
            //
          }).catchError(onError);
          isUserJoined = true;
          _users.add(uid);

          setState(() {});
        },
        userOffline: (uid, elapsed) {
          callService.endCall(callModel: widget.callModel);
          setState(() {
            _users.remove(uid);
          });
        },
      ),
    );
  }

  void addPostFrameCallBack() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callStreamSubscription = callService.callStream(uid: appStore.loginUserId.validate().toString()).listen((DocumentSnapshot ds) async {
        switch (ds.data()) {
          case null:
            if (isUserJoined) {
              callService.endCall(callModel: widget.callModel);

              Map request = {"thread_id": widget.callModel.threadId, "message_id": widget.callModel.messageId, "duration": seconds};
              await callUsage(request: request).then((value) {
                //
              }).catchError(onError);
            }

            startTimer = false;
            finish(context);
            break;

          default:
            break;
        }
      });
      //
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    seconds = 0;
    startTimer = false;
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  Widget _toolbar() {
    if (ClientRole.Broadcaster == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {
              callService.endCall(callModel: widget.callModel);

              if (appStore.isWebsocketEnable == 1 && messageStore.webSocketReady) {
                String message = '';
                if (isUserJoined) {
                  String id = appStore.loginUserId == widget.callModel.callerId ? widget.callModel.receiverId.validate() : widget.callModel.callerId.validate();

                  message = '42["${SocketEvents.mediaEvent}",{"event":"${SocketEvents.callEnd}","to": $id,"thread_id":${widget.callModel.threadId}}]';
                } else if (appStore.loginUserId == widget.callModel.callerId) {
                  message = '42["${SocketEvents.mediaEvent}",{"event":"${SocketEvents.callCancelled}","to":${widget.callModel.receiverId},"thread_id":${widget.callModel.threadId}}]';
                } else {
                  message = '42["${SocketEvents.mediaEvent}",{"event":"${SocketEvents.rejected}","to":${widget.callModel.callerId},"thread_id":${widget.callModel.threadId}}]';
                }
                log('Send Message: $message');

                channel?.sink.add(message);
              }
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  _switchRender() {
    log("After $_users");

    setState(() {
      switchRender = !switchRender;
      _users = List.of(_users.reversed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            RtcLocalView.SurfaceView().visible(!isUserJoined),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  cachedImage(
                    widget.isReceiver ? widget.callModel.callerPhotoUrl.validate() : widget.callModel.receiverPhotoUrl.validate(),
                    height: 120,
                    width: 120,
                    fit: BoxFit.fill,
                  ).cornerRadiusWithClipRRect(80),
                  16.height,
                  Text(
                    widget.isReceiver ? widget.callModel.callerName.validate() : widget.callModel.receiverName.validate(),
                    style: boldTextStyle(size: 18),
                  ),
                  16.height,
                  Text(callStatus, style: boldTextStyle()).center(),
                ],
              ),
            ).visible(!isUserJoined || !isVideoCall),
            Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.of(_users.map(
                      (e) => GestureDetector(
                        onTap: this._switchRender,
                        child: Container(
                          width: context.width(),
                          height: context.height(),
                          child: RtcRemoteView.SurfaceView(
                            channelId: widget.callModel.channelId.validate(),
                            uid: e,
                          ),
                        ),
                      ),
                    )),
                  ).visible(isUserJoined),
                ),
                Positioned(
                  top: offset.dx * 0.5,
                  left: offset.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {});
                    },
                    child: Container(
                      height: 180,
                      width: 150,
                      child: RtcLocalView.SurfaceView(),
                    ),
                  ),
                ).visible(isUserJoined)
              ],
            ).visible(isVideoCall),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
