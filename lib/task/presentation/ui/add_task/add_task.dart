import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:daily_tasks/task/presentation/router/arguments.dart';
import 'package:daily_tasks/task/shared/constant/padding_margin_values_manager.dart';
import 'package:daily_tasks/task/shared/preferences/dbHelper.dart';
import '../../../domain/entities/daily_task_model.dart';
import '../../../domain/entities/notification_by_date_model.dart';
import '../../../domain/entities/task_days_model.dart';
import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/style/colors_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../shared/utils/utils.dart';
import '../../router/app_router.dart';
import '../daily_tasks/widgets.dart';
import 'add_task_cubit/add_task_cubit.dart';
import 'add_task_cubit/add_task_state.dart';

class AddTask extends StatefulWidget {
  GoToTaskArguments arguments;

  AddTask({super.key, required this.arguments});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var oldTask;
  bool notifyMe = false;

  int notifyDay = 0;
  int notifyMonth = 0;
  int notifyYear = 0;
  int notifyHour = 0;
  int notifyMinute = 0;

  @override
  void initState() {
    AddTaskCubit.get(context).loadCategories();
    if (widget.arguments.editType == 'Edit') {
      AddTaskCubit.get(context).loadTaskById(widget.arguments.id!);
    }
    super.initState();
  }

  var _selectedTask;
  var _selectedCategory;

  final FocusNode _taskFN = FocusNode();
  final FocusNode _descriptionFN = FocusNode();
  final FocusNode _categoryFN = FocusNode();

  int? _counterValue = 0;

  int notificationId = 100;

  final scrollController = ScrollController();

  final TextEditingController _taskNameEditingController =
      TextEditingController();

  final TextEditingController _descriptionEditingController =
      TextEditingController();

  final TextEditingController _categoryEditingController =
      TextEditingController();

  List taskDaysList = [
    {
      'nameOfDay': 'Sun',
      'checkedDay': false,
      'dayNum': 7,
    },
    {
      'nameOfDay': 'Mon',
      'checkedDay': false,
      'dayNum': 1,
    },
    {
      'nameOfDay': 'Tue',
      'checkedDay': false,
      'dayNum': 2,
    },
    {
      'nameOfDay': 'Wed',
      'checkedDay': false,
      'dayNum': 3,
    },
    {
      'nameOfDay': 'Thu',
      'checkedDay': false,
      'dayNum': 4,
    },
    {
      'nameOfDay': 'Fri',
      'checkedDay': false,
      'dayNum': 5,
    },
    {
      'nameOfDay': 'Sat',
      'checkedDay': false,
      'dayNum': 6,
    },
  ];

  DateTime today = DateTime.now();

  bool _nested = false;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  Set<String>? tasksItemsScreen;
  Set<String> categories = {};

  TimeOfDay _timeOfDay = TimeOfDay.now();

