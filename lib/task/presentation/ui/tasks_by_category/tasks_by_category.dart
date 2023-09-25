import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:daily_tasks/task/domain/entities/daily_task_model.dart';
import 'package:daily_tasks/task/presentation/ui/daily_tasks/daily_tasks_cubit/daily_tasks_cubit.dart';
import 'package:daily_tasks/task/presentation/ui/daily_tasks/daily_tasks_cubit/daily_tasks_state.dart';
import 'package:daily_tasks/task/shared/constant/padding_margin_values_manager.dart';
import '../../../domain/entities/task_days_model.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../../../shared/utils/utils.dart';
import '../../di/di.dart';
import '../../router/app_router.dart';
import '../../router/arguments.dart';
import '../daily_tasks/daily_tasks.dart';

class TasksByCategory extends StatefulWidget {
  const TasksByCategory({Key? key, required this.arguments}) : super(key: key);

  final TasksByCategoryArguments arguments;

  @override
  State<TasksByCategory> createState() => _TasksByCategoryState();
}

class _TasksByCategoryState extends State<TasksByCategory> {

  var loadedTasks = [];

  int? _done;

  DateTime today = DateTime.now();

  void _toggleDone(value) {
    if (value == 1) {
      _done = 0;
    } else {
      _done = 1;
    }
  }

  Future<void> executeToggleDone(BuildContext context, int index) async {
    _toggleDone(_done);

    String dayOfToday = DateFormat('EEEE').format(today);
    String dayOfWeekOfToday = dayOfToday.substring(0, 3);

    String originalDate =
        DateTime.parse(today.toString().split(" ")[0]).toString();
    String searchByToday = originalDate.replaceFirst(RegExp(' '), 'T');

    await DailyTasksCubit.get(context).toggleDone(
        MakeTaskDoneModel(id: loadedTasks[index]['id'], done: _done),
        loadedTasks[index]['id']);

    if (loadedTasks[index]['pinned'] == 1) {

      int? idOfTaskDay;
      await DailyTasksCubit.get(context)
          .getIdOfTaskDay(dayOfWeekOfToday, loadedTasks[index]['id'])
          .then((value) {
        idOfTaskDay = value.id;
      });

      DailyTasksCubit.get(context).toggleDoneByDay(
          MakeTaskDoneByDayModel(id: idOfTaskDay, done: _done),
          dayOfWeekOfToday,
          loadedTasks[index]['id']);
    }
  }

  void deleteTask(BuildContext context, int index) {
    DailyTasksCubit.get(context).deleteTask(loadedTasks[index]['id']);
  }

