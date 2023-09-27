import 'package:daily_tasks/task/shared/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daily_tasks/task/presentation/di/di.dart';
import 'package:daily_tasks/task/presentation/router/app_router.dart';
import 'package:daily_tasks/task/presentation/ui/add_task/add_task_cubit/add_task_cubit.dart';
import 'package:daily_tasks/task/shared/constant/language_manager.dart';
import 'package:daily_tasks/task/shared/preferences/app_pref.dart';
import 'package:daily_tasks/task/shared/style/theme_constants.dart';
import 'package:daily_tasks/task/shared/style/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator().init();
  await EasyLocalization.ensureInitialized();

  await NotificationService.initializeNotification();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(EasyLocalization(
      supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      child: Phoenix(child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = sl<AppPreferences>();
  final ThemeManager _themeManager = sl<ThemeManager>();

  DateTime today = DateTime.now();
  String searchByToday = '';
  String subOfDayOfToday = '';

  @override
  void initState() {
    _themeManager.addListener(themeListener);

    String dayOfToday = DateFormat('EEEE').format(today);
    subOfDayOfToday = dayOfToday.substring(0, 3);

    _themeManager.addListener(themeListener);

    String originalDate =
        DateTime.parse(today.toString().split(" ")[0]).toString();
    searchByToday = originalDate.replaceFirst(RegExp(' '), 'T');

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    _appPreferences
        .isThemeDark()
        .then((value) => {_themeManager.toggleTheme(value)});
    super.didChangeDependencies();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) => sl<AddTaskCubit>()
                      ..loadTasksNames()
                      ..loadCategories()),
              ],
              child: MaterialApp(
                navigatorKey: MyApp.navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                title: 'Tasks',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: _themeManager.themeMode,
                onGenerateRoute: RouteGenerator.getRoute,
                initialRoute: Routes.mainRoute,
              ));
        });
  }
}

