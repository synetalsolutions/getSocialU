class CallModel {
  String? callerId;
  String? callerName;
  String? callerPhotoUrl;
  String? receiverId;
  String? receiverName;
  String? receiverPhotoUrl;
  String? channelId;
  bool? hasDialed;
  bool? isVoice;
  int? threadId;
  String? callType;
  int? messageId;

  CallModel({
    this.callerId,
    this.callerName,
    this.callerPhotoUrl,
    this.receiverId,
    this.receiverName,
    this.receiverPhotoUrl,
    this.channelId,
    this.hasDialed,
    this.isVoice,
    this.threadId,
    this.messageId,
    this.callType,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callerId: json['callerId'],
      callerName: json['callerName'],
      callerPhotoUrl: json['callerPhotoUrl'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      receiverPhotoUrl: json['receiverPhotoUrl'],
      channelId: json['channelId'],
      hasDialed: json['hasDialed'],
      isVoice: json['isVoice'],
      threadId: json['threadId'],
      messageId: json['messageId'],
      callType: json['callType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callerId'] = this.callerId;
    data['callerName'] = this.callerName;
    data['callerPhotoUrl'] = this.callerPhotoUrl;
    data['receiverId'] = this.receiverId;
    data['receiverName'] = this.receiverName;
    data['receiverPhotoUrl'] = this.receiverPhotoUrl;
    data['channelId'] = this.channelId;
    data['hasDialed'] = this.hasDialed;
    data['isVoice'] = this.isVoice;
    data['threadId'] = this.threadId;
    data['messageId'] = this.messageId;
    data['callType'] = this.callType;

    return data;
  }
}
