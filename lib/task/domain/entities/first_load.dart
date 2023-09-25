class FirstLoad {
  int? id;
  DateTime? date;
  int? reloaded;

  FirstLoad({
    this.id,
    this.date,
    this.reloaded,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["date"] = date?.toIso8601String();
    data["reloaded"] = reloaded;
    return data;
  }

  FirstLoad.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    date = DateTime.parse(map["date"] as String);
    reloaded = map["reloaded"];
  }
}

class UpdateFirstLoad {
  int? id;
  int? reloaded;


  UpdateFirstLoad({this.id, this.reloaded});
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["reloaded"] = reloaded;
    return data;
  }
}
