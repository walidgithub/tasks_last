import 'package:daily_tasks/task/domain/entities/notification_by_date_model.dart';
import 'package:daily_tasks/task/domain/entities/notification_by_day_of_week_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:daily_tasks/task/domain/entities/first_load.dart';
import 'package:daily_tasks/task/domain/entities/task_days_model.dart';
import '../../domain/entities/daily_task_model.dart';

class DbHelper {
  Database? _db;

  static int? insertedNewTaskId;

  String dbdName = 'tasksDb25-9.db';

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDB(dbdName);
      return _db!;
    }
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: createDB,onUpgrade: onUpgrade);
  }

  Future createDB(Database db, int version) async {
    await db.execute(
        'create table tasks(id integer primary key autoincrement, taskName varchar(15), description varchar(255), category varchar(15), date TEXT NOT NULL, time TEXT NOT NULL, timer integer not null, pinned integer not null, counter integer not null, nested integer not null, wheel integer not null, nestedVal integer, counterVal integer, notifyMe integer not null, done integer not null, specificDate integer not null)');

    await db.execute(
        'create table taskDays(id integer primary key autoincrement, category varchar(15), mainTaskId integer, nameOfDay varchar(3), checkedDay integer not null, done integer not null, date TEXT NOT NULL)');

    await db.execute(
        'create table firstLoad(id integer primary key autoincrement, date TEXT NOT NULL, reloaded integer not null)');

    await db.execute(
        'create table notificationsByDate(id integer primary key autoincrement, title varchar(15), body varchar(255), notifyDay integer, notifyMonth integer, notifyYear integer, notifyHour integer, notifyMinute integer, taskId integer, notificationUniqueId integer)');

    await db.execute(
        'create table notificationsByDayOfWeek(id integer primary key autoincrement, title varchar(15), body varchar(255), dayOfWeek varchar(15), notifyHour integer, notifyMinute integer, taskId integer, notificationUniqueId integer)');
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('alter table tasks add column wheelOrCounterVal integer');
    }
  }

  // Task Operations----------------------------------------------------------------------------------------

  Future<DailyTaskModel> createTask(DailyTaskModel dailyTask) async {
    final db = _db!.database;

    insertedNewTaskId = await db.insert('tasks', dailyTask.toMap());

    return dailyTask;
  }

  Future<int> updateTask(DailyTaskModel dailyTask, int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db
        .update('tasks', dailyTask.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> toggleDone(MakeTaskDoneModel makeItTask, int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db
        .update('tasks', makeItTask.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> getAllTasksNames() async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final List<Map<String, dynamic>> tasksNames =
        await db.rawQuery('SELECT taskName FROM tasks');
    return List.generate(
        tasksNames.length, (index) => tasksNames[index]['taskName'].toString());
  }

  Future<List<String>> getAllCategories() async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final List<Map<String, dynamic>> categories =
        await db.rawQuery('SELECT category FROM tasks');
    return List.generate(
        categories.length, (index) => categories[index]['category'].toString());
  }

  Future<DailyTaskModel> showTask(int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return DailyTaskModel.fromMap(maps.first);
    } else {
      throw Exception('data not found');
    }
  }

  // Home----------------------------------------------------------------------------------------
  Future<List<String>> getDailyTasksCategories(String date) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final List<Map<String, dynamic>> tasksCategories = await db
        .rawQuery('SELECT * FROM tasks where date = ? and pinned = 0', [date]);

    return List.generate(tasksCategories.length,
        (index) => tasksCategories[index]['category'].toString());
  }

  Future<int> getCountOfCategoryItems(String category, String date) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    var categories = await db.rawQuery(
        'SELECT * FROM tasks where category = ? and pinned = 0 and date = ?',
        [category, date]);
    int tasksCount = categories.length;

    return tasksCount;
  }

  Future<double> getCategoriesPercent(String category, String date, String day,
      [int doneTask = 1]) async {
print(date);
print('dateeeeee');
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    var task = await db.rawQuery(
        'SELECT * FROM tasks where category = ? and date = ? and pinned = 0',
        [category, date]);

    print(task.length);

    var pinnedTask = await db.rawQuery(
        'SELECT * FROM taskdays where category = ? and nameOfDay = ? and date = ?',
        [category, day, date]);

    print(pinnedTask.length);

    int tasksCount = task.length + pinnedTask.length;

    print(tasksCount);

    var done = await db.rawQuery(
        'SELECT * FROM tasks where category = ? and date = ? and done = ? and pinned = 0',
        [category, date, doneTask]);

    print(done.length);

    var pinnedDone = await db.rawQuery(
        'SELECT * FROM taskdays where category = ? and nameOfDay = ? and done = ? and date = ?',
        [category, day, doneTask, date]);

    print(pinnedDone.length);

    int doneTasksCount = done.length + pinnedDone.length;
    print(doneTasksCount);

    double percent = (doneTasksCount / tasksCount) * 100;

    print(percent);
    print('hereeeeee');

    return percent;
  }

  Future<double> getHomePercent(String date, String day, [int doneTask = 1]) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    var task = await db.rawQuery('SELECT * FROM tasks where date = ?', [date]);

    var pinnedTask =
        await db.rawQuery('SELECT * FROM taskdays where nameOfDay = ? and date = ?', [day, date]);

    int tasksCount = task.length + pinnedTask.length;

    if (tasksCount == 0) {
      return 0;
    }

    var done = await db.rawQuery(
        'SELECT * FROM tasks where date = ? and done = ?', [date, doneTask]);

    var pinnedDone = await db.rawQuery(
        'SELECT * FROM taskdays where nameOfDay = ? and done = ? and date = ?', [day, doneTask, date]);

    int doneTasksCount = done.length + pinnedDone.length;

    double percent = (doneTasksCount / tasksCount) * 100;

    return percent;
  }
  // Daily Tasks ---------------------------------------------------------------------------

  Future<List<DailyTaskModel>> loadDailyTasksByCategory(
      String category, String date) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;
    final result = await db.rawQuery(
        'SELECT * FROM tasks where date = ? and category = ? and pinned = 0 Order by id DESC',
        [date, category]);

    return result.map((map) => DailyTaskModel.fromMap(map)).toList();
  }

  //  TaskDays ----------------------------------------------------------------------------------------

  Future<TaskDaysModel> createTaskDays(TaskDaysModel taskDays) async {
    final db = _db!.database;

    await db.insert('taskDays', taskDays.toMap());

    return taskDays;
  }

  Future<List<TaskDaysModel>> showTaskDays(int mainTaskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;
    final result = await db
        .rawQuery('SELECT * FROM taskDays where mainTaskId = ?', [mainTaskId]);

    return result.map((map) => TaskDaysModel.fromMap(map)).toList();
  }

  Future<int> deleteTaskDays(int mainTaskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db
        .delete('taskDays', where: 'mainTaskId = ?', whereArgs: [mainTaskId]);
  }

  // Pinned Tasks

  Future<List<TaskDaysModel>> loadPinnedTasksByCategoryAndDay(
      String category, String day) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;
    final result = await db.rawQuery(
        'SELECT * FROM taskDays where nameOfDay = ? and category = ? Order by id ASC',
        [day, category]);

    return result.map((map) => TaskDaysModel.fromMap(map)).toList();
  }

  Future<int> getCountOfCategoryPinnedItems(String category, String day) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    var categories = await db.rawQuery(
        'SELECT * FROM taskDays where category = ? and nameOfDay = ?',
        [category, day]);
    int tasksCount = categories.length;

    return tasksCount;
  }

  Future<DailyTaskModel> showTaskByDayAndId(int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return DailyTaskModel.fromMap(maps.first);
    } else {
      throw Exception('data not found');
    }
  }

  Future<TaskDaysModel> getIdOfTaskDay(String day, int mainTaskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final maps = await db.query('taskDays',
        where: 'mainTaskId = ? and nameOfDay = ?',
        whereArgs: [mainTaskId, day]);

    if (maps.isNotEmpty) {
      return TaskDaysModel.fromMap(maps.first);
    } else {
      throw Exception('date not found');
    }
  }

  Future<List<String>> loadPinnedByCategoryDay(String day) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final List<Map<String, dynamic>> tasksCategories =
        await db.rawQuery('SELECT * FROM taskDays where nameOfDay = ?', [day]);

    return List.generate(tasksCategories.length,
        (index) => tasksCategories[index]['category'].toString());
  }

  Future<int> toggleDoneByDay(MakeTaskDoneByDayModel makeItTask, String day, int mainTaskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.update('taskDays', makeItTask.toMap(),
        where: 'mainTaskId = ? and nameOfDay = ?',
        whereArgs: [mainTaskId, day]);
  }

  Future<List<TaskDaysModel>> getAllIdsOfTaskDay(String day) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final result =
        await db.rawQuery('SELECT * FROM taskDays where nameOfDay = ?', [day]);

    return result.map((map) => TaskDaysModel.fromMap(map)).toList();
  }

  Future<int> updateDailyDateOfTaskDay(
      UpdateDailyDateOfTaskDay makeItTask, int dayId, String day) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.update('taskDays', makeItTask.toMap(),
        where: 'id = ? and nameOfDay = ?', whereArgs: [dayId, day]);
  }

  Future<int> updateDoneForWeekOfTaskDay(
      MakeTaskDoneByDayModel updateDoneForWeek, int dayId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.update('taskDays', updateDoneForWeek.toMap(),
        where: 'id = ?', whereArgs: [dayId]);
  }

  Future<int> updateDoneForWeekOfTasks(
      MakeTaskDoneModel updateDoneForWeek, int dayId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.update('tasks', updateDoneForWeek.toMap(),
        where: 'id = ?', whereArgs: [dayId]);
  }

  // First Load -----------------------------------------------------------------------------------------------
  Future<FirstLoad> createFirstLoadRow(FirstLoad firstLoad) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    await db.insert('firstLoad', firstLoad.toMap());

    return firstLoad;
  }

  Future<FirstLoad> fetchFirstLoad(String date, [int reloaded = 1]) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final maps = await db.query('firstLoad', where: 'date = ?', whereArgs: [date]);

    if (maps.isNotEmpty) {
      return FirstLoad.fromMap(maps.first);
    } else {
      throw Exception('data not found');
    }
  }

  Future<int> updateFirstLoad(
      UpdateFirstLoad updateFirstLoad, int id) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.update('firstLoad', updateFirstLoad.toMap(),
        where: 'id = ?', whereArgs: [id]);
  }

  // notification by date --------------------------------------------------------------------------------------
  Future<NotificationByDate> createNotificationByDate(NotificationByDate notificationByDate) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    await db.insert('notificationsByDate', notificationByDate.toMap());

    return notificationByDate;
  }

  Future<NotificationByDate> showNotificationByDate(int taskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final maps = await db.query('notificationsByDate', where: 'taskId = ?', whereArgs: [taskId]);

    if (maps.isNotEmpty) {
      return NotificationByDate.fromMap(maps.first);
    } else {
      throw Exception('data not found');
    }
  }

  Future<int> deleteNotificationByDate(int taskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.delete('notificationsByDate', where: 'taskId = ?', whereArgs: [taskId]);
  }
  // notification by day of week --------------------------------------------------------------------------
  Future<NotificationByDayOfWeek> createNotificationByDayOfWeek(NotificationByDayOfWeek notificationByDayOfWeek) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    await db.insert('notificationsByDayOfWeek', notificationByDayOfWeek.toMap());

    return notificationByDayOfWeek;
  }

  Future<NotificationByDayOfWeek> showNotificationByDayOfWeek(int taskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    final maps = await db.query('notificationsByDayOfWeek', where: 'taskId = ?', whereArgs: [taskId]);

    if (maps.isNotEmpty) {
      return NotificationByDayOfWeek.fromMap(maps.first);
    } else {
      throw Exception('data not found');
    }
  }

  Future<int> deleteNotificationByDayOfWeek(int taskId) async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    return db.delete('notificationsByDayOfWeek', where: 'taskId = ?', whereArgs: [taskId]);
  }
  // Others -----------------------------------------------------------------------------------------------

  Future close() async {
    if (_db == null) {
      await initDB(dbdName);
    }

    final db = _db!.database;

    db.close();
  }
}
