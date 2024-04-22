class VariationModel {
  VariationModel({
      this.attribute, 
      this.value,});

  VariationModel.fromJson(dynamic json) {
    attribute = json['attribute'];
    value = json['value'];
  }
  String? attribute;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attribute'] = attribute;
    map['value'] = value;
    return map;
  }

}