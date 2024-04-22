import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/calls/call_model.dart';
import 'package:socialv/models/messages/fast_message_model.dart';
import 'package:socialv/models/messages/stream_message.dart';
import 'package:socialv/models/messages/unread_threads.dart';
import 'package:socialv/screens/messages/calls/pickup_screen.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/utils/app_constants.dart';

void handleSocketEvents(BuildContext context, String message) {
  log('Message : $message');
  String? event = getEventKey(message);

  if (message.contains('[{"tempId"')) {
    String jsonSubstring = message.substring(message.indexOf('['), message.lastIndexOf(']') + 1);
    List<dynamic> jsonList = json.decode(jsonSubstring);

    String tempId = jsonList[0]['tempId'];

    log('tempId:: $tempId');

    if (threadOpened != null) {
      LiveStream().emit(SendMessage, tempId);
    }
  }

  if (event == SocketEvents.message) {
    String? object = getStreamMessage(message);
    StreamMessage streamMessage = StreamMessage.fromJson(jsonDecode(object!));

    if (threadOpened != null && streamMessage.thread!.threadId == threadOpened) {
      LiveStream().emit(ThreadMessageReceived, streamMessage.thread!.lastMessage);
    }
    LiveStream().emit(RefreshRecentMessage, streamMessage.thread);
  } else if (event == SocketEvents.getUnread) {
    String? object = getStreamMessage(message);
    UnreadThreads unreads = UnreadThreads.fromJson(jsonDecode(object!));
    messageStore.clearUnReads();
    log(unreads.threads);
    unreads.threads!.keys.map((e) {
      messageStore.addUnReads(UnreadThreadModel(threadId: e.toInt(), unreadCount: unreads.threads![e]));
    }).toList();
  } else if (event == SocketEvents.writing) {
    String? object = getStreamMessage(message);
    Map<String, dynamic> typing = jsonDecode(object!);
    removeTypingUsers();
    typing.keys.map((e) {
      if (!messageStore.typingList.any((element) => element.threadId == e.toInt())) {
        messageStore.addTyping(UnreadThreadModel(threadId: e.toInt(), typingIds: typing[e].cast<String>()));
      } else {
        List<String> list = typing[e].cast<String>();
        bool inList = false;

        messageStore.typingList.forEach((element) {
          if (listEquals(element.typingIds, list)) {
            inList = true;
          }
        });

        if (!inList) {
          messageStore.typingList.add(UnreadThreadModel(threadId: e.toInt(), typingIds: typing[e].cast<String>()));
        }
      }
    }).toList();
  } else if (event == SocketEvents.onlineUsers) {
    String? object = getStreamMessage(message);

    List<String> list = jsonDecode(object.validate()).cast<String>();

    list.forEach((element) {
      messageStore.addOnlineUsers(element.toInt());
    });
  } else if (event == SocketEvents.userOffline) {
    String? object = getStreamMessage(message);

    if (messageStore.onlineUsers.any((element) => element == object.toInt())) {
      messageStore.removeOnlineUser(object.toInt());
    }
  } else if (event == SocketEvents.userOnline) {
    String? object = getStreamMessage(message);

    if (!messageStore.onlineUsers.any((element) => element == object.toInt())) {
      messageStore.addOnlineUsers(object.toInt());
    }
  } else if (event == SocketEvents.threadInfoChanged) {
    String? object = getStreamMessage(message);
    StreamMessage streamMessage = StreamMessage.fromJson(jsonDecode(object!));

    if (threadOpened != null && streamMessage.thread!.threadId == threadOpened) {
      LiveStream().emit(ThreadStatusChanged, streamMessage.thread);
    }
    LiveStream().emit(RecentThreadStatus, streamMessage.thread);
  } else if (event == SocketEvents.v2MessageMetaUpdate) {
    String? object = getStreamMessage(message);

    StreamMessage streamMessage = StreamMessage.fromJson(jsonDecode(object!));

    if (threadOpened != null && streamMessage.threadId == threadOpened) {
      LiveStream().emit(MetaChanged, streamMessage);
    }
  } else if (event == SocketEvents.messageDeleted) {
    String? object = getStreamMessage(message);

    if (threadOpened != null) {
      LiveStream().emit(DeleteMessage, object.validate().replaceAll('"', '').toInt());
    }
  } else if (event == SocketEvents.v3fastMsg) {
    String? object = getStreamMessage(message);
    FastMessageModel streamMessage = FastMessageModel.fromJson(jsonDecode(object!));

    if (threadOpened != null && streamMessage.threadId == threadOpened) {
      LiveStream().emit(FastMessage, object);
    }
  } else if (event == SocketEvents.v2AbortFastMessage) {
    String? object = getStreamMessage(message);
    AbortMessageModel streamMessage = AbortMessageModel.fromJson(jsonDecode(object!));

    if (threadOpened != null && streamMessage.threadId == threadOpened) {
      LiveStream().emit(AbortFastMessage, object);
    }
  }
}

