import 'package:countup/countup.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:daily_tasks/task/presentation/ui/homepage/home_cubit/home_cubit.dart';
import 'package:daily_tasks/task/presentation/ui/homepage/home_cubit/home_state.dart';
import 'package:daily_tasks/task/shared/constant/assets_manager.dart';
import 'package:daily_tasks/task/shared/constant/padding_margin_values_manager.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../../../shared/component/home_clipper.dart';
import '../../../shared/component/nav_bar.dart';
import '../../../shared/utils/utils.dart';
import '../../di/di.dart';
import '../../router/app_router.dart';
import '../../router/arguments.dart';
import '../category/category.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var yearOfDate = DateTime.now().year;

  Set<String> dailyCategories = {};

  List<int> itemsCount = [];
  List<int> pinnedItemsCount = [];
  List<double> categoryPercent = [];

  double totalPercent = 0.0;

  DateTime today = DateTime.now();
  String searchByToday = '';
  String searchByDayOfWeek = '';

  @override
  void initState() {
    String originalDate =
        DateTime.parse(today.toString().split(" ")[0]).toString();
    searchByToday = originalDate.replaceFirst(RegExp(' '), 'T');
    String dayOfToday = DateFormat('EEEE').format(today);
    searchByDayOfWeek = dayOfToday.substring(0, 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: SafeArea(
          child: Scaffold(
        key: scaffoldKey,
        drawer: const NavBar(),
        body: bodyContent(size),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).pushReplacementNamed(Routes.goToTask,
                arguments: GoToTaskArguments(editType: 'Add', id: 0));
          },
          backgroundColor: ColorManager.darkPrimary,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      )),
    );
  }

  Widget bodyContent(Size size) {
    return BlocProvider(
  create: (context) => sl<HomeCubit>()
    ..updateDailyDateOfTaskDay(
        searchByDayOfWeek, searchByToday)
    ..updateDoneForWeekOfTaskDay(searchByDayOfWeek, searchByToday)
    ..loadTasksCategories(searchByToday, searchByDayOfWeek)
    ..loadTotalTasksPercent(searchByToday, searchByDayOfWeek),
  child: BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LoadingCategoriesState) {
        } else if (state is ErrorLoadingCategoriesState) {
        } else if (state is LoadedCategoriesState) {
          dailyCategories = HomeCubit.get(context).categories;
          itemsCount = HomeCubit.get(context).itemsCount;
          pinnedItemsCount = HomeCubit.get(context).pinnedItemsCount;
          categoryPercent = HomeCubit.get(context).categoryPercent;
        } else if (state is LoadHomePercentState) {
          totalPercent = HomeCubit.get(context).totalPercent;
        } else if (state is ErrorLoadingHomePercentState) {}
      },
      builder: (context, state) {
        return Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: HomeClipper(),
                  child: SizedBox(
                      height: 295.h,
                      width: double.infinity,
                      child: Container(
                        color: ColorManager.accent,
                      )),
                ),
                ClipPath(
                    clipper: HomeClipper(),
                    child: SizedBox(
                      height: 280.h,
                      width: double.infinity,
                      child: Container(
                        color: ColorManager.primary,
                      ),
                    )),
                Positioned(
                    top: 110.h,
                    left: 20.w,
                    child: CircularPercentIndicator(
                      footer: Text(
                        yearOfDate.toString(),
                        style: TextStyle(
                            color: ColorManager.darkPrimary,
                            fontSize: AppSize.s20.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      radius: 80.0.h,
                      lineWidth: 10.0.w,
                      percent: totalPercent == 0 ? 0.0 : totalPercent / 100,
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Countup(
                            begin: 0,
                            end: totalPercent == 0 ? 0.0 : totalPercent,
                            duration: Duration(milliseconds: AppConstants.countUp),
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
                      // progressColor: ColorManager.darkPrimary,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: AppConstants.circularPercentIndicator,
                      curve: Curves.easeInOut,
                      linearGradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorManager.darkPrimary,
                            ColorManager.primary,
                            ColorManager.lightPrimary,
                          ]),
                    )),
                Positioned(
                    top: 15.h,
                    left: 35.w,
                    child: Bounceable(
                        duration: const Duration(milliseconds: 100),
                        onTap: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 700));
                          scaffoldKey.currentState?.openDrawer();
                        },
                        child: SvgPicture.asset(ImageAssets.menuImage,
                            color: ColorManager.basic, width: 50.w))),
                Positioned(
                    top: 15.h,
                    right: 15.w,
                    child: Column(
                      children: [
                        Bounceable(
                          duration: const Duration(milliseconds: 100),
                          onTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 700));
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child:
                              Image.asset(ImageAssets.taskslogo, width: 110.w),
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: AppConstants.heightBetweenElements,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: double.infinity,
                    height: 1.h,
                    margin: const EdgeInsets.only(bottom: AppMargin.m5),
                    child: Container(
                      color: ColorManager.darkPrimary,
                    )),
                DatePicker(
                  today,
                  width: 60.w,
                  height: 80.h,
                  initialSelectedDate: today,
                  selectionColor: ColorManager.darkPrimary,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    setState(() {
                      yearOfDate = date.year;

                      DateTime otherDate = date;
                      String searchByDay = '';

                      String originalDate =
                          DateTime.parse(otherDate.toString().split(" ")[0])
                              .toString();
                      searchByDay = originalDate.replaceFirst(RegExp(' '), 'T');

                      searchByToday = searchByDay;

                      String dayOfToday = DateFormat('EEEE').format(otherDate);
                      String subOfDayOfToday = dayOfToday.substring(0, 3);

                      searchByDayOfWeek = subOfDayOfToday;

                      HomeCubit.get(context)
                          .loadTasksCategories(searchByDay, subOfDayOfToday);

                      HomeCubit.get(context)
                          .loadTotalTasksPercent(searchByDay, subOfDayOfToday);
                    });
                  },
                ),
                Container(
                    width: double.infinity,
                    height: 1.h,
                    margin: const EdgeInsets.only(top: AppMargin.m5),
                    child: Container(
                      color: ColorManager.darkPrimary,
                    )),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
              ],
            ),
            Expanded(
                child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 10 / 6,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: List.generate(dailyCategories.length, (index) {
                      return Category(
                        tasksDate: searchByToday,
                        itemsCount: itemsCount[index] + pinnedItemsCount[index],
                        name: dailyCategories.elementAt(index),
                        percent: categoryPercent[index],
                        tasksDay: searchByDayOfWeek,
                      );
                    })))
          ],
        );
      },
    ),
);
  }
}
