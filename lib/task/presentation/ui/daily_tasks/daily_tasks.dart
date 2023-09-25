import 'package:countup/countup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:daily_tasks/task/domain/entities/daily_task_model.dart';
import 'package:daily_tasks/task/presentation/ui/daily_tasks/widgets.dart';

import '../../../domain/entities/task_days_model.dart';
import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../../di/di.dart';
import '../../router/arguments.dart';
import 'daily_tasks_cubit/daily_tasks_cubit.dart';
import 'daily_tasks_cubit/daily_tasks_state.dart';

class DailyTasks extends StatefulWidget {
  final DailyTasksArguments arguments;

  const DailyTasks({super.key, required this.arguments});

  @override
  State<DailyTasks> createState() => _DailyTasksState();
}

class _DailyTasksState extends State<DailyTasks> {

  DateTime today = DateTime.now();

  double checkDouble(dynamic value) {
    return 1 / value;
  }

  int? _done;

  void _toggleDone(value) {
    if (value == 1) {
      _done = 0;
    } else {
      _done = 1;
    }
  }

  Future<void> executeToggleDone(BuildContext context) async {
    _toggleDone(_done);

    String dayOfToday = DateFormat('EEEE').format(today);
    String dayOfWeekOfToday = dayOfToday.substring(0, 3);

    String originalDate =
    DateTime.parse(today.toString().split(" ")[0]).toString();
    String searchByToday = originalDate.replaceFirst(RegExp(' '), 'T');

    await DailyTasksCubit.get(context).toggleDone(
        MakeTaskDoneModel(id: widget.arguments.id, done: _done),
        widget.arguments.id!);

    if (widget.arguments.pinned == 1) {

      int? idOfTaskDay;
      await DailyTasksCubit.get(context)
          .getIdOfTaskDay(dayOfWeekOfToday, widget.arguments.id!)
          .then((value) {
        idOfTaskDay = value.id;
      });

      DailyTasksCubit.get(context).toggleDoneByDay(
          MakeTaskDoneByDayModel(id: idOfTaskDay, done: _done),
          dayOfWeekOfToday,
          widget.arguments.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DailyTasksCubit>(),
      child: BlocConsumer<DailyTasksCubit, DailyTasksState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p8, horizontal: AppPadding.p5),
            child: Column(
              children: [
                Container(
                    // height: 75,
                    padding: const EdgeInsets.fromLTRB(AppPadding.p0, AppPadding.p8, AppPadding.p0, AppPadding.p10),
                    decoration: (BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(width: 2.w, color: ColorManager.accent),
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white,
                              ColorManager.darkPrimary,
                            ]))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(left: AppPadding.p20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          widget.arguments.taskName!,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: AppSize.s18.sp),
                                        ),
                                        widget.arguments.date
                                            .toString()
                                            .split(" ")[0]
                                            .substring(0, 10) ==
                                            today
                                                .toString()
                                                .split(" ")[0]
                                                .substring(0, 10) ?
                                        widget.arguments.done == 1
                                            ? Icon(
                                                Icons.done,
                                                color: ColorManager.blueColor,
                                              )
                                            : Container() : Container()
                                      ],
                                    ),
                                    widget.arguments.counter == 1
                                        ? Bounceable(
                                            duration: Duration(
                                                milliseconds: AppConstants.durationOfDelayForCounter),
                                            onTap: () async {
                                              await Future.delayed(
                                                  Duration(
                                                      milliseconds: AppConstants.durationOfDelayForCounter));
                                              setState(() {
                                                widget.arguments.counterVal = widget.arguments.counterVal! - 1;
                                                if (widget.arguments.counterVal == 0){
                                                  // executeToggleDone(context);
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 70.w,
                                              height: 40.h,
                                              decoration: (BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 2.w,
                                                      color:
                                                          ColorManager.accent),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Colors.white,
                                                        ColorManager
                                                            .lightPrimary,
                                                      ]))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Icon(Icons
                                                      .fingerprint_rounded),
                                                  Text(
                                                    widget.arguments.counterVal
                                                        .toString(),
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: AppSize.s20.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    widget.arguments.wheel == 1
                                        ? Container(
                                            height: 100.h,
                                            width: 100.w,
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerRight,
                                                  end: Alignment.centerLeft,
                                                  colors: [
                                                    ColorManager.lightPrimary,
                                                    Colors.white,
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ColorManager.accent,
                                                  width: 2.0.w),
                                            ),
                                            child:
                                                ListWheelScrollView.useDelegate(
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      setState(() {});
                                                    },
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    itemExtent: 40,
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                            childCount: 999,
                                                            builder: (context,
                                                                index) {
                                                              return myCounter(
                                                                  index + 1);
                                                            })))
                                        : Container(),
                                    Row(
                                      children: [
                                        Text(
                                          widget.arguments.time!,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: AppSize.s15.sp),
                                        ),
                                        SizedBox(
                                          width: AppConstants.smallDistance,
                                        ),
                                        widget.arguments.timer == 1
                                            ? const Icon(
                                                Icons.lock_clock,
                                                size: 15)
                                            : Container()
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: AppConstants.smallDistance,
                                ),
                                ReadMoreText(
                                  widget.arguments.description!,
                                  style: TextStyle(
                                      fontSize: AppSize.s15.sp,
                                      color: ColorManager.darkBasicOverlay),
                                  trimLines: 1,
                                  colorClickableText: ColorManager.blueColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: AppStrings.readMore.tr(),
                                  trimExpandedText: AppStrings.readLess.tr(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: widget.arguments.nested == 1 ? 2 : 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                  widget.arguments.pinned == 1
                                      ? ImageAssets.pin_icon
                                      : ImageAssets.unPin_icon,
                                  color: ColorManager.basic,
                                  width: 25.w),
                              widget.arguments.nested == 1
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: AppConstants.smallDistance,
                                        ),
                                        CircularPercentIndicator(
                                          radius: 25.0.h,
                                          lineWidth: 5.0.w,
                                          percent: widget.arguments.nestedVal ==
                                                  0
                                              ? 0.0
                                              : widget.arguments.nestedVal! /
                                                  100,
                                          center: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Countup(
                                                begin: 0,
                                                end: widget.arguments
                                                            .nestedVal ==
                                                        0
                                                    ? 0.0
                                                    : checkDouble(widget
                                                        .arguments.nestedVal),
                                                duration: Duration(milliseconds: AppConstants.countUp),
                                                style: TextStyle(
                                                  fontSize: AppSize.s10.sp,
                                                ),
                                              ),
                                              Text(
                                                '%',
                                                style:
                                                    TextStyle(fontSize: AppSize.s10.sp),
                                              )
                                            ],
                                          ),
                                          backgroundColor: ColorManager.accent,
                                          progressColor: ColorManager.basic,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          animation: true,
                                          animationDuration: AppConstants.circularPercentIndicator,
                                          curve: Curves.easeInOut,
                                        )
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        widget.arguments.nested == 1
                            ? Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Bounceable(
                                        duration:
                                            Duration(milliseconds: AppConstants.durationOfBounceable),
                                        onTap: () async {
                                          await Future.delayed(const Duration(
                                              milliseconds: 200));
                                        },
                                        child:
                                            // Icon(
                                            //     Icons.arrow_circle_right_outlined,
                                            //     color: ColorManager.basic)

                                            SvgPicture.asset(ImageAssets.folder,
                                                color: ColorManager.basic,
                                                width: 25.w)),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: AppPadding.p15),
                                child: Container(),
                              )
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }


}
