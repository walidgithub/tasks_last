class NotificationByDayOfWeek {
  int? id;
  String? title;
  String? body;
  int? dayOfWeek;
  int? notifyHour;
  int? notifyMinute;
  int? taskId;
  int? notificationUniqueId;

  NotificationByDayOfWeek({
    this.id,
    this.title,
    this.body,
    this.dayOfWeek,
    this.notifyHour,
    this.notifyMinute,
    this.taskId,
    this.notificationUniqueId,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["body"] = body;
    data["dayOfWeek"] = dayOfWeek;
    data["notifyHour"] = notifyHour;
    data["notifyMinute"] = notifyMinute;
    data["taskId"] = taskId;
    data["notificationUniqueId"] = notificationUniqueId;
    return data;
  }

  NotificationByDayOfWeek.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    body = map["body"];
    dayOfWeek = map["dayOfWeek"];
    notifyHour = map["notifyHour"];
    notifyMinute = map["notifyMinute"];
    taskId = map["taskId"];
    notificationUniqueId = map["notificationUniqueId"];
  }
}