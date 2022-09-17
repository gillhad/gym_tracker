import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/arguments/arguments_class.dart';
import 'package:gym_tracker/arguments/exe_detail_arguments.dart';
import 'package:gym_tracker/navigation/navigator_routes.dart';

import '../utils/mock_data.dart';
import '../utils/models.dart';

class Routines extends StatefulWidget {
  Routines({Key? key, required this.rutina }) : super(key: key);
  late final Rutina rutina;

  @override
  State<Routines> createState() => _RoutinesState();
}

class _RoutinesState extends State<Routines> {


  @override
  void initState() {

    super.initState();
  }

  callbackFunction(Rutina rutina){
    widget.rutina = rutina;
    setState(() {
  print("funsiona el callback");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _body(),
            _addEx(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(){
    return AppBar(
      title: Text(widget.rutina.name),
      backgroundColor: Color(0xFF5A5959),

    );
  }
  
  Widget _body(){
    return Padding(padding: EdgeInsets.all(5),
    child: Column(
        children: [
          widget.rutina.ejercicios != null ? _exerList() :
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(child: Text("Añade un ejercicio",style: TextStyle(color: Colors.white),),),)
        ],
    ),
    );
  }

  Widget _exerList(){
    return Expanded(child:
    ReorderableListView.builder(
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return Material(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
            ),
            child: child,
          ),
        );
      },
        itemCount: widget.rutina.ejercicios!.length,
        itemBuilder: (BuildContext, index){
          return _exer(index);
        },
    onReorder: (int oldIndex, int newIndex) {
    setState(() {
    if (oldIndex < newIndex) {
    newIndex -= 1;
    }
    final Ejercicios item = widget.rutina.ejercicios!.removeAt(oldIndex);
    widget.rutina.ejercicios!.insert(newIndex, item);
    });}));
  }

  Widget _exer(int index){
    return Padding(
        key: Key(index.toString()),
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          _openExeDetail(widget.rutina.ejercicios![index]);
        },
        child: Container(
          height: 36,
          child: Row(
            children: [
              Icon(Icons.drag_indicator, color: Colors.grey,),
              Container(
                width: 32,
                height: 32,
                decoration:  BoxDecoration(color: Colors.green, shape: BoxShape.circle)
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.arrow_forward_ios_sharp, color: Colors.yellow,size: 12,),
                    Text(widget.rutina.ejercicios![index].name, style: TextStyle(color: Colors.white),)
                  ],),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text("Series: ${widget.rutina.ejercicios![index].reps?.length}", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 8),
                      Text("Peso: ${widget.rutina.ejercicios![index].reps?[0].weight.toString()}", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 8),
                      Text("Reps: ${widget.rutina.ejercicios![index].reps?[0].numRep}", style: TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addEx(){
    return Positioned(
        bottom: 16,
        right: 16,
        child: FloatingActionButton(
          onPressed: _navigateToAddExe,
          // backgroundColor: Color(0xBC628AEA),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Icon(Icons.add, color: Colors.black,),));
  }

  _navigateToAddExe(){
    Navigator.pushNamed(context, NavigationRoutes.ejercicios,arguments: AddExeArguments(rutina: widget.rutina));
  }

  _openExeDetail(Ejercicios selectedEx){
    Navigator.pushNamed(context, NavigationRoutes.ejeDetalle, arguments: ExeDetailArgument(rutina: widget.rutina, ejercicio: selectedEx));
  }
}
