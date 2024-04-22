import 'dart:convert';

List<CourseCategory> courseCategoryFromJson(String str) => List<CourseCategory>.from(json.decode(str).map((x) => CourseCategory.fromJson(x)));

String courseCategoryToJson(List<CourseCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseCategory {
  int? id;
  int? count;
  String? description;
  String? link;
  String? name;
  String? slug;
  String? taxonomy;
  int? parent;

  CourseCategory({
    this.id,
    this.count,
    this.description,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.parent,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
        id: json["id"],
        count: json["count"],
        description: json["description"],
        link: json["link"],
        name: json["name"],
        slug: json["slug"],
        taxonomy: json["taxonomy"],
        parent: json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
        "description": description,
        "link": link,
        "name": name,
        "slug": slug,
        "taxonomy": taxonomy,
        "parent": parent,
      };
}
