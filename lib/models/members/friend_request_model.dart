class FriendListResponse {
  bool status;
  String message;
  int count;
  List<FriendRequestModel> friendList;

  FriendListResponse({
    this.status = false,
    this.message = "",
    this.count = -1,
    this.friendList = const <FriendRequestModel>[],
  });

  factory FriendListResponse.fromJson(Map<String, dynamic> json) {
    return FriendListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      count: json['count'] is int ? json['count'] : -1,
      friendList: json['data'] is List
          ? List<FriendRequestModel>.from(json['data'].map((x) => FriendRequestModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'count': count,
      'data': friendList.map((e) => e.toJson()).toList(),
    };
  }
}

class FriendRequestModel {
  int userId;
  String userName;
  String userMentionName;
  String userImage;
  bool isUserVerified;
  bool isRequested;

  FriendRequestModel({
    this.userId = -1,
    this.userName = "",
    this.userMentionName = "",
    this.userImage = "",
    this.isUserVerified = false,
    this.isRequested=false,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userName: json['user_name'] is String ? json['user_name'] : "",
      userMentionName:
      json['user_mention_name'] is String ? json['user_mention_name'] : "",
      userImage: json['user_image'] is String ? json['user_image'] : "",
      isUserVerified:
      json['is_user_verified'] is bool ? json['is_user_verified'] : false,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_mention_name': userMentionName,
      'user_image': userImage,
      'is_user_verified': isUserVerified,
    };
  }
}

/*
class FriendListResponse{
 int? count;
  List<FriendRequestModel>? friendList;

  FriendListResponse({this.count,this.friendList});

 factory FriendListResponse.fromJson(Map<String, dynamic> json){
   return FriendListResponse(
     count: json['count'],
     friendList: json['data'] != null ? (json['data'] as List).map((i) => FriendRequestModel.fromJson(i)).toList() : null,
   );
 }


}

class FriendRequestModel {
  int? requestId;
  int? userId;
  String? userImage;
  String? userMentionName;
  String? userName;
  bool? isUserVerified;
  bool? isRequested;

  /// todo : use this model for any user list

  FriendRequestModel({this.requestId, this.userId, this.userImage, this.userMentionName, this.userName,this.isUserVerified,this.isRequested = false});

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: json['request_id'],
      userId: json['user_id'],
      userImage: json['user_image'],
      userMentionName: json['user_mention_name'],
      userName: json['user_name'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_mention_name'] = this.userMentionName;
    data['user_name'] = this.userName;
    data['is_user_verified'] = this.isUserVerified;
    return data;
  }
}
*/
