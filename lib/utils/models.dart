import 'dart:ui';

class Rutina{
  String name;
  Color? color;
  List<Ejercicios>? ejercicios;

  Rutina({required this.name,this.ejercicios, this.color});

}

class Ejercicios{
  String name;
  MuscularFocus muscularFocus;
  List<Reps>? reps;
  List<Reps>? newReps;
  Image? image;


  Ejercicios({required this.name, required this.muscularFocus, this.reps, this.newReps});
}

class Reps{
  int numRep;
  double weight;

  Reps({required this.numRep,required this.weight});

  setWeight(double add){
    this.weight += add;
  }
}

enum MuscularFocus{
  Hombro,
  Espalda,
  Pecho,
  Biceps,
  Triceps,
  Pierna,
  Gluteo
}

enum DayOfWeek{
  Lunes,
  Martes,
  Miercoles,
  Jueves,
  Viernes,
  Sabado,
  Domingo,
  Todos,

}