void removeTypingUsers() {
  messageStore.typingList.clear();
  Future.delayed(Duration(seconds: 5), () {
    removeTypingUsers();
  });
}

String? getEventKey(String message) {
  RegExp pattern = RegExp(r'^\d+\[.*\]$');

  if (pattern.hasMatch(message)) {
    int startIndex = message.indexOf('[');

    String listString = message.substring(startIndex);

    dynamic listData = jsonDecode(listString);

    if (listData[0].runtimeType == String) {
      return listData[0];
    } else {
      return null;
    }
  } else {
    return null;
  }
}

String? getStreamMessage(String message) {
  RegExp pattern = RegExp(r'^\d+\[.*\]$');

  if (pattern.hasMatch(message)) {
    int startIndex = message.indexOf('[');

    String listString = message.substring(startIndex);

    dynamic listData = jsonDecode(listString);

    return jsonEncode(listData[1]);
  } else {
    return null;
  }
}

String getMessageTime(String timestamp) {
  int millisecondsSinceEpoch = int.parse(timestamp);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  DateFormat timeFormat = DateFormat(TIME_FORMAT_1);

  return timeFormat.format(dateTime);
}

String getChatDate({required String date}) {
  String formattedDate = DateFormat(DATE_FORMAT_3).format(DateTime.parse(date.substring(0, 10)));
  return formattedDate;
}

String generateTempId({required int threadId}) {
  Random random = Random();
  int min = 100000000; // Smallest 9-digit number
  int max = 999999999; // Largest 9-digit number

  int randomNumber = min + random.nextInt(max - min);
  print(randomNumber);

  return 'tmp_$threadId\_$randomNumber';
}

String timeStampToDateMessage(int time) {
  String numberString = time.toString();
  String trimmedString = numberString.substring(0, 10);
  int tenDigitNumber = int.parse(trimmedString);

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tenDigitNumber * 1000);

  String formattedTime = DateFormat(TIME_FORMAT_1).format(dateTime);

  return formattedTime;
}

String timeOfMessage(String dateSent) {
  final String dateString = dateSent;

  List<String> dateTimeParts = dateString.split(' ');
  List<String> dateParts = dateTimeParts[0].split('-');
  List<String> timeParts = dateTimeParts[1].split(':');

  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  final utcTime = DateTime.utc(year, month, day, hour, minute, second);

  final localTime = utcTime.toLocal();

  String formattedTime = DateFormat(TIME_FORMAT_1).format(localTime);
  return formattedTime;
}

void callStream(BuildContext context) {
  callService.callStream(uid: appStore.loginUserId).listen((event) {
    if (event.data() != null) {
      CallModel call = CallModel.fromJson(event.data() as Map<String, dynamic>);
      openCallController.searchStream.add(call);
    } else {
      if (isPickUpScreenLaunched) finish(context);
    }
  });
}
