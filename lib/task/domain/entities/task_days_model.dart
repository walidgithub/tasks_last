class TaskDaysModel {
  int? id;
  String? nameOfDay;
  int? checkedDay;
  String? category;
  int? mainTaskId;
  int? done;
  String? date;

  TaskDaysModel({
    this.id,
    this.checkedDay,
    this.nameOfDay,
    this.mainTaskId,
    this.category,
    this.done,
    this.date,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["id"] = id;
    data["nameOfDay"] = nameOfDay;
    data["checkedDay"] = checkedDay;
    data["mainTaskId"] = mainTaskId;
    data["category"] = category;
    data["done"] = done;
    data["date"] = date;
    return data;
  }

  TaskDaysModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    nameOfDay = map["nameOfDay"];
    checkedDay = map["checkedDay"];
    mainTaskId = map["mainTaskId"];
    category = map["category"];
    done = map["done"];
    date = map["date"];
  }
}

class MakeTaskDoneByDayModel {
  int? id;
  int? done;

  MakeTaskDoneByDayModel({this.id, this.done});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["done"] = done;
    return data;
  }
}

class UpdateDailyDateOfTaskDay {
  int? id;
  String? date;


  UpdateDailyDateOfTaskDay({this.id, this.date});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["date"] = date;
    return data;
  }
}
