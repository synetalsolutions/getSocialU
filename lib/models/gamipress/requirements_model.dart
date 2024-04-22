class RequirementsModel {
  RequirementsModel({
      this.id, 
      this.title, 
      this.hasEarned,});

  RequirementsModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    hasEarned = json['has_earned'];
  }
  int? id;
  String? title;
  bool? hasEarned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['has_earned'] = hasEarned;
    return map;
  }

}