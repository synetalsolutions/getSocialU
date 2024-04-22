class RewardsModel {
  RewardsModel({
    this.points,
    this.rank,
    this.achievement,
    this.achievementCount,
  });

  RewardsModel.fromJson(dynamic json) {
    if (json['points'] != null) {
      points = [];
      json['points'].forEach((v) {
        points?.add(Points.fromJson(v));
      });
    }
    rank = json['rank'] != null ? Rank.fromJson(json['rank']) : null;
    if (json['achievement'] != null) {
      achievement = [];
      json['achievement'].forEach((v) {
        achievement?.add(Rank.fromJson(v));
      });
    }
    achievementCount = json['achievement_count'];
  }
  List<Points>? points;
  Rank? rank;
  List<Rank>? achievement;
  int? achievementCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (points != null) {
      map['points'] = points?.map((v) => v.toJson()).toList();
    }
    if (rank != null) {
      map['rank'] = rank?.toJson();
    }
    if (achievement != null) {
      map['achievement'] = achievement?.map((v) => v.toJson()).toList();
    }

    map['achievement_count'] = achievementCount;

    return map;
  }
}

class Rank {
  Rank({
    this.id,
    this.name,
    this.image,
  });

  Rank.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  int? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }
}

class Points {
  Points({
    this.id,
    this.type,
    this.singularName,
    this.pluralName,
    this.earnings,
    this.image,
  });

  Points.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    singularName = json['singular_name'];
    pluralName = json['plural_name'];
    earnings = json['earnings'];
    image = json['image'];
  }
  String? id;
  String? type;
  String? singularName;
  String? pluralName;
  int? earnings;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['singular_name'] = singularName;
    map['plural_name'] = pluralName;
    map['earnings'] = earnings;
    map['image'] = image;
    return map;
  }
}
