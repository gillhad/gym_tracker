import 'models.dart';

class Mock{
  static  Ejercicios ejercicio1 = Ejercicios(name: "PressBanca", muscularFocus: MuscularFocus.Hombro, reps: _reps, newReps: _reps2);
  static  Ejercicios ejercicio2 = Ejercicios(name: "HipTrust", muscularFocus: MuscularFocus.Hombro, reps: _reps2, newReps: _reps2);
  static  Ejercicios ejercicio3 = Ejercicios(name: "PressMilitar", muscularFocus: MuscularFocus.Hombro, reps: _reps, newReps: _reps2);

  static Reps reps = Reps(numRep: 7,weight: 40.0);
  static Reps reps2 = Reps(numRep: 8,weight: 40.0);
  static List<Reps> _reps= [reps,reps2];
  static List<Reps> _reps2= [reps,reps2];
  static List<Ejercicios> rutinaMock = [ejercicio1, ejercicio2, ejercicio3];
  static List<Ejercicios> listaEx = [ejercicio1, ejercicio2, ejercicio3];
  static Rutina rutina = Rutina(name: "RutinaFalsa",ejercicios: rutinaMock);

}



