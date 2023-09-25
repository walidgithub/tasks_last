class TasksByCategoryArguments {
  String? category;
  int? countOfItems;
  String? tasksDate;
  String? tasksDay;

  TasksByCategoryArguments({
    this.category,
    this.countOfItems,
    this.tasksDate,
    this.tasksDay,
  });
}

class GoToTaskArguments {
  String? editType;
  int? id;

  GoToTaskArguments({
    this.editType,
    this.id,
  });
}

class DailyTasksArguments {
  int? id;
  String? taskName;
  String? description;
  String? time;
  int? timer;
  int? pinned;
  int? done;
  int? nested;
  int? nestedVal;
  int? wheel;
  int? counter;
  int? counterVal;
  String? date;

  DailyTasksArguments({
    this.id,
    this.taskName,
    this.description,
    this.time,
    this.timer,
    this.pinned,
    this.done,
    this.counter,
    this.nested,
    this.wheel,
    this.nestedVal,
    this.counterVal,
    this.date,
  });
}
