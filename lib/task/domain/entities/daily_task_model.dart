class DailyTaskModel {
  int? id;
  String? taskName;
  String? description;
  String? category;
  DateTime? date;
  String? time;
  int? timer;
  int? pinned;
  int? done;
  int? notifyMe;
  int? nested;
  int? nestedVal;
  int? wheel;
  int? counter;
  int? counterVal;
  int? specificDate;

  DailyTaskModel({
    this.id,
    this.taskName,
    this.description,
    this.category,
    this.date,
    this.time,
    this.timer,
    this.pinned,
    this.done,
    this.notifyMe,
    this.counter,
    this.nested,
    this.wheel,
    this.nestedVal,
    this.counterVal,
    this.specificDate,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["done"] = done;
    data["notifyMe"] = notifyMe;
    data["category"] = category;
    data["date"] = date?.toIso8601String();
    data["description"] = description;
    data["pinned"] = pinned;
    data["taskName"] = taskName;
    data["time"] = time.toString();
    data["timer"] = timer;
    data["nested"] = nested;
    data["nestedVal"] = nestedVal;
    data["wheel"] = wheel;
    data["counter"] = counter;
    data["counterVal"] = counterVal;
    data["specificDate"] = specificDate;
    return data;
  }

  DailyTaskModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    done = map["done"];
    notifyMe = map["notifyMe"];
    category = map["category"];
    date = DateTime.parse(map["date"] as String);
    description = map["description"];
    pinned = map["pinned"];
    taskName = map["taskName"];
    time = map["time"];
    timer = map["timer"];
    nested = map["nested"];
    nestedVal = map["nestedVal"];
    wheel = map["wheel"];
    counter = map["counter"];
    counterVal = map["counterVal"];
    specificDate = map["specificDate"];
  }
}

class MakeTaskDoneModel {
  int? id;
  int? done;

  MakeTaskDoneModel({this.id, this.done});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["done"] = done;
    return data;
  }
}

class SaveCounterValModel {
  int? id;
  int? counterVal;

  SaveCounterValModel({this.id, this.counterVal});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["counterVal"] = counterVal;
    return data;
  }
}



