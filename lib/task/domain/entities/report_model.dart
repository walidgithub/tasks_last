class ReportModel {
  int? id;
  String? taskName;
  String? description;
  String? category;
  DateTime? date;
  int? done;

  ReportModel({
    this.id,
    this.taskName,
    this.description,
    this.category,
    this.date,
    this.done,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["done"] = done;
    data["category"] = category;
    data["date"] = date?.toIso8601String();
    data["description"] = description;
    data["taskName"] = taskName;
    return data;
  }

  ReportModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    done = map["done"];
    category = map["category"];
    date = DateTime.parse(map["date"] as String);
    description = map["description"];
    taskName = map["taskName"];
  }
}