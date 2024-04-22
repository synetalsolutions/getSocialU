import 'package:nb_utils/nb_utils.dart';

class ApiResponses {
  String? message;
  String? code;
  bool? status;

  ApiResponses({
    this.message,
    this.code,
    this.status,
  });

  factory ApiResponses.fromJson(Map<String, dynamic> json) {
    return ApiResponses(
      message: json['message'],
      code: json['code'],
      status: json['status'].runtimeType == String ? (json['status'] as String).getBoolInt() : json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}