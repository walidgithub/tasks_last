class NestedTaskModel {
  int? id;
  int? mainTaskId;
  String? taskName;
  String? description;
  String? category;
  DateTime? date;
  DateTime? time;
  int? timer;
  int? done;
  int? notifyMe;
  int? wheel;
  int? counter;
  int? counterVal;

  NestedTaskModel({
    this.id,
    this.mainTaskId,
    this.taskName,
    this.description,
    this.category,
    this.date,
    this.time,
    this.timer,
    this.done,
    this.notifyMe,
    this.counter,
    this.wheel,
    this.counterVal,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["mainTaskId"] = mainTaskId;
    data["done"] = done;
    data["notifyMe"] = notifyMe;
    data["category"] = category;
    data["date"] = date?.toIso8601String();
    data["description"] = description;
    data["taskName"] = taskName;
    data["time"] = time?.toIso8601String();
    data["timer"] = timer;
    data["wheel"] = wheel;
    data["counter"] = counter;
    data["counterVal"] = counterVal;
    return data;
  }

  NestedTaskModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    mainTaskId = map["mainTaskId"];
    done = map["done"];
    notifyMe = map["notifyMe"];
    category = map["category"];
    date = DateTime.parse(map["date"] as String);
    description = map["description"];
    taskName = map["taskName"];
    time = DateTime.parse(map["time"] as String);
    timer = map["timer"];
    wheel = map["wheel"];
    counter = map["counter"];
    counterVal = int.parse(map["counterVal"]);
  }
}

class MakeNestedTaskDoneModel {
  int? id;
  int? done;

  MakeNestedTaskDoneModel({this.id, this.done});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["done"] = done;
    return data;
  }
}

