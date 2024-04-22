class Notification {
  String? notificationId;
  String? templateId;
  String? templateName;
  String? sound;
  String? title;
  String? body;
  String? launchUrl;
  Map<String, dynamic>? additionalData;
  Map<String, dynamic>? attachments;
  bool? contentAvailable;
  bool? mutableContent;
  String? category;
  int? badge;
  int? badgeIncrement;
  String? subtitle;
  double? relevanceScore;
  String? interruptionLevel;
  int? androidNotificationId;
  String? smallIcon;
  String? largeIcon;
  String? bigPicture;
  String? smallIconAccentColor;
  String? ledColor;
  int? lockScreenVisibility;
  String? groupKey;
  String? groupMessage;
  String? fromProjectNumber;
  String? collapseId;
  int? priority;

  Notification.fromJson(Map<String, dynamic> json) {
    this.notificationId = json['notificationId'] as String;
    if (json.containsKey('contentAvailable')) this.contentAvailable = json['contentAvailable'] as bool?;
    if (json.containsKey('mutableContent')) this.mutableContent = json['mutableContent'] as bool?;
    if (json.containsKey('category')) this.category = json['category'] as String?;
    if (json.containsKey('badge')) this.badge = json['badge'] as int?;
    if (json.containsKey('badgeIncrement')) this.badgeIncrement = json['badgeIncrement'] as int?;
    if (json.containsKey('subtitle')) this.subtitle = json['subtitle'] as String?;
    if (json.containsKey('attachments')) this.attachments = json['attachments'].cast<String, dynamic>();
    if (json.containsKey('relevanceScore')) this.relevanceScore = json['relevanceScore'] as double?;
    if (json.containsKey('interruptionLevel')) this.interruptionLevel = json['interruptionLevel'] as String?;

    // Android Specific Parameters
    if (json.containsKey("smallIcon")) this.smallIcon = json['smallIcon'] as String?;
    if (json.containsKey("largeIcon")) this.largeIcon = json['largeIcon'] as String?;
    if (json.containsKey("bigPicture")) this.bigPicture = json['bigPicture'] as String?;
    if (json.containsKey("smallIconAccentColor")) this.smallIconAccentColor = json['smallIconAccentColor'] as String?;
    if (json.containsKey("ledColor")) this.ledColor = json['ledColor'] as String?;
    if (json.containsKey("lockScreenVisibility")) this.lockScreenVisibility = json['lockScreenVisibility'] as int?;
    if (json.containsKey("groupMessage")) this.groupMessage = json['groupMessage'] as String?;
    if (json.containsKey("groupKey")) this.groupKey = json['groupKey'] as String?;
    if (json.containsKey("fromProjectNumber")) this.fromProjectNumber = json['fromProjectNumber'] as String?;
    if (json.containsKey("collapseId")) this.collapseId = json['collapseId'] as String?;
    if (json.containsKey("priority")) this.priority = json['priority'] as int?;
    if (json.containsKey("androidNotificationId")) this.androidNotificationId = json['androidNotificationId'] as int?;
    this.notificationId = json['notificationId'] as String;

    if (json.containsKey('templateName')) this.templateName = json['templateName'] as String?;
    if (json.containsKey('templateId')) this.templateId = json['templateId'] as String?;
    if (json.containsKey('sound')) this.sound = json['sound'] as String?;
    if (json.containsKey('title')) this.title = json['title'] as String?;
    if (json.containsKey('body')) this.body = json['body'] as String?;
    if (json.containsKey('launchUrl')) this.launchUrl = json['launchUrl'] as String?;
    if (json.containsKey('additionalData')) this.additionalData = json['additionalData'].cast<String, dynamic>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['notificationId'] = this.notificationId;
    data['contentAvailable'] = this.contentAvailable;
    data['mutableContent'] = this.mutableContent;
    data['category'] = this.category;
    data['badge'] = this.badge;
    data['badgeIncrement'] = this.badgeIncrement;
    data['subtitle'] = this.subtitle;
    data['attachments'] = this.attachments;
    data['relevanceScore'] = this.relevanceScore;
    data['interruptionLevel'] = this.interruptionLevel;

    // Android Specific Parameters
    data['smallIcon'] = this.smallIcon;
    data['largeIcon'] = this.largeIcon;
    data['bigPicture'] = this.bigPicture;
    data['smallIconAccentColor'] = this.smallIconAccentColor;
    data['ledColor'] = this.ledColor;
    data['lockScreenVisibility'] = this.lockScreenVisibility;
    data['groupMessage'] = this.groupMessage;
    data['groupKey'] = this.groupKey;
    data['fromProjectNumber'] = this.fromProjectNumber;
    data['collapseId'] = this.collapseId;
    data['priority'] = this.priority;
    data['androidNotificationId'] = this.androidNotificationId;

    data['templateName'] = this.templateName;
    data['templateId'] = this.templateId;
    data['sound'] = this.sound;
    data['title'] = this.title;
    data['body'] = this.body;
    data['launchUrl'] = this.launchUrl;
    data['additionalData'] = this.additionalData;

    return data;
  }

}

class NotificationModel {
  String? action;
  String? component;
  String? date;
  int? id;
  int? isNew;
  int? itemId;
  String? itemImage;
  String? itemName;
  int? secondaryItemId;
  String? secondaryItemImage;
  String? secondaryItemName;
  bool? isUserVerified;
  int? topicId;
  String? requestId;
  int? groupId;

  NotificationModel({
    this.action,
    this.component,
    this.date,
    this.id,
    this.isNew,
    this.itemId,
    this.itemImage,
    this.itemName,
    this.secondaryItemId,
    this.secondaryItemImage,
    this.secondaryItemName,
    this.isUserVerified,
    this.topicId,
    this.requestId,
    this.groupId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      action: json['action'],
      component: json['component'],
      date: json['date'],
      id: json['id'],
      isNew: json['is_new'],
      itemId: json['item_id'],
      itemImage: json['item_image'],
      itemName: json['item_name'],
      secondaryItemId: json['secondary_item_id'],
      secondaryItemImage: (json['secondary_item_image'] is bool) ? "" : json['secondary_item_image'],
      secondaryItemName: (json['secondary_item_name'] is bool) ? "" : json['secondary_item_name'],
      isUserVerified: json['is_user_verified'],
      topicId: json['topic_id'],
      requestId: json['request_id'].toString(),
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['component'] = this.component;
    data['date'] = this.date;
    data['id'] = this.id;
    data['is_new'] = this.isNew;
    data['item_id'] = this.itemId;
    data['item_image'] = this.itemImage;
    data['item_name'] = this.itemName;
    data['secondary_item_id'] = this.secondaryItemId;
    data['secondary_item_image'] = this.secondaryItemImage;
    data['secondary_item_name'] = this.secondaryItemName;
    data['is_user_verified'] = this.isUserVerified;
    data['topic_id'] = this.topicId;
    data['request_id'] = this.requestId;
    data['group_id'] = this.groupId;
    return data;
  }
}
