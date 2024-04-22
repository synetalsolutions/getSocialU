class MediaEventModel {
  MediaEventModel({
      this.event, 
      this.to, 
      this.threadId, 
      this.type, 
      this.avatar, 
      this.name, 
      this.from,});

  MediaEventModel.fromJson(dynamic json) {
    event = json['event'];
    to = json['to'];
    threadId = json['thread_id'];
    type = json['type'];
    avatar = json['avatar'];
    name = json['name'];
    from = json['from'];
  }
  String? event;
  int? to;
  int? threadId;
  String? type;
  String? avatar;
  String? name;
  int? from;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['event'] = event;
    map['to'] = to;
    map['thread_id'] = threadId;
    map['type'] = type;
    map['avatar'] = avatar;
    map['name'] = name;
    map['from'] = from;
    return map;
  }

}