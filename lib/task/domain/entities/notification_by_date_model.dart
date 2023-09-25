class NotificationByDate {
  int? id;
  String? title;
  String? body;
  int? notifyDay;
  int? notifyMonth;
  int? notifyYear;
  int? notifyHour;
  int? notifyMinute;
  int? taskId;
  int? notificationUniqueId;

  NotificationByDate({
    this.id,
    this.title,
    this.body,
    this.notifyDay,
    this.notifyMonth,
    this.notifyYear,
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
    data["notifyDay"] = notifyDay;
    data["notifyMonth"] = notifyMonth;
    data["notifyYear"] = notifyYear;
    data["notifyHour"] = notifyHour;
    data["notifyMinute"] = notifyMinute;
    data["taskId"] = taskId;
    data["notificationUniqueId"] = notificationUniqueId;
    return data;
  }

  NotificationByDate.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    body = map["body"];
    notifyDay = map["notifyDay"];
    notifyMonth = map["notifyMonth"];
    notifyYear = map["notifyYear"];
    notifyHour = map["notifyHour"];
    notifyMinute = map["notifyMinute"];
    taskId = map["taskId"];
    notificationUniqueId = map["notificationUniqueId"];
  }
}

List<NotificationByDate> listOfNotificationByDate = [
  NotificationByDate(notifyYear: 2023,notifyMonth: 9,notifyDay: 23,notificationUniqueId: 400,taskId: 100,title: 'walid',body: 'barakat',notifyHour: 16,notifyMinute: 44)
];