import '../utils/models.dart';

class ExeDetailArgument{
  late Rutina rutina;
  late Ejercicios? ejercicio;
  late Function? callbackFunction;

  ExeDetailArgument({required this.rutina,this.ejercicio, this.callbackFunction});

}