import 'package:countup/countup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../domain/entities/daily_task_model.dart';
import '../../../../domain/entities/report_model.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../di/di.dart';
import '../../../router/app_router.dart';
import '../home_cubit/home_cubit.dart';
import '../home_cubit/home_state.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({Key? key}) : super(key: key);

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final scrollController = ScrollController();

  List<ReportModel> listForReport = [];

  bool fromDate = false;
  bool toDate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _changeFromDate(value) {
    setState(() {
      fromDate = value;
      if (fromDate) {
        scrollController.animateTo(
            scrollController.position.maxScrollExtent + 120,
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            curve: Curves.linear);
      }
    });
  }

  void _changeToDate(value) {
    setState(() {
      toDate = value;
      if (toDate) {
        scrollController.animateTo(
            scrollController.position.maxScrollExtent + 120,
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            curve: Curves.linear);
      }
    });
  }

  DateTime fromDateVal = DateTime.now();
  DateTime toDateVal = DateTime.now();

  void _onFromDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      fromDateVal = day;
    });
  }

  void _onToDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      toDateVal = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.darkPrimary,
        elevation: 0,
        leading: Padding(
            padding:
                const EdgeInsets.fromLTRB(AppPadding.p8, AppPadding.p8, 0, 0),
            child: Bounceable(
              duration:
                  Duration(milliseconds: AppConstants.durationOfBounceable),
              onTap: () async {
                await Future.delayed(
                    Duration(milliseconds: AppConstants.durationOfDelay));
                Navigator.of(context).pop();
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
                },
                child: const Icon(Icons.keyboard_return),
              ),
            )),
        title: Text(
          AppStrings.allreports.tr(),
          style: TextStyle(fontSize: AppSize.s25.sp),
        ),
      ),
      body: bodyContent(context),
    ));
  }

  Widget bodyContent(BuildContext context) {
    return SingleChildScrollView(
        controller: scrollController,
        child: BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is LoadReportsState) {
                  listForReport = HomeCubit.get(context).listForReport;
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                            '(From)  ${fromDateVal.toString().split(" ")[0]}',
                            style: TextStyle(
                                color: ColorManager.darkPrimary,
                                fontSize: AppSize.s20.sp)),
                        activeTrackColor: ColorManager.lightPrimary,
                        activeColor: ColorManager.darkPrimary,
                        secondary: const Icon(Icons.date_range_outlined),
                        value: fromDate,
                        onChanged: (value) {
                          _changeFromDate(value);
                        },
                      ),
                      fromDate
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
                                      isSameDay(day, fromDateVal),
                                  focusedDay: fromDateVal,
                                  calendarStyle: CalendarStyle(
                                      selectedDecoration: BoxDecoration(
                                          color: ColorManager.darkPrimary,
                                          shape: BoxShape.circle),
                                      todayDecoration: BoxDecoration(
                                          color: ColorManager.lightPrimary,
                                          shape: BoxShape.circle)),
                                  firstDay: DateTime.utc(2023, 05, 01),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  onDaySelected: _onFromDaySelected,
                                ),
                                SizedBox(
                                  height: AppConstants.heightBetweenElements,
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
                            '(To)       ${toDateVal.toString().split(" ")[0]}',
                            style: TextStyle(
                                color: ColorManager.darkPrimary,
                                fontSize: AppSize.s20.sp)),
                        activeTrackColor: ColorManager.lightPrimary,
                        activeColor: ColorManager.darkPrimary,
                        secondary: const Icon(Icons.date_range_outlined),
                        value: toDate,
                        onChanged: (value) {
                          _changeToDate(value);
                        },
                      ),
                      toDate
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
                                      isSameDay(day, toDateVal),
                                  focusedDay: toDateVal,
                                  calendarStyle: CalendarStyle(
                                      selectedDecoration: BoxDecoration(
                                          color: ColorManager.darkPrimary,
                                          shape: BoxShape.circle),
                                      todayDecoration: BoxDecoration(
                                          color: ColorManager.lightPrimary,
                                          shape: BoxShape.circle)),
                                  firstDay: DateTime.utc(2023, 05, 01),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  onDaySelected: _onToDaySelected,
                                ),
                                SizedBox(
                                  height: AppConstants.heightBetweenElements,
                                ),
                                Divider(
                                  color: ColorManager.darkPrimary,
                                  thickness: 1,
                                )
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      Bounceable(
                        duration: Duration(
                            milliseconds: AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds: AppConstants.durationOfDelay));
                            await HomeCubit.get(context).loadDailyTasksByDate(fromDateVal.toString().split(" ")[0], toDateVal.toString().split(" ")[0]);
                        },
                        child: Container(
                          height: 40.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                              color: ColorManager.primary,
                              border: Border.all(
                                  width: 1.w, color: ColorManager.darkPrimary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w))),
                          child: Center(
                              child: Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 20.sp, color: ColorManager.basic),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      ListView.separated(
                        itemCount: listForReport.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Bounceable(
                            duration: Duration(
                                milliseconds:
                                    AppConstants.durationOfBounceable),
                            onTap: () async {
                              await Future.delayed(Duration(
                                  milliseconds: AppConstants.durationOfDelay));
                            },
                            child: CircularPercentIndicator(
                              footer: Text(
                                listForReport[index].date.toString(),
                                style: TextStyle(
                                    color: ColorManager.darkPrimary,
                                    fontSize: AppSize.s20.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              radius: 80.0.h,
                              lineWidth: 10.0.w,
                              percent: 1.0,
                              center: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Countup(
                                    begin: 0,
                                    end: 20,
                                    duration: Duration(
                                        milliseconds: AppConstants.countUp),
                                    style: TextStyle(
                                      fontSize: AppSize.s50.sp,
                                    ),
                                  ),
                                  Text(
                                    '%',
                                    style: TextStyle(fontSize: AppSize.s50.sp),
                                  )
                                ],
                              ),
                              backgroundColor: ColorManager.accent,
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                              animationDuration:
                                  AppConstants.circularPercentIndicator,
                              curve: Curves.easeInOut,
                              linearGradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorManager.darkPrimary,
                                    ColorManager.primary,
                                    ColorManager.lightPrimary,
                                  ]),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: ColorManager.darkPrimary,
                            thickness: 1,
                          );
                        },
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
