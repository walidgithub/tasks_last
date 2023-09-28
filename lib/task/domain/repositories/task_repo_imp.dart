import 'package:daily_tasks/task/domain/entities/first_load.dart';
import 'package:daily_tasks/task/domain/entities/notification_by_date_model.dart';
import 'package:daily_tasks/task/domain/entities/notification_by_day_of_week_model.dart';
import 'package:daily_tasks/task/domain/entities/task_days_model.dart';

import '../../data/data_sources/local/task_repo.dart';
import '../../shared/preferences/dbHelper.dart';
import '../entities/daily_task_model.dart';

class TaskRepoImp extends TaskRepository {
  final DbHelper _dbHelper;

  TaskRepoImp(this._dbHelper) {
    _dbHelper.database;
  }

  // Task Operations -----------------------------------------------------------------------
  @override
  Future<void> addTask(DailyTaskModel dailyTaskModel) async {
    await _dbHelper.createTask(dailyTaskModel);
    await getTasksNames();
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await _dbHelper.deleteTask(taskId);
  }

  @override
  Future<void> updateOldTask(DailyTaskModel dailyTaskModel, int taskId) async {
    await _dbHelper.updateTask(dailyTaskModel, taskId);
  }

  @override
  Future<void> toggleDone(MakeTaskDoneModel makeItDone, int taskId) async {
    await _dbHelper.toggleDone(makeItDone, taskId);
  }

  @override
  Future<List<String>> getTasksNames() async {
    final res = await _dbHelper.getAllTasksNames();
    return res;
  }

  @override
  Future<List<String>> getAllCategories() async {
    final res = await _dbHelper.getAllCategories();
    return res;
  }

  @override
  Future<DailyTaskModel> showTask(int taskId) async {
    final res = await _dbHelper.showTask(taskId);
    return res;
  }

  // Home -----------------------------------------------------------------------
  @override
  Future<List<String>> getDailyCategories(String date) async {
    final res = await _dbHelper.getDailyTasksCategories(date);
    return res;
  }

  @override
  Future<double> getPercentForCategory(String category, String date, String day) async {
    final res = await _dbHelper.getCategoriesPercent(category, date, day);
    return res;
  }

  @override
  Future<double> getPercentForHome(String date, String day) async {
    final res = await _dbHelper.getHomePercent(date, day);
    return res;
  }

  @override
  Future<int> getItemsCountInCategory(String category, String date) async {
    final res = await _dbHelper.getCountOfCategoryItems(category, date);
    return res;
  }

  // Daily Tasks -----------------------------------------------------------------------
  @override
  Future<List<DailyTaskModel>> loadDailyTasksByCategory(
      String category, String date) async {
    final res = await _dbHelper.loadDailyTasksByCategory(category, date);
    return res;
  }

  // Task Days -----------------------------------------------------------------------
  @override
  Future<void> addTaskDay(TaskDaysModel taskDays) async {
    await _dbHelper.createTaskDays(taskDays);
  }

  @override
  Future<List<TaskDaysModel>> showTaskDays(int taskId) async {
    final res = await _dbHelper.showTaskDays(taskId);
    return res;
  }

  @override
  Future<void> deleteTaskDay(int taskId) async {
    await _dbHelper.deleteTaskDays(taskId);
  }

  @override
  Future<TaskDaysModel> getIdOfTaskDay(String day, int mainTaskId) async {
    final res = await _dbHelper.getIdOfTaskDay(day, mainTaskId);
    return res;
  }

  // Pinned Tasks -----------------------------------------------------------------------
  @override
  Future<int> getCountOfCategoryPinnedItems(String category, String day) async {
    final res = await _dbHelper.getCountOfCategoryPinnedItems(category, day);
    return res;
  }

  @override
  Future<List<TaskDaysModel>> loadPinnedTasksByCategoryAndDay(String category, String day) async {
    final res = await _dbHelper.loadPinnedTasksByCategoryAndDay(category, day);
    return res;
  }

  @override
  Future<List<String>> loadPinnedByCategoryDay(String day) async {
    final res = await _dbHelper.loadPinnedByCategoryDay(day);
    return res;
  }

  @override
  Future<DailyTaskModel> showTaskByDayAndId(int id) async {
    final res = await _dbHelper.showTaskByDayAndId(id);
    return res;
  }

  @override
  Future<void> toggleDoneByDay(
      MakeTaskDoneByDayModel makeItDone, String day, int mainTaskId) async {
    await _dbHelper.toggleDoneByDay(makeItDone, day, mainTaskId);
  }

  @override
  Future<List<TaskDaysModel>> getAllIdsOfTaskDay(String day) async {
    final res = await _dbHelper.getAllIdsOfTaskDay(day);
    return res;
  }

  @override
  Future<void> updateDailyDateOfTaskDay(
      UpdateDailyDateOfTaskDay updateDailyDate, int dayId, String day) async {
    await _dbHelper.updateDailyDateOfTaskDay(updateDailyDate, dayId, day);
  }

  @override
  Future<void> updateDoneForWeekOfTaskDay(
      MakeTaskDoneByDayModel updateDoneForWeek, int dayId) async {
    await _dbHelper.updateDoneForWeekOfTaskDay(updateDoneForWeek, dayId);
  }

  @override
  Future<void> updateDoneForWeekOfTasks(
      MakeTaskDoneModel updateDoneForWeek, int dayId) async {
    await _dbHelper.updateDoneForWeekOfTasks(updateDoneForWeek, dayId);
  }

  // First Load -----------------------------------------------------------------------
  @override
  Future<void> addFirstLoadRow(FirstLoad firstLoad) async {
    await _dbHelper.createFirstLoadRow(firstLoad);
  }

  @override
  Future<FirstLoad> fetchFirstLoad(String date) async {
    final res = await _dbHelper.fetchFirstLoad(date);
    return res;
  }

  @override
  Future<void> updateFirstLoad(
      UpdateFirstLoad updateFirstLoad, int id) async {
    await _dbHelper.updateFirstLoad(updateFirstLoad, id);
  }

  // Notification By Date -----------------------------------------------------------------------
  @override
  Future<void> createNotificationByDate(NotificationByDate notificationByDate) async {
    await _dbHelper.createNotificationByDate(notificationByDate);
  }

  @override
  Future<NotificationByDate> showNotificationByDate(int taskId) async {
    final res = await _dbHelper.showNotificationByDate(taskId);
    return res;
  }

  @override
  Future<void> deleteNotificationByDate(int taskId) async {
    await _dbHelper.deleteNotificationByDate(taskId);
  }

  // Notification By Day Of Week -----------------------------------------------------------------------
  @override
  Future<void> createNotificationByDayOfWeek(NotificationByDayOfWeek notificationByDayOfWeek) async {
    await _dbHelper.createNotificationByDayOfWeek(notificationByDayOfWeek);
  }

  @override
  Future<NotificationByDayOfWeek> showNotificationByDayOfWeek(int taskId) async {
    final res = await _dbHelper.showNotificationByDayOfWeek(taskId);
    return res;
  }

  @override
  Future<void> deleteNotificationByDayOfWeek(int taskId) async {
    await _dbHelper.deleteNotificationByDayOfWeek(taskId);
  }

  // Others --------------------------------------------------------------------------

}
