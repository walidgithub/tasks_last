import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/daily_task_model.dart';
import '../../../../domain/entities/first_load.dart';
import '../../../../domain/entities/report_model.dart';
import '../../../../domain/entities/task_days_model.dart';
import '../../../../domain/repositories/task_repo_imp.dart';
import '../../../../shared/preferences/dbHelper.dart';
import '../../../di/di.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.taskRepoImp) : super(HomeInitial());

  TaskRepoImp taskRepoImp;

  static HomeCubit get(context) => BlocProvider.of(context);

  Set<String> categories = {};

  var tasks = [];

  List<double> categoryPercent = [];
  List<int> itemsCount = [];
  List<int> pinnedItemsCount = [];

  List<ReportModel> listForReport = [];

  double totalPercent = 0.0;
  double totalReportRowPercent = 0.0;

  // -----------------------------------------------------------------------------
  Future<void> loadTasksCategories(String date, String day) async {
    try {
      emit(LoadingCategoriesState());
      categoryPercent = [];
      itemsCount = [];
      pinnedItemsCount = [];

      await getDailyCategories(date).then((allDailyCategories) async {
        categories = allDailyCategories.toSet();

        await loadPinnedByCategoryDay(day).then((allPinnedCategory) async {
          categories.addAll(allPinnedCategory);
        });

        for (var category in categories) {
          await getItemsCountInCategory(category, date).then((count) {
            itemsCount.add(count);
          });

          await getPinnedItemsCountInCategory(category, day).then((count) {
            pinnedItemsCount.add(count);
          });

          await getCategoryPercent(category, date, day).then((percent) {
            categoryPercent.add(percent);
          });
        }
      });
      emit(LoadedCategoriesState());
    } catch (e) {
      emit(ErrorLoadingCategoriesState(e.toString()));
    }
  }

  Future<List<String>> getDailyCategories(String date) async {
    final res = await taskRepoImp.getDailyCategories(date);
    return res;
  }

  Future<void> updateDailyDateOfTaskDay(String day, String date) async {
    final allIds = await taskRepoImp.getAllIdsOfTaskDay(day);
    for (var idIndex in allIds) {
      await taskRepoImp.updateDailyDateOfTaskDay(
          UpdateDailyDateOfTaskDay(id: idIndex.id!, date: date),
          idIndex.id!,
          day);
    }
  }

  Future<void> updateDoneForWeekOfTaskDay(String day, String date) async {
    if (day == 'Mon') {
      await taskRepoImp
          .addFirstLoadRow(FirstLoad(date: DateTime.parse(date), reloaded: 0));

      await taskRepoImp.fetchFirstLoad(date).then((value) async {
        if (value.date.toString().replaceFirst(RegExp(' '), 'T') == date) {
          if (value.reloaded != 1) {
            final allIds = await taskRepoImp.getAllIdsOfTaskDay(day);
            for (var idIndex in allIds) {
              await taskRepoImp.updateDoneForWeekOfTaskDay(
                  MakeTaskDoneByDayModel(id: idIndex.id!, done: 0),
                  idIndex.id!);
              await taskRepoImp.updateDoneForWeekOfTasks(
                  MakeTaskDoneModel(id: idIndex.mainTaskId!, done: 0),
                  idIndex.mainTaskId!);
            }
            await taskRepoImp.updateFirstLoad(
                UpdateFirstLoad(id: value.id, reloaded: 1), value.id!);
          }
        }
      });
    }
  }

  // Total percent-----------------------------------------------------------------------------
  Future<void> loadTotalTasksPercent(String date, String day) async {
    try {
      await getHomePercent(date, day).then((value) {
        totalPercent = value;
      });

      emit(LoadHomePercentState());
    } catch (e) {
      emit(ErrorLoadingHomePercentState(e.toString()));
    }
  }

  Future<double> getHomePercent(String date, String day) async {
    final homePercent = await taskRepoImp.getPercentForHome(date, day);
    return homePercent;
  }

  // Category percent-----------------------------------------------------------------------------
  Future<double> getCategoryPercent(
      String category, String date, String day) async {
    final categoryPercent =
        await taskRepoImp.getPercentForCategory(category, date, day);
    return categoryPercent;
  }

  // Get count of category's items-----------------------------------------------------------------------------
  Future<int> getItemsCountInCategory(String category, String date) async {
    final itemsCount =
        await taskRepoImp.getItemsCountInCategory(category, date);
    return itemsCount;
  }

  // Get count of category's pinned items-----------------------------------------------------------------------------
  Future<int> getPinnedItemsCountInCategory(String category, String day) async {
    final itemsCount =
        await taskRepoImp.getCountOfCategoryPinnedItems(category, day);
    return itemsCount;
  }

  Future<List<String>> loadPinnedByCategoryDay(String day) async {
    final res = await taskRepoImp.loadPinnedByCategoryDay(day);
    return res;
  }

  // Reports -------------------------------------------------------------
  Future<void> closeDay(String date) async {
      await taskRepoImp.closeDay(date);
      emit(CloseDayState());
  }

  Future<void> deleteClosedDay(String date) async {
    await taskRepoImp.deleteClosedDay(date);
  }

  Future<void> loadTotalReportRowPercent(String date) async {
    totalReportRowPercent = await taskRepoImp.loadTotalReportRowPercent(date);
    emit(LoadReportRowPercentState());
  }

  Future<List<ReportModel>> loadDailyTasksByDate(
      String firstDate, String toDate) async {
    final res = await taskRepoImp.loadDailyTasksByDate();
    listForReport = res;
    print(listForReport);
    print('listForReport');
    emit(LoadReportsState());
    return res;
  }
}