  void editTask(BuildContext context, int index) {
    Navigator.of(context).pushReplacementNamed(Routes.goToTask,
        arguments:
            GoToTaskArguments(editType: 'Edit', id: loadedTasks[index]['id']));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.darkPrimary,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.arguments.category!.length > 8 &&
                          int.parse(widget.arguments.countOfItems.toString()) > 99
                      ? '${widget.arguments.category!.substring(0, 7)}..'
                      : widget.arguments.category!.length > 10
                          ? '${widget.arguments.category!.substring(0, 7)}..'
                          : widget.arguments.category!),
                  Row(
                    children: [
                      Text(
                          int.parse(widget.arguments.countOfItems.toString()) > 99
                              ? '(+99'
                              : '(${widget.arguments.countOfItems}'),
                      SizedBox(
                        width: AppConstants.smallDistance,
                      ),
                      Text('${AppStrings.items.tr()})'),
                    ],
                  )
                ],
              ),
            ),
            leading: Bounceable(
                duration: Duration(milliseconds: AppConstants.durationOfBounceable),
                onTap: () async {
                  await Future.delayed(Duration(milliseconds: AppConstants.durationOfDelay));

                  Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
                },
                child: const Icon(Icons.home)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Center(
                    child: Text(widget.arguments.tasksDate
                        .toString()
                        .split(" ")[0]
                        .substring(0, 10))),
              ),
            ],
          ),
          body: bodyContent(context)),
    );
  }

  Widget bodyContent(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DailyTasksCubit>()
        ..executeLoadingTasksByCategory(widget.arguments.category!,
            widget.arguments.tasksDate!, widget.arguments.tasksDay!),
      child: BlocConsumer<DailyTasksCubit, DailyTasksState>(
        listener: (context, state) {
          if (state is LoadingDailyTasksState) {
          } else if (state is LoadedDailyTasksState) {
            loadedTasks = DailyTasksCubit.get(context).dailyTasks;
          } else if (state is ErrorLoadingDailyTasksState) {
            // done states ------------------------------------------------------------
          } else if (state is MakeTaskDoneState) {
            loadedTasks = DailyTasksCubit.get(context).dailyTasks;
            final snackBar = SnackBar(
              duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
              content: Text(AppStrings.successfullyDone.tr()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is UnMakeTaskDoneState) {
            loadedTasks = DailyTasksCubit.get(context).dailyTasks;
            final snackBar = SnackBar(
              duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
              content: Text(AppStrings.successfullyUnDone.tr()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is ErrorMakeTaskDoneState) {
            // delete states ----------------------------------------------------------
          } else if (state is DeleteTaskState) {
            loadedTasks = DailyTasksCubit.get(context).dailyTasks;
            final snackBar = SnackBar(
              duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
              content: Text(AppStrings.successfullyDeleted.tr()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            if (loadedTasks.isEmpty) {
              Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
            }
          } else if (state is ErrorDeleteTaskState) {}
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(AppPadding.p5, AppPadding.p10, AppPadding.p5, AppPadding.p10),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: loadedTasks.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        _done = loadedTasks[index]['done'];

                        return Slidable(
                          key: ValueKey(loadedTasks[index]),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            // dismissible: DismissiblePane(onDismissed: (){print('others');},),
                            children: [
                              loadedTasks[index]['pinned'] == 1
                                  ? widget.arguments.tasksDate
                                              .toString()
                                              .split(" ")[0]
                                              .substring(0, 10) !=
                                          today
                                              .toString()
                                              .split(" ")[0]
                                              .substring(0, 10)
                                      ? const SizedBox.shrink()
                                      : SlidableAction(
                                          onPressed: (context) =>
                                              executeToggleDone(context, index),
                                          flex: 2,
                                          backgroundColor:
                                              ColorManager.lightPrimary,
                                          foregroundColor: ColorManager.basic,
                                          icon: _done == 1
                                              ? Icons.hourglass_bottom
                                              : Icons.check,
                                          label: _done == 1 ? 'UnDone' : 'Done',
                                        )
                                  : SlidableAction(
                                      onPressed: (context) =>
                                          executeToggleDone(context, index),
                                      flex: 2,
                                      backgroundColor:
                                          ColorManager.lightPrimary,
                                      foregroundColor: ColorManager.basic,
                                      icon: _done == 1
                                          ? Icons.hourglass_bottom
                                          : Icons.check,
                                      label: _done == 1 ? 'UnDone' : 'Done',
                                    ),
                              _done == 0
                                  ? SlidableAction(
                                      onPressed: (context) =>
                                          editTask(context, index),
                                      backgroundColor: ColorManager.accent,
                                      foregroundColor: ColorManager.basic,
                                      icon: Icons.edit,
                                      label: 'Edit')
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            // dismissible: DismissiblePane(onDismissed: (){print('Delete');},),
                            children: [
                              loadedTasks[index]['pinned'] == 1
                                  ? const SizedBox.shrink()
                                  : SlidableAction(
                                      onPressed: (context) =>
                                          deleteTask(context, index),
                                      backgroundColor: ColorManager.accent2,
                                      foregroundColor: ColorManager.basic,
                                      icon: Icons.delete,
                                      label: 'Delete'),
                            ],
                          ),
                          closeOnScroll: false,
                          child: DailyTasks(
                            arguments: DailyTasksArguments(
                                id: loadedTasks[index]['id'],
                                wheel: loadedTasks[index]['wheel'],
                                nestedVal: loadedTasks[index]['nestedVal'],
                                nested: loadedTasks[index]['nested'],
                                counterVal: loadedTasks[index]['counterVal'],
                                counter: loadedTasks[index]['counter'],
                                description: loadedTasks[index]['description'],
                                taskName: loadedTasks[index]['taskName'],
                                time: loadedTasks[index]['time'],
                                timer: loadedTasks[index]['timer'],
                                done: loadedTasks[index]['done'],
                                pinned: loadedTasks[index]['pinned'],
                                date: widget.arguments.tasksDate,
                            ),
                          ),
                        );
                      },
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}
