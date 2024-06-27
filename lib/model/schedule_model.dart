class ScheduleM {
  String? sid;
  String? title;
  String? room;
  String? from;
  String? to;
  String? day;

  ScheduleM({
    this.sid,
    this.title,
    this.room,
    this.from,
    this.to,
    this.day,
  });

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'title': title,
      'room': room,
      'from': from,
      'to': to,
      'day': day,
    };
  }

  static ScheduleM fromJson(Map<String, dynamic> json, String id) {
    return ScheduleM(
      sid: id,
      title: json['title'] ?? '',
      room: json['room'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      day: json['day'] ?? '',
    );
  }
}