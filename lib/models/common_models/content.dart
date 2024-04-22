class Content {
  bool? protected;
  String? rendered;

  Content({this.protected, this.rendered});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      protected: json['protected'],
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['protected'] = this.protected;
    data['rendered'] = this.rendered;
    return data;
  }
}


class ContentObject {
  bool? isLink;
  String? content;

  ContentObject({this.isLink, this.content});

  factory ContentObject.fromJson(Map<String, dynamic> json) {
    return ContentObject(
      isLink: json['is_link'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_link'] = this.isLink;
    data['content'] = this.content;
    return data;
  }
}