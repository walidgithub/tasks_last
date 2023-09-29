import '../../../domain/entities/daily_task_model.dart';
import '../../../domain/entities/first_load.dart';
import '../../../domain/entities/notification_by_date_model.dart';
import '../../../domain/entities/notification_by_day_of_week_model.dart';
import '../../../domain/entities/report_model.dart';
import '../../../domain/entities/task_days_model.dart';

abstract class TaskRepository {
  // Task Operations -----------------------------------------------------------------------
  Future<void> addTask(DailyTaskModel dailyTaskModel);
  Future<void> deleteTask(int taskId);
  Future<void> updateOldTask(DailyTaskModel dailyTaskModel, int taskId);
  Future<void> toggleDone(MakeTaskDoneModel makeItDone, int taskId);
  Future<List<String>> getTasksNames();
  Future<List<String>> getAllCategories();
  Future<DailyTaskModel> showTask(int taskId);

  // Home -----------------------------------------------------------------------
  Future<List<String>> getDailyCategories(String date);
  Future<double> getPercentForCategory(String category, String date, String day);
  Future<double> getPercentForHome(String date, String day);
  Future<int> getItemsCountInCategory(String category, String date);

  // Daily Tasks -----------------------------------------------------------------------
  Future<List<DailyTaskModel>> loadDailyTasksByCategory(
      String category, String date);

  // Reports -----------------------------------------------------------------------
  Future<double> loadTotalReportRowPercent(String date);
  Future<void> closeDay(String date);
  Future<void> deleteClosedDay(String date);
  Future<List<ReportModel>> loadDailyTasksByDate();

  // Task Days -----------------------------------------------------------------------
  Future<void> addTaskDay(TaskDaysModel taskDays);
  Future<void> deleteTaskDay(int taskId);
  Future<List<TaskDaysModel>> showTaskDays(int taskId);
  Future<TaskDaysModel> getIdOfTaskDay(String day, int mainTaskId);

  // Pinned Tasks -----------------------------------------------------------------------
  Future<List<TaskDaysModel>> loadPinnedTasksByCategoryAndDay(
      String category, String day);
  Future<int> getCountOfCategoryPinnedItems(String category, String day);
  Future<DailyTaskModel> showTaskByDayAndId(int id);

  Future<List<String>> loadPinnedByCategoryDay(String day);
  Future<void> toggleDoneByDay(
      MakeTaskDoneByDayModel makeItDone, String day, int mainTaskId);
  Future<List<TaskDaysModel>> getAllIdsOfTaskDay(String day);
  Future<void> updateDailyDateOfTaskDay(
      UpdateDailyDateOfTaskDay updateDailyDate, int dayId, String day);
  Future<void> updateDoneForWeekOfTaskDay(
      MakeTaskDoneByDayModel updateDoneForWeek, int dayId);
  Future<void> updateDoneForWeekOfTasks(
      MakeTaskDoneModel updateDoneForWeek, int dayId);

  // first load -----------------------------------------------------------------------
  Future<void> addFirstLoadRow(FirstLoad firstLoad);
  Future<FirstLoad> fetchFirstLoad(String date);
  Future<void> updateFirstLoad(
      UpdateFirstLoad updateFirstLoad, int id);

  // Notification By Date -----------------------------------------------------------------------
  Future<void> createNotificationByDate(NotificationByDate notificationByDate);
  Future<void> deleteNotificationByDate(int taskId);
  Future<NotificationByDate> showNotificationByDate(int taskId);

  // Notification By Day Of Week -----------------------------------------------------------------------
  Future<void> createNotificationByDayOfWeek(NotificationByDayOfWeek notificationByDayOfWeek);
  Future<void> deleteNotificationByDayOfWeek(int taskId);
  Future<NotificationByDayOfWeek> showNotificationByDayOfWeek(int taskId);
  // Others -----------------------------------------------------------------------

}
