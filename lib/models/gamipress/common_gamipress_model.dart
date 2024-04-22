import 'package:socialv/models/common_models/content.dart';
import 'package:socialv/models/gamipress/requirements_model.dart';

class CommonGamiPressModel {
  CommonGamiPressModel({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.parent,
    this.menuOrder,
    this.template,
    this.authorName,
    this.image,
    this.hasEarned,
    this.isUserVerified,
    this.requirements,
  });

  CommonGamiPressModel.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? Content.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? Content.fromJson(json['title']) : null;
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
    excerpt = json['excerpt'] != null ? Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    parent = json['parent'];
    menuOrder = json['menu_order'];
    template = json['template'];
    authorName = json['author_name'];
    image = json['image'];
    hasEarned = json['has_earned'];
    isUserVerified = json['is_user_verified'];
    requirements = json['requirements'] != null ? (json['requirements'] as List).map((i) => RequirementsModel.fromJson(i)).toList() : null;
  }
  int? id;
  String? date;
  String? dateGmt;
  Content? guid;
  String? modified;
  String? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  Content? title;
  Content? content;
  Content? excerpt;
  int? author;
  int? featuredMedia;
  int? parent;
  int? menuOrder;
  String? template;
  String? authorName;
  String? image;
  bool? hasEarned;
  bool? isUserVerified;
  List<RequirementsModel>? requirements;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['date_gmt'] = dateGmt;
    if (guid != null) {
      map['guid'] = guid?.toJson();
    }
    map['modified'] = modified;
    map['modified_gmt'] = modifiedGmt;
    map['slug'] = slug;
    map['status'] = status;
    map['type'] = type;
    map['link'] = link;
    if (title != null) {
      map['title'] = title?.toJson();
    }
    if (content != null) {
      map['content'] = content?.toJson();
    }
    if (excerpt != null) {
      map['excerpt'] = excerpt?.toJson();
    }
    map['author'] = author;
    map['featured_media'] = featuredMedia;
    map['parent'] = parent;
    map['menu_order'] = menuOrder;
    map['template'] = template;
    map['template'] = template;
    map['author_name'] = authorName;
    map['image'] = image;
    map['has_earned'] = hasEarned;
    map['is_user_verified'] = isUserVerified;
    if (this.requirements != null) {
      map['requirements'] = this.requirements!.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
