
class NoteM {
  String? nid;
  String? title;
  String? body;
  String? date;

  NoteM({
    this.nid,
    this.title,
    this.body,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'nid': nid,
      'title': title,
      'body': body,
      'date': date,
    };
  }

  static NoteM fromJson(Map<String, dynamic> json, String id) {
    return NoteM(
      nid: id,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
