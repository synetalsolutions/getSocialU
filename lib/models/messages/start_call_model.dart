class StartCallModel {
  StartCallModel({
    this.result,
    this.messageId,
    this.threadId,
  });

  StartCallModel.fromJson(dynamic json) {
    result = json['result'];
    messageId = json['message_id'];
    threadId = json['thread_id'];
  }

  String? result;
  int? messageId;
  int? threadId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['message_id'] = messageId;
    map['thread_id'] = threadId;
    return map;
  }
}
