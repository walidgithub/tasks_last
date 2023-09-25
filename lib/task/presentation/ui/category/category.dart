import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:daily_tasks/task/presentation/ui/homepage/home_cubit/home_cubit.dart';
import 'package:daily_tasks/task/presentation/ui/homepage/home_cubit/home_state.dart';
import 'package:daily_tasks/task/shared/constant/padding_margin_values_manager.dart';

import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../../router/app_router.dart';
import '../../router/arguments.dart';

class Category extends StatefulWidget {
  final String name;
  final double percent;
  final int itemsCount;
  final String tasksDate;
  final String tasksDay;

  const Category(
      {super.key,
      required this.name,
      required this.percent,
      required this.itemsCount,
      required this.tasksDate,
      required this.tasksDay,
      });

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Bounceable(
          duration: const Duration(milliseconds: 100),
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 150));
            // category info
            Navigator.of(context).pushReplacementNamed(Routes.tasksByCategory,
                arguments: TasksByCategoryArguments(
                    category: widget.name,
                    countOfItems: widget.itemsCount,
                    tasksDate: widget.tasksDate,
                    tasksDay: widget.tasksDay
                ));

            // load tasks by category and date

          },
          child: Container(
              margin: const EdgeInsets.fromLTRB(AppPadding.p5, AppPadding.p0, AppPadding.p5, AppPadding.p0),
              padding: const EdgeInsets.fromLTRB(AppPadding.p8, AppPadding.p0, AppPadding.p8, AppPadding.p0),
              // width: 150,
              // height: 50,
              decoration: BoxDecoration(
                  color: ColorManager.basic,
                  border: Border.all(
                    color: ColorManager.accent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text((widget.name),
                        style: TextStyle(
                            fontSize: AppSize.s20.sp, color: ColorManager.darkbasic)),
                    SizedBox(
                      width: AppConstants.smallDistance,
                    ),
                    CircularPercentIndicator(
                      radius: 25.0.h,
                      lineWidth: 5.0.w,
                      percent: widget.percent / 100,
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Countup(
                            begin: 0,
                            end: widget.percent,
                            duration: Duration(milliseconds: AppConstants.countUp),
                            style: TextStyle(
                              fontSize: AppSize.s10.sp,
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(fontSize: AppSize.s10.sp),
                          )
                        ],
                      ),
                      backgroundColor: ColorManager.accent,
                      progressColor: ColorManager.primary,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: AppConstants.circularPercentIndicator,
                      curve: Curves.easeInOut,
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
