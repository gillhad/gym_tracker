import 'package:flutter/material.dart';
import 'package:gym_tracker/app.dart';
import 'package:gym_tracker/arguments/arguments_class.dart';
import 'package:gym_tracker/arguments/exe_detail_arguments.dart';
import 'package:gym_tracker/navigation/navigator_routes.dart';
import 'package:gym_tracker/screens/addExe.dart';
import 'package:gym_tracker/screens/exercize_detail.dart';
import 'package:gym_tracker/screens/history.dart';
import 'package:gym_tracker/screens/routine.dart';

import '../screens/main_home.dart';

class AppRoutes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoutes.home:
        return MaterialPageRoute(builder: (context) {
          print("carga la pagina inicial");
          return MainHome();
        });
      case NavigationRoutes.routines:
        final arguments =  settings.arguments as RoutineDisplayArguments;
        return MaterialPageRoute(builder: (context){
          return Routines(
            rutina: arguments.rutina,
          );
        });
      case NavigationRoutes.ejercicios:
        final arguments =  settings.arguments as AddExeArguments;
        return MaterialPageRoute(builder: (context){
          return AddExe(
            rutina: arguments.rutina,
            callbackFunction: arguments.callback,
          );
        });
      case NavigationRoutes.ejeDetalle:
        final arguments = settings.arguments as ExeDetailArgument;
        return MaterialPageRoute(builder: (context){
          return ExeDetail(
              rutina: arguments.rutina,
              selectedEx: arguments.ejercicio,
          );
        });
      default:
        return MaterialPageRoute(builder: (context){
          print("carga default");
          return MainHome();
        });
    }
  }
}