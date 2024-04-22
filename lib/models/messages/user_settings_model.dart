class UserSettingsModel {
  UserSettingsModel({
    this.id,
    this.title,
    this.type,
    this.options,
    this.user,
    this.attachmentId,
    this.url,
  });

  UserSettingsModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    if (json['user'] != null) {
      user = [];
      json['user'].forEach((v) {
        user!.add(UserObject.fromJson(v));
      });
    }
    attachmentId = json['attachment_id'];
    url = json['url'];
  }

  String? id;
  String? title;
  String? type;
  List<Options>? options;
  List<UserObject>? user;
  int? attachmentId;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['type'] = type;
    if (options != null) {
      map['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      map['user'] = user!.map((v) => v.toJson()).toList();
    }
    map['attachment_id'] = attachmentId;
    map['url'] = url;
    return map;
  }
}

class Options {
  Options({
    this.id,
    this.label,
    this.value,
    this.checked,
    this.desc,
  });

  Options.fromJson(dynamic json) {
    id = json['id'];
    label = json['label'];
    value = json['value'];
    checked = json['checked'];
    desc = json['desc'];
  }

  String? id;
  String? label;
  String? value;
  bool? checked;
  String? desc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['label'] = label;
    map['value'] = value;
    map['checked'] = checked;
    map['desc'] = desc;
    return map;
  }
}

class UserObject {
  UserObject({
    this.id,
    this.memberAvtarImage,
    this.memberCoverImage,
    this.name,
    this.mentionName,
    this.email,
    this.isUserVerified,
  });

  UserObject.fromJson(dynamic json) {
    id = json['id'];
    memberAvtarImage = json['member_avtar_image'];
    memberCoverImage = json['member_cover_image'];
    name = json['name'];
    mentionName = json['mention_name'];
    email = json['email'];
    isUserVerified = json['is_user_verified'];
  }

  int? id;
  String? memberAvtarImage;
  String? memberCoverImage;
  String? name;
  String? mentionName;
  String? email;
  bool? isUserVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['member_avtar_image'] = memberAvtarImage;
    map['member_cover_image'] = memberCoverImage;
    map['name'] = name;
    map['mention_name'] = mentionName;
    map['email'] = email;
    map['is_user_verified'] = isUserVerified;
    return map;
  }
}