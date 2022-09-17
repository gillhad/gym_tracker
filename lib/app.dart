import 'package:flutter/material.dart';
import 'package:gym_tracker/navigation/navigator_router.dart';
import 'package:gym_tracker/navigation/navigator_routes.dart';
import 'package:gym_tracker/screens/main_home.dart';
import 'package:gym_tracker/utils/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.generateRoute,
      theme: CustomTheme.mainTheme,
      initialRoute: NavigationRoutes.home,
    )
    ;
  }
}
