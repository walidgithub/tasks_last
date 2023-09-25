import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/daily_task_model.dart';
import '../../../../domain/entities/task_days_model.dart';
import '../../../../domain/repositories/task_repo_imp.dart';
import 'daily_tasks_state.dart';

class DailyTasksCubit extends Cubit<DailyTasksState> {
  DailyTasksCubit(this.taskRepoImp) : super(DailyTasksInitial());

  TaskRepoImp taskRepoImp;

  static DailyTasksCubit get(context) => BlocProvider.of(context);

  var dailyTasks = [];

  Future<void> executeLoadingTasksByCategory(
      String category, String date, String day) async {
    try {
      emit(LoadingDailyTasksState());

      await loadDailyTasksByCategory(category, date).then((allDailyTasks) {
        for (var v in allDailyTasks) {
          dailyTasks.add(v.toMap());
        }
      });

      await loadPinnedTasksByCategoryAndDay(category, day)
          .then((allPinnedDailyTasks) async {
        for (var v in allPinnedDailyTasks) {
          int? mainTaskId = v.mainTaskId;
          var res = await showTaskByDayAndId(mainTaskId!);
          dailyTasks.add(res.toMap());
        }
      });

      emit(LoadedDailyTasksState());
    } catch (e) {
      emit(ErrorLoadingDailyTasksState(e.toString()));
    }
  }

  Future<void> updateTask(
      DailyTaskModel dailyTaskModel, TaskDaysModel taskDays, int taskId) async {
    try {
      await taskRepoImp.updateOldTask(dailyTaskModel, taskId);
      emit(UpdateTaskState());
    } catch (e) {
      emit(ErrorUpdateTaskState(e.toString()));
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await taskRepoImp.deleteTask(taskId);
      await taskRepoImp.deleteTaskDay(taskId);

      var index = dailyTasks.indexWhere((element) => element['id'] == taskId);

      dailyTasks.removeAt(index);

      emit(DeleteTaskState());
    } catch (e) {
      emit(ErrorDeleteTaskState(e.toString()));
    }
  }

  Future<void> toggleDone(MakeTaskDoneModel makeItDone, int taskId) async {
    try {
      await taskRepoImp.toggleDone(makeItDone, taskId);
      var index = dailyTasks.indexWhere((element) => element['id'] == taskId);

      if (dailyTasks[index]['done'] == 1) {
        dailyTasks[index]['done'] = 0;
        emit(UnMakeTaskDoneState());
      } else {
        dailyTasks[index]['done'] = 1;
        emit(MakeTaskDoneState());
      }
    } catch (e) {
      emit(ErrorMakeTaskDoneState(e.toString()));
    }
  }

  Future<List<DailyTaskModel>> loadDailyTasksByCategory(
      String category, String date) async {
    final res = await taskRepoImp.loadDailyTasksByCategory(category, date);
    return res;
  }

  // Pinned tasks
  Future<List<TaskDaysModel>> loadPinnedTasksByCategoryAndDay(
      String category, String day) async {
    final res =
        await taskRepoImp.loadPinnedTasksByCategoryAndDay(category, day);
    return res;
  }

  Future<DailyTaskModel> showTaskByDayAndId(int id) async {
    final res = await taskRepoImp.showTaskByDayAndId(id);
    return res;
  }

  Future<TaskDaysModel> getIdOfTaskDay(String day, int mainTaskId) async {
    final res = await taskRepoImp.getIdOfTaskDay(day, mainTaskId);
    return res;
  }

  Future<void> toggleDoneByDay(MakeTaskDoneByDayModel makeItDone, String day, int mainTaskId) async {
    try {
      await taskRepoImp.toggleDoneByDay(makeItDone, day, mainTaskId);
      emit(TaskDayUpdateDoneState());
    } catch (e) {
      emit(ErrorTaskDayUpdateDoneState(e.toString()));
    }
  }
}
