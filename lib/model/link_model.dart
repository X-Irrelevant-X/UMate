class LinkM {
  String? lid;
  String? linkName;
  String? linkUrl;

  LinkM({
    this.lid,
    this.linkName,
    this.linkUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'lid': lid,
      'linkName': linkName,
      'linkUrl': linkUrl,
    };
  }

  static LinkM fromJson(Map<String, dynamic> json, String id) {
    return LinkM(
      lid: id,
      linkName: json['linkName'] ?? '',
      linkUrl: json['linkUrl'] ?? '',
    );
  }
}