  void _showTimePicker(BuildContext context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  bool _addNewCategory = true;

  void _changeToAddNewCategory(value) {
    setState(() {
      _addNewCategory = value;
    });
  }

  bool _timer = false;

  void _changeToTimer(value) {
    setState(() {
      _timer = value;
    });
  }

  bool _specificDate = false;

  void _changeToSpecificDate(value) {
    setState(() {
      _specificDate = value;
      if (_specificDate) {
        _nested = false;
        _pinned = false;
        scrollController.animateTo(
            scrollController.position.maxScrollExtent + 120,
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            curve: Curves.linear);
      }
    });
  }

  bool _pinned = false;

  void _changeToPinned(value) {
    setState(() {
      _pinned = value;
      if (_pinned) {
        _specificDate = false;
        scrollController.animateTo(
            scrollController.position.maxScrollExtent + 120,
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            curve: Curves.linear);
      }
    });
  }

  bool _counter = false;

  void _changeToCounter(value) {
    setState(() {
      _counter = value;
      if (_counter) {
        _wheel = false;
        scrollController.animateTo(
            scrollController.position.maxScrollExtent + 120,
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            curve: Curves.linear);
      }
    });
  }

  bool _wheel = false;

  void _changeToWheel(value) {
    setState(() {
      _wheel = value;
      if (_counter) {
        _counter = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.darkPrimary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.arguments.editType == 'Edit'
                    ? Text(AppStrings.update.tr())
                    : Text(AppStrings.create.tr()),
              ],
            ),
            leading: Bounceable(
                duration:
                    Duration(milliseconds: AppConstants.durationOfBounceable),
                onTap: () async {
                  await Future.delayed(
                      Duration(milliseconds: AppConstants.durationOfDelay));

                  Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
                },
                child: const Icon(Icons.home_outlined)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppPadding.p8),
                child: Row(
                  children: [
                    widget.arguments.editType == 'Add'
                        ? Container()
                        : Row(
                            children: [
                              Bounceable(
                                  duration: Duration(
                                      milliseconds:
                                          AppConstants.durationOfBounceable),
                                  onTap: () async {
                                    await Future.delayed(Duration(
                                        milliseconds:
                                            AppConstants.durationOfDelay));

                                    await AddTaskCubit.get(context)
                                        .deleteTask(widget.arguments.id!);

                                    Navigator.of(context)
                                        .pushReplacementNamed(Routes.mainRoute);
                                  },
                                  child: const Icon(Icons.delete)),
                              SizedBox(
                                width: AppConstants.widthBetweenElements,
                              ),
                            ],
                          ),
                    Bounceable(
                        duration: Duration(
                            milliseconds: AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds: AppConstants.durationOfDelay));

                          if (_taskNameEditingController.text.trim() == '') {
                            final snackBar = SnackBar(
                              duration: Duration(
                                  milliseconds: AppConstants.durationOfSnackBar),
                              content: Text(AppStrings.taskAlert.tr()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }

                          if (_descriptionEditingController.text.trim() == '') {
                            final snackBar = SnackBar(
                              duration: Duration(
                                  milliseconds: AppConstants.durationOfSnackBar),
                              content: Text(AppStrings.descriptionAlert.tr()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }

                          if (_categoryEditingController.text.trim() == '' &&
                              _addNewCategory == false) {
                            final snackBar = SnackBar(
                              duration: Duration(
                                  milliseconds: AppConstants.durationOfSnackBar),
                              content: Text(AppStrings.categoryAlert.tr()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          } else if (_selectedCategory == '' &&
                              _addNewCategory == false) {
                            final snackBar = SnackBar(
                              duration: Duration(
                                  milliseconds: AppConstants.durationOfSnackBar),
                              content: Text(AppStrings.categoryAlert.tr()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }

                          // --------------------------------------------------------------------------
                          if (_pinned) {
                            int checkedDaysCount = 0;
                            for (var selectedDay in taskDaysList) {
                              if (selectedDay['checkedDay'] == false) {
                                checkedDaysCount++;
                              }
                            }
                            if (checkedDaysCount == 7) {
                              _pinned = false;
                            }
                          }

                          // -------------------------------------------------------------------------

                          if (_pinned) {
                            // add new pinned task
                            DailyTaskModel dailyModel = DailyTaskModel(
                                id: widget.arguments.editType! == 'Edit'
                                    ? widget.arguments.id
                                    : null,
                                category: _addNewCategory
                                    ? _selectedCategory
                                    : _categoryEditingController.text.trim(),
                                date: DateTime.parse(
                                    today.toString().split(" ")[0]),
                                pinned: 1,
                                done: 0,
                                timer: _timer ? 1 : 0,
                                taskName: _taskNameEditingController.text.trim(),
                                description:
                                    _descriptionEditingController.text.trim(),
                                counter: _counter ? 1 : 0,
                                time: _timeOfDay.format(context).toString(),
                                counterVal: _counterValue,
                                nested: _nested ? 1 : 0,
                                nestedVal: 0,
                                specificDate: _specificDate ? 1 : 0,
                                wheel: _wheel ? 1 : 0,
                                notifyMe: notifyMe ? 1 : 0);

                            if (widget.arguments.editType! == 'Edit') {
                              await AddTaskCubit.get(context)
                                  .updateTask(dailyModel, widget.arguments.id!);
                            } else if (widget.arguments.editType! == 'Add') {
                              await AddTaskCubit.get(context)
                                  .addNewTask(dailyModel);
                            }

                            if (widget.arguments.editType! == 'Edit') {
                              // delete before adding
                              await AddTaskCubit.get(context)
                                  .deleteTaskDays(widget.arguments.id!);

                              for (var selectedDay in taskDaysList) {
                                if (selectedDay['checkedDay']) {
                                  // add task day
                                  TaskDaysModel taskDays = TaskDaysModel(
                                    nameOfDay: selectedDay['nameOfDay'],
                                    checkedDay: selectedDay['checkedDay'] ? 1 : 0,
                                    category: _addNewCategory
                                        ? _selectedCategory
                                        : _categoryEditingController.text.trim(),
                                    mainTaskId: widget.arguments.id,
                                    done: 0,
                                    date: '',
                                  );

                                  await AddTaskCubit.get(context)
                                      .addTaskDay(taskDays);
                                }
                              }
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.mainRoute);
                            } else if (widget.arguments.editType! == 'Add') {
                              for (var selectedDay in taskDaysList) {
                                if (selectedDay['checkedDay']) {
                                  // add task day
                                  TaskDaysModel taskDays = TaskDaysModel(
                                    nameOfDay: selectedDay['nameOfDay'],
                                    checkedDay: selectedDay['checkedDay'] ? 1 : 0,
                                    category: _addNewCategory
                                        ? _selectedCategory
                                        : _categoryEditingController.text.trim(),
                                    mainTaskId: DbHelper.insertedNewTaskId,
                                    done: 0,
                                    date: '',
                                  );

                                  await AddTaskCubit.get(context)
                                      .addTaskDay(taskDays);
                                }

                                // if (notifyMe) {
                                //   NotificationDayOfWeekAndTime notificationData =
                                //       NotificationDayOfWeekAndTime(
                                //           dayOfTheWeek: selectedDay['dayNum'],
                                //           timeOfDay: _timeOfDay);
                                //
                                //   await NotificationService
                                //       .showDayOfWeekAndTimeNotification(
                                //           notificationId: 1500,
                                //           notificationSchedule: notificationData,
                                //           title: _taskNameEditingController.text,
                                //           body:
                                //               _descriptionEditingController.text,
                                //           scheduled: true,
                                //           actionButtons: [
                                //         NotificationActionButton(
                                //           key: 'Open_Tasks_App',
                                //           label: AppStrings.openTasksApp,
                                //         )
                                //       ]);
                                // }
                              }
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.mainRoute);
                            }
                          } else {
                            // DateTime now = DateTime.now();
                            // String formattedDate = DateFormat('dd-MM-yyyy').format(now);

                            // add new task
                            DailyTaskModel dailyModel = DailyTaskModel(
                                id: widget.arguments.editType! == 'Edit'
                                    ? widget.arguments.id
                                    : null,
                                category: _addNewCategory
                                    ? _selectedCategory
                                    : _categoryEditingController.text.trim(),
                                date: DateTime.parse(
                                    today.toString().split(" ")[0]),
                                pinned: 0,
                                done: 0,
                                timer: _timer ? 1 : 0,
                                taskName: _taskNameEditingController.text.trim(),
                                description:
                                    _descriptionEditingController.text.trim(),
                                counter: _counter ? 1 : 0,
                                time: _timeOfDay.format(context).toString(),
                                counterVal: _counterValue,
                                nested: _nested ? 1 : 0,
                                nestedVal: 0,
                                specificDate: _specificDate ? 1 : 0,
                                wheel: _wheel ? 1 : 0,
                                notifyMe: notifyMe ? 1 : 0);
                            if (widget.arguments.editType! == 'Edit') {
                              await AddTaskCubit.get(context)
                                  .deleteTaskDays(widget.arguments.id!);

                              await AddTaskCubit.get(context)
                                  .updateTask(dailyModel, widget.arguments.id!);

                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.mainRoute);
                            } else if (widget.arguments.editType! == 'Add') {
                              await AddTaskCubit.get(context)
                                  .addNewTask(dailyModel);

                              // if (notifyMe) {
                              //   NotificationByDate notificationByDateModel =
                              //       NotificationByDate(
                              //           id: null,
                              //           body: _descriptionEditingController.text,
                              //           title: _taskNameEditingController.text,
                              //           taskId: DbHelper.insertedNewTaskId,
                              //           notificationUniqueId: 1500,
                              //           notifyDay: today.day,
                              //           notifyMonth: today.month,
                              //           notifyYear: today.year);
                              //   await AddTaskCubit.get(context)
                              //       .createNotificationByDate(
                              //           notificationByDateModel);
                              // }

                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.mainRoute);
                            }
                          }

                          // --------------------------------------------------------------------------
                        },
                        child: const Icon(Icons.done))
                  ],
                ),
              )
            ],
          ),
          body: bodyContent()),
    );
  }

  Widget bodyContent() {
    return BlocConsumer<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        // loading Tasks Names -----------------------------------------------------
        if (state is LoadingTasksNamesState) {
        } else if (state is ErrorLoadingTasksNamesState) {
        } else if (state is LoadedTasksNamesState) {
          tasksItemsScreen = AddTaskCubit.get(context).tasksNames;

          // loading Categories -----------------------------------------------------
        } else if (state is LoadingCategoriesState) {
        } else if (state is ErrorLoadingCategoriesState) {
        } else if (state is LoadedCategoriesState) {
          categories = AddTaskCubit.get(context).categories;
          // New Task -----------------------------------------------------
        } else if (state is NewTaskSavedState) {
          final snackBar = SnackBar(
            duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
            content: Text(AppStrings.successfullySaved.tr()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is AddTaskErrorState) {
          // Update Task -----------------------------------------------------
        } else if (state is UpdateTaskState) {
          final snackBar = SnackBar(
            duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
            content: Text(AppStrings.successfullyUpdated.tr()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is ErrorUpdateTaskState) {
          // Delete Task -----------------------------------------------------
        } else if (state is DeleteTaskState) {
          final snackBar = SnackBar(
            duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
            content: Text(AppStrings.successfullyDeleted.tr()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is ErrorDeleteTaskState) {
          // Show Task -----------------------------------------------------
        } else if (state is LoadingPrevTask) {
        } else if (state is LoadedPrevTask) {
          oldTask = state.taskData.toMap();

          getData(oldTask);
        } else if (state is ErrorLoadingPrevTask) {
          // Show Task Days -----------------------------------------------------
        } else if (state is LoadingPrevTaskDay) {
        } else if (state is LoadedPrevTaskDay) {
          for (var v in state.taskDayData) {
            fillDays(v.toMap());
          }
        } else if (state is ErrorLoadingPrevTaskDay) {}
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
              AppPadding.p8, AppPadding.p20, AppPadding.p8, AppPadding.p8),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: AppConstants.smallDistance,
                ),
                TextField(
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptionFN);
                    },
                    maxLength: 15,
                    autofocus: true,
                    focusNode: _taskFN,
                    keyboardType: TextInputType.text,
                    controller: _taskNameEditingController,
                    decoration: InputDecoration(
                        hintText: AppStrings.taskName.tr(),
                        hintStyle: TextStyle(
                            fontSize: 15.sp, color: ColorManager.primary),
                        labelText: AppStrings.taskName.tr(),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                            fontSize: 15.sp, color: ColorManager.primary),
                        border: InputBorder.none)),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
                TextField(
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_categoryFN);
                  },
                  controller: _descriptionEditingController,
                  minLines: 3, // Set this
                  maxLines: 6, // and this
                  focusNode: _descriptionFN,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: AppStrings.description.tr(),
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                          fontSize: 15.sp, color: ColorManager.primary),
                      border: InputBorder.none),
                ),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
                _addNewCategory
                    ? Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width -
                                (AppConstants.smallDistance + 50.w + 18),
                            child: DropdownButton2(
                              buttonStyleData: ButtonStyleData(
                                height: 50.h,
                                width: 290.w,
                                padding: const EdgeInsets.only(
                                    left: AppPadding.p14,
                                    right: AppPadding.p14),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(20.w),
                                  border: Border.all(
                                    color: ColorManager.lightPrimary,
                                    width: 1.5.w
                                  ),
                                  color: ColorManager.basic,
                                ),
                                elevation: 0,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 400.h,
                                width: 270.w,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s10),
                                  color: ColorManager.basic,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all<double>(15),
                                  thumbVisibility:
                                      MaterialStateProperty.all<bool>(true),
                                ),
                              ),
                              underline: Container(),
                              items: categories.map((item) {
                                return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style:
                                          TextStyle(fontSize: AppSize.s15.sp),
                                    ));
                              }).toList(),
                              onChanged: (selectedCategory) {
                                setState(() {
                                  _selectedCategory = selectedCategory!;
                                });
                              },
                              value: _selectedCategory,
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Text(
                                    AppStrings.chooseCategory.tr(),
                                    style: TextStyle(
                                        color: ColorManager.primary,
                                        fontSize: AppSize.s15.sp),
                                  ),
                                  SizedBox(
                                    width: AppConstants.smallDistance,
                                  )
                                ],
                              ),
                              style: TextStyle(
                                  color: ColorManager.primary,
                                  fontSize: AppSize.s20.sp),
                            ),
                          ),
                          SizedBox(
                            width: AppConstants.smallDistance,
                          ),
                          Bounceable(
                            duration: Duration(
                                milliseconds:
                                    AppConstants.durationOfBounceable),
                            onTap: () async {
                              await Future.delayed(Duration(
                                  milliseconds: AppConstants.durationOfDelay));
                              bool value = !_addNewCategory;
                              _changeToAddNewCategory(value);
                              _categoryFN.requestFocus();
                            },
                            child: Container(
                              height: 50.h,
                              width: 50.w,
                              padding: const EdgeInsets.all(AppPadding.p08),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: ColorManager.lightPrimary,
                                      width: 1.5.w)),
                              child: SvgPicture.asset(ImageAssets.addNew,
                                  color: ColorManager.darkPrimary, width: 20.w),
                            ),
                          )
                        ],
                      )
                    : Row(children: [
                        Expanded(
                          child: TextField(
                              maxLength: 15,
                              focusNode: _categoryFN,
                              keyboardType: TextInputType.text,
                              controller: _categoryEditingController,
                              decoration: InputDecoration(
                                  hintText: AppStrings.category.tr(),
                                  hintStyle: TextStyle(
                                      fontSize: 15.sp, color: ColorManager.primary),
                                  labelText: AppStrings.category.tr(),
                                  labelStyle: TextStyle(
                                      fontSize: 15.sp, color: ColorManager.primary),
                                  border: InputBorder.none)),
                        ),
                        SizedBox(
                          width: AppConstants.smallDistance,
                        ),
                        Bounceable(
                          duration: Duration(
                              milliseconds: AppConstants.durationOfBounceable),
                          onTap: () async {
                            await Future.delayed(Duration(
                                milliseconds: AppConstants.durationOfDelay));
                            bool value = !_addNewCategory;
                            _changeToAddNewCategory(value);
                          },
                          child: Container(
                            height: 50.h,
                            width: 50.w,
                            margin:
                                const EdgeInsets.only(bottom: AppMargin.m22),
                            padding: const EdgeInsets.all(AppPadding.p08),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: ColorManager.lightPrimary,
                                    width: 1.5.w)),
                            child: SvgPicture.asset(ImageAssets.reload,
                                color: ColorManager.darkPrimary, width: 10.w),
                          ),
                        )
                      ]),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
                SwitchListTile(
                  title: Text(AppStrings.specificDate.tr(),
                      style: TextStyle(
                          color: ColorManager.darkPrimary,
                          fontSize: AppSize.s20.sp)),
                  activeTrackColor: ColorManager.lightPrimary,
                  activeColor: ColorManager.darkPrimary,
                  secondary: const Icon(Icons.date_range_outlined),
                  value: _specificDate,
                  onChanged: (value) {
                    _changeToSpecificDate(value);
                  },
                ),
                _specificDate
                    ? Column(
                        children: [
                          TableCalendar(
                            locale: "en_US",
                            rowHeight: 43.h,
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            selectedDayPredicate: (day) =>
                                isSameDay(day, today),
                            focusedDay: today,
                            calendarStyle: CalendarStyle(
                                selectedDecoration: BoxDecoration(
                                    color: ColorManager.darkPrimary,
                                    shape: BoxShape.circle),
                                todayDecoration: BoxDecoration(
                                    color: ColorManager.lightPrimary,
                                    shape: BoxShape.circle)),
                            firstDay: DateTime.utc(2023, 05, 01),
                            lastDay: DateTime.utc(2030, 3, 14),
                            onDaySelected: _onDaySelected,
                          ),
                          SizedBox(
                            height: AppConstants.heightBetweenElements,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppStrings.date.tr(),
                                  style: TextStyle(
                                      color: ColorManager.lightPrimary,
                                      fontSize: AppSize.s20.sp)),
                              SizedBox(
                                width: AppConstants.widthBetweenElements,
                              ),
                              Text(today.toString().split(" ")[0],
                                  style: TextStyle(
                                      color: ColorManager.darkPrimary,
                                      fontSize: AppSize.s20.sp)),
                            ],
                          ),
                          Divider(
                            color: ColorManager.darkPrimary,
                            thickness: 1,
                          )
                        ],
                      )
                    : Container(),
                SwitchListTile(
                  title: Text(
                    AppStrings.withTimer.tr(),
                    style: TextStyle(
                        color: ColorManager.darkPrimary,
                        fontSize: AppSize.s20.sp),
                  ),
                  secondary: const Icon(Icons.lock_clock),
                  value: _timer,
                  activeTrackColor: ColorManager.lightPrimary,
                  activeColor: ColorManager.darkPrimary,
                  onChanged: (value) {
                    _changeToTimer(value);
                  },
                ),
                _timer
                    ? Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _showTimePicker(context);
                              },
                              child: Text(AppStrings.changeTime.tr(),
                                  style: TextStyle(
                                      color: ColorManager.darkPrimary,
                                      fontSize: AppSize.s20.sp))),
                          SizedBox(
                            height: AppConstants.heightBetweenElements,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppStrings.time.tr(),
                                  style: TextStyle(
                                      color: ColorManager.lightPrimary,
                                      fontSize: AppSize.s20.sp)),
                              SizedBox(
                                width: AppConstants.widthBetweenElements,
                              ),
                              //TimeOfDay.fromDateTime(DateFormat.jm().parse(map["time"]))
                              Text(_timeOfDay.format(context).toString(),
                                  style: TextStyle(
                                      color: ColorManager.darkPrimary,
                                      fontSize: AppSize.s20.sp)),
                            ],
                          ),
                          Divider(
                            color: ColorManager.darkPrimary,
                            thickness: 1,
                          )
                        ],
                      )
                    : Container(),
                SwitchListTile(
                  title: Text(AppStrings.pinnedTask.tr(),
                      style: TextStyle(
                          color: ColorManager.darkPrimary,
                          fontSize: AppSize.s20.sp)),
                  activeTrackColor: ColorManager.lightPrimary,
                  activeColor: ColorManager.darkPrimary,
                  secondary: SvgPicture.asset(ImageAssets.pin_icon,
                      color: ColorManager.grey, width: 25.w),
                  value: _pinned,
                  onChanged: (value) {
                    _changeToPinned(value);
                  },
                ),
                _pinned
                    ? Column(
                        children: [
                          SizedBox(
                            height: AppConstants.heightBetweenElements,
                          ),
                          Container(
                            width: double.infinity,
                            height: 70.h,
                            margin: const EdgeInsets.only(right: AppMargin.m5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (BuildContext context, int index) {
                                return days(index);
                              },
                            ),
                          ),
                          Divider(
                            color: ColorManager.darkPrimary,
                            thickness: 1,
                          )
                        ],
                      )
                    : Container(),
                SwitchListTile(
                  title: Text(AppStrings.withCounter.tr(),
                      style: TextStyle(
                          color: ColorManager.darkPrimary,
                          fontSize: AppSize.s20.sp)),
                  activeTrackColor: ColorManager.lightPrimary,
                  activeColor: ColorManager.darkPrimary,
                  secondary: const Icon(Icons.fingerprint_rounded),
                  value: _counter,
                  onChanged: (value) {
                    _changeToCounter(value);
                  },
                ),
                _counter
                    ? Container(
                        height: 100.h,
                        width: 85.w,
                        padding: const EdgeInsets.fromLTRB(AppPadding.p10,
                            AppPadding.p0, AppPadding.p10, AppPadding.p0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.accent, width: 2.0.w),
                        ),
                        child: ListWheelScrollView.useDelegate(
                            controller: FixedExtentScrollController(
                                initialItem: _counterValue!),
                            onSelectedItemChanged: (value) {
                              setState(() {
                                _counterValue = value + 1;
                              });
                            },
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: 30,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 900,
                                builder: (context, index) {
                                  return myCounter(index + 1);
                                })))
                    : Container(),
                SwitchListTile(
                  title: Text(
                    AppStrings.sebha.tr(),
                    style: TextStyle(
                        color: ColorManager.darkPrimary,
                        fontSize: AppSize.s20.sp),
                  ),
                  secondary: SvgPicture.asset(ImageAssets.scroll,
                      color: ColorManager.grey, width: 25.w),
                  value: _wheel,
                  activeTrackColor: ColorManager.lightPrimary,
                  activeColor: ColorManager.darkPrimary,
                  onChanged: (value) {
                    _changeToWheel(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_alarms_rounded,
                        color: ColorManager.grey,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: CheckboxListTile(
                            title: Text(AppStrings.notifyMe,
                                style: TextStyle(
                                    color: ColorManager.darkPrimary,
                                    fontSize: AppSize.s20.sp)),
                            value: notifyMe,
                            activeColor: ColorManager.primary,
                            onChanged: (value) {
                              if (_timer) {
                                if (!_pinned && !_specificDate) {
                                  final snackBar = SnackBar(
                                    duration: Duration(
                                        milliseconds:
                                            AppConstants.durationOfSnackBar),
                                    content: Text(AppStrings.notifyAlert.tr()),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    notifyMe = !notifyMe;
                                  });
                                }
                              } else {
                                final snackBar = SnackBar(
                                  duration: Duration(
                                      milliseconds:
                                          AppConstants.durationOfSnackBar),
                                  content: Text(AppStrings.timerAlert.tr()),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List fillDays(var daysMap) {
    for (int index = 0; index < taskDaysList.length; index++) {
      if (taskDaysList[index]['nameOfDay'] == daysMap['nameOfDay']) {
        taskDaysList[index]['checkedDay'] = true;
      }
    }
    return taskDaysList;
  }

  void getData(var oldTask) {
    _taskNameEditingController.text = oldTask['taskName'];
    _descriptionEditingController.text = oldTask['description'];
    _selectedCategory = oldTask['category'];

    oldTask['timer'] == 1 ? _timer = true : _timer = false;
    oldTask['timer'] == 1
        ? _timeOfDay = getTime(oldTask['time'])
        : _timeOfDay = TimeOfDay.now();

    oldTask['specificDate'] == 1 ? _specificDate = true : _specificDate = false;
    oldTask['specificDate'] == 1 ? today = getDate(oldTask['date']) : today;

    oldTask['pinned'] == 1 ? _pinned = true : _pinned = false;

    oldTask['counter'] == 1 ? _counter = true : _counter = false;
    oldTask['counter'] == 1
        ? _counterValue = oldTask['counterVal'] - 1
        : _counterValue = 0;

    oldTask['wheel'] == 1 ? _wheel = true : _wheel = false;
    oldTask['notifyMe'] == 1 ? notifyMe = true : notifyMe = false;
  }

  DateTime getDate(String date) {
    return DateTime.parse(date);
  }

  TimeOfDay getTime(String time) {
    return TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
  }

  Widget days(int index) {
    return Column(
      children: [
        Text(
          taskDaysList[index]['nameOfDay'],
          style: TextStyle(
              color: ColorManager.darkPrimary, fontSize: AppSize.s18.sp),
        ),
        Checkbox(
          value: taskDaysList[index]['checkedDay'],
          activeColor: ColorManager.darkPrimary,
          onChanged: (value) {
            setState(() {
              taskDaysList[index]['checkedDay'] = value;
            });
          },
        )
      ],
    );
  }
}
