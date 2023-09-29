import 'package:daily_tasks/task/presentation/ui/homepage/reports/reports_view.dart';
import 'package:flutter/material.dart';
import 'package:daily_tasks/task/presentation/ui/add_task/add_task.dart';
import 'package:daily_tasks/task/presentation/ui/daily_tasks/daily_tasks.dart';
import 'package:daily_tasks/task/presentation/ui/homepage/homepage_view.dart';
import 'package:daily_tasks/task/presentation/ui/homepage/settings/settings_view.dart';
import 'package:daily_tasks/task/presentation/ui/on_boarding/onborading_view.dart';
import 'package:daily_tasks/task/presentation/ui/splash_view/splash_view.dart';

import '../../shared/constant/strings_manager.dart';
import '../ui/tasks_by_category/tasks_by_category.dart';
import 'arguments.dart';


class Routes {
  static const String mainRoute = "/home";
  static const String splashRoute = "/splash";
  static const String onBoarding = "/onBoarding";
  static const String goToTask = "/goToTask";
  static const String tasksByCategory = "/tasksByCategory";
  static const String dailyTasks = "/dailyTasks";
  static const String settings = "/settings";
  static const String reports = "/reports";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const HomePageView());
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoarding());
      case Routes.goToTask:
        return MaterialPageRoute(builder: (_) => AddTask(arguments: settings.arguments as GoToTaskArguments));
      case Routes.tasksByCategory:
        return MaterialPageRoute(builder: (_) => TasksByCategory(arguments: settings.arguments as TasksByCategoryArguments));
      case Routes.dailyTasks:
        return MaterialPageRoute(builder: (_) => DailyTasks(arguments: settings.arguments as DailyTasksArguments));
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case Routes.reports:
        return MaterialPageRoute(builder: (_) => const ReportsView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.noRouteFound),
          ),
          body: const Center(child: Text(AppStrings.noRouteFound)),
        ));
  }
}