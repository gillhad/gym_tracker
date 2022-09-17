import 'package:flutter/material.dart';
import 'package:gym_tracker/arguments/arguments_class.dart';
import 'package:gym_tracker/navigation/navigator_routes.dart';
import 'package:gym_tracker/utils/mock_data.dart';
import 'package:gym_tracker/utils/models.dart';
import 'package:gym_tracker/widgets/basic_button_round.dart';

class AddExe extends StatefulWidget {
  AddExe({Key? key,required this.rutina,required this.callbackFunction}) : super(key: key);
  Rutina rutina;
  Function? callbackFunction;

  @override
  State<AddExe> createState() => _AddExeState();
}

class _AddExeState extends State<AddExe> {
  List<Ejercicios>? _ejerciciosLista;
  int _currentSeries = 1;


  late Function _callback;
  List<TextEditingController> _controller = <TextEditingController>[];
  List<TextEditingController> _repController = <TextEditingController>[];
  TextEditingController _controller0 = TextEditingController();
  TextEditingController _repController0 = TextEditingController();
  bool _repSelect = false;
  var constWeight = [8.0,10.0,15.0,20.0];
  var constReps = [8.0,10.0,15.0,20.0];


  @override
  void initState() {
    _ejerciciosLista = Mock.listaEx;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      appBar: AppBar(
        title: Text("Ejercicios"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, NavigationRoutes.routines, (route) => true,arguments: RoutineDisplayArguments(rutina: widget.rutina,callback: widget.callbackFunction));
          },
        ),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _exList(),

    ]
        ),
      ],
    );
  }

  Widget _exList(){
    return Expanded(
      child: ListView.builder(
          itemCount: _ejerciciosLista?.length,
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: (){_addExe(_ejerciciosLista![index]);},
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(child: Text(_ejerciciosLista![index].name, style: TextStyle(color: Colors.white),))
                  ],
                ),
              ),
            );
          }),
    );
  }


  Future _addExe(Ejercicios _ejercicios) async {
    Ejercicios _currentAdd = Ejercicios(
        name: _ejercicios.name, muscularFocus: _ejercicios.muscularFocus);
    await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _controller0.text = "0";
          _controller.add(_controller0);
          _repController0.text = "8";
          _repController.add(_repController0);
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                height: 400,
                width: 300,
                color: Color(0xFF4C4C4C),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(child: Text(_ejercicios.name, style: TextStyle(color: Colors.white),)),
                        SizedBox(height: 15,),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 30,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("series", style: TextStyle(color: Colors.white)),
                              SizedBox(width: 10,),
                              Text(_currentSeries.toString(), style: TextStyle(color: Colors.white,fontSize: 18)),
                              SizedBox(width: 10,),
                              GestureDetector(onTap: (){_addSerie(setState);},
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(shape: BoxShape.circle,
                                      color: Color(0xFF242424) ),
                                    child: Icon(Icons.add,color: Colors.white, size: 14,)),),
                              SizedBox(width: 10,),
                              GestureDetector(onTap: (){_removeSerie(setState);},
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(shape: BoxShape.circle,
                                      color: Color(0xFF242424) ),
                                    child: Icon(Icons.remove,color: Colors.white, size: 14,)),),

                              ],
                          ),),
                        SizedBox(height: 15,),
                        _addExeMenu(),
                        Expanded(
                          child: ListView.builder(
                              itemCount: _controller.length,
                              itemBuilder: (BuildContext, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 20,
                                          child: Text("${index+1}.")),
                                      _repSelect ?
                                      Container(
                                        child: GestureDetector(
                                            onTap: (){
                                              setState((){
                                                _repSelect = false;
                                              });
                                            },
                                            child: Container(
                                                width: 30,
                                                alignment: Alignment.center,
                                                child: Text("${_controller[index].text}", style: TextStyle(color: Colors.white),))),
                                      )
                                          : Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 60,
                                        child: TextFormField(
                                          controller: _controller[index],
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              suffixText: "Kg",
                                              suffixStyle: TextStyle(color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      _repSelect
                                          ? Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 60,
                                        child: TextFormField(
                                          controller: _repController[index],
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              suffixText: "x",
                                              suffixStyle: TextStyle(color: Colors.white)
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                          onTap: (){
                                            setState((){
                                              _repSelect = true;
                                            });
                                          },
                                          child: Container(
                                              width: 30,
                                              alignment: Alignment.center,
                                              child: Text("${_repController[index].text}", style: TextStyle(color: Colors.white)))),
                                SizedBox(width: 20),
                                      _repSelect ? BasicIconButton(Icons.remove,(){_removeRep(index);}) : BasicIconButton(Icons.remove,(){_removeWeight(index);}) ,
                                      _repSelect ? BasicIconButton(Icons.add,(){_addRep(index);}) : BasicIconButton(Icons.add,(){_addWeight(index);}) ,

                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: 10,
                        right: 70,
                        child: TextButton(onPressed: () {
                          _addNewEx(_currentAdd, _currentSeries, _repController, _controller); },
                        child: Text("Ok", style: TextStyle(color: Colors.white),),)),
                    Positioned(
                        bottom: 10,
                        right: 20,
                        child: TextButton(onPressed: () {
                          _cancelNewEx();  },
                        child: Text("Cancel", style: TextStyle(color: Colors.white)),)),

                  ],
                ),
              ),
            );
          });
        });
  }

  Widget _addExeMenu(){
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            _repSelect ?
            Container(
                width: 50,
                child: Text("Rep",style: TextStyle(color: Color(0xFF6899C4)),))
                : Container(
                width: 50,
                child: Text("Peso",style: TextStyle(color: Color(0xFF6899C4)),)),
            IconButton(
                onPressed: (){_repSelect ? _allRepsMenu()  : _allWeightsMenu();},
                icon: Icon(Icons.done_all))
          ],
        )
    );
  }

  _addSerie(StateSetter setState){

    setState((){
      _currentSeries += 1;
      _controller.add(TextEditingController());
      _controller.last.text = "0";
      _repController.add(TextEditingController());
      _repController.last.text = "8";
    });
  }
  _removeSerie(StateSetter setState){
    setState((){
      if(_currentSeries>=2){
        _controller.removeLast();
        _repController.removeLast();
        _currentSeries -=1;
      }
    });

  }

  _addWeight(int index) {
    double _currentWeight = double.parse(_controller[index].text);
    _currentWeight += 2.5;
      _controller[index].text =  _currentWeight.toString();



  }

  _removeWeight(int index) {
    double _currentWeight = double.parse(_controller[index].text);
    if(_currentWeight >=2.5) {
      _currentWeight -= 2.5;
    }
      _controller[index].text =  _currentWeight.toString();
  }

  _changeAllWeight(double index){
    _controller.forEach((element) {
      setState(() {
        element.text = index.toString();
      });

    });
  }

  _addRep(int index){
    int _currentRep = int.parse(_repController[index].text);
    _currentRep += 1;
    _repController[index].text =  _currentRep.toString();
  }

  _removeRep(int index){
    int _currentRep = int.parse(_repController[index].text);
    print(_currentRep);
    if(_currentRep >= 1) {
      _currentRep -= 1;
    }
    _repController[index].text =  _currentRep.toString();
  }

  _cancelNewEx(){
    Navigator.pop(context);
    _controller = [];
    _repController = [];
    _currentSeries = 1;
    _repSelect = false;
  }

  _addNewEx(Ejercicios ejercicios, int series , List<TextEditingController> numRepS, List<TextEditingController> weightS){
    List<int> numRep = [];
    List<double> weight = [];
    List<Reps> newReps = [];
    numRepS.forEach((element) {
      numRep.add(int.parse(element.text));
      print("repn $element");
    });
    print("hay un total de ${numRep.length}");
    weightS.forEach((element) {
      weight.add(double.parse(element.text));
    });
    print("hay un total de ${weight.length}");
    widget.rutina.ejercicios?.add(ejercicios);
    int i=0;
    while(i<series){
      Reps newRep = Reps(numRep: 2, weight: 2);
      newReps.add(newRep);
      i++;
    }
    widget.rutina.ejercicios?.last.reps = newReps;
    widget.rutina.ejercicios?.forEach((element) {
    });
    Navigator.pop(context);
    _controller = [];
    _currentSeries = 1;
  }

  Future _allWeightsMenu() async{
    await  showDialog(
        context: context, builder: (context){
      return StatefulBuilder(builder: (context, setState){
        return UnconstrainedBox(
          child: Container(
            width: 100,
            child: Dialog(
              insetPadding: EdgeInsets.only(bottom: 100,right: 50),
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: constWeight.length,
                  itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    setState((){
                      _changeAllWeight(constWeight[index]);
                    });
                  Navigator.pop(context);},
                  child: Container(
                      width: 30,
                      height: 25,
                      child: Text("${constWeight[index]}")),
                );
              }),
            ),
          ),
        );
      });
    });
  }

  Future _allRepsMenu() async{
    await  showDialog(
        context: context, builder: (context){
      return StatefulBuilder(builder: (context, setState){
        return UnconstrainedBox(
          child: Container(
            width: 100,
            child: Dialog(
              insetPadding: EdgeInsets.only(bottom: 100,right: 50),
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: constReps.length,
                  itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    setState((){
                      _changeAllWeight(constReps[index]);
                    });
                  Navigator.pop(context);},
                  child: Container(
                      width: 30,
                      height: 25,
                      child: Text("${constReps[index]}")),
                );
              }),
            ),
          ),
        );
      });
    });
  }

//   _addRep() {
//     setState(() {
//       print("tap");
//       widget.rutina.ejercicios?[_currentExIndex].reps?.add(Reps(numRep: widget.rutina.ejercicios![_currentExIndex].reps!.length+1,weight: widget.rutina.ejercicios![0].reps![0].weight));
//       int _actualReps = widget.rutina.ejercicios![_currentExIndex].reps!.length;
//       _repController.text = _actualReps.toString();
//     });
//   }
//
//   _removeRep() {
//     setState(() {
//       widget.rutina.ejercicios![_currentExIndex].reps?.remove(1);
//     });
//   }
//
}
