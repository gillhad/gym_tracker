import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/models.dart';

class ExeDetail extends StatefulWidget {
  ExeDetail({Key? key, required this.rutina, this.selectedEx})
      : super(key: key);
  Rutina rutina;
  Ejercicios? selectedEx;


  @override
  State<ExeDetail> createState() => _ExeDetailState();
}

class _ExeDetailState extends State<ExeDetail> {
  late Ejercicios _currentEx;
  late int _currentExIndex;
  int _weightAmount = 0;
  int _repsAmount = 0;
  List<String> _weightOptions = ["Valor por defecto", "+-0.25", "+-0.5"];
  late List<Ejercicios> _listaEjer;
  String dropdownValue = "Peso";
  String serieValue = "Serie";
  double _currentWeightModifier = 0.5;
  TextEditingController _weightController = TextEditingController();
  TextEditingController _repController = TextEditingController();
  int countdown = 180;
  int _trainingTime = 0;
  late Timer _trainingTimer;
  CarouselController _carController = CarouselController();
  int _currentExImage = 0;
  int _currentRep = 1;
  List<int> _currentRepsStored = [];




  @override
  void initState() {
    _listaEjer = widget.rutina.ejercicios!;
    _weightController.text =  widget.rutina.ejercicios![1].reps![1].weight.toString();
    _repController.text =  widget.rutina.ejercicios![1].reps![1].numRep.toString();
    _currentEx = widget.selectedEx!;
    _currentExIndex = widget.rutina.ejercicios!.indexOf(_currentEx);
    _storeReps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appbar(),
      backgroundColor: Color(0xFF232222),
      body: Stack(
          children: [
            _body(),
            _nextSerie(),
          ]),
    ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(widget.rutina.name),
      leading: IconButton(
        icon: Icon(Icons.event_note_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Icon(Icons.show_chart),
        SizedBox(
          width: 12,
        ),
        Icon(Icons.edit),
        SizedBox(
          width: 12,
        ),
        Icon(Icons.more_vert),
      ],
    );
  }

  Widget _body() {
    return Column(
      children: [
        _exResume(),
        Padding(padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _title(),
            SizedBox(height: 8,),
            _weight(),
            SizedBox(height: 8,),
            _reps(),
          ],
        )
          ),

      ],
    );
  }



  Widget _exResume() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      color: Color(0xFD454545),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3-28,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                carouselController: _carController,
                options: CarouselOptions(
                  initialPage: _currentExIndex,
                  onPageChanged: (index, reason) {
                    setState(() {
                        _currentExIndex = index;
                        _currentEx = widget.rutina.ejercicios![_currentExIndex];
                    });
                  },
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height / 3-30,
                  aspectRatio: 0.6,
                ),
                items:
                    _listaEjer.map((item) => _currentExWidget())
                    .toList(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 20,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.rutina.ejercicios?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext, index){
                    return Container(
                      margin: EdgeInsets.only(right: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: _currentExIndex == index ? Colors.white : Colors.black),
                    );
                  })
                ],
              ),
            )
          ],
        ),
    );
  }

  Widget _currentExWidget(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                  height:30,
                  child: Icon(Icons.brightness_4_outlined)),
              Spacer(),
              Icon(Icons.hourglass_bottom),
              Text("$countdown s"),
              Spacer(),
              Icon(Icons.timer),
              _timer(),
              Spacer(),
              Icon(Icons.speaker_notes_outlined),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3 -MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2,
                height: double.infinity,
              ),
              _repsHistory(),

            ],
          ),
        )
      ],
    );
  }

  Widget _title() {
    return Row(
      children: [
        DropdownButton(
            hint: Text("Serie", style: TextStyle(color: Colors.white),),
            items: <String>[].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(child: Text(value));}).toList(),

  onChanged: (String? newValue) {
    setState(() {
    serieValue = newValue!;

    });},
        underline: Container(),
        ),
        SizedBox(width: 20,),
        Container(
          alignment: Alignment.bottomCenter,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_currentRepsStored[_currentExIndex].toString(), style: TextStyle(color: Colors.white,fontSize: 18),),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Text("/${_currentEx.reps?.length}",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.end,))
            ],
          ),
        ),
        SizedBox(width: 8,),
        Spacer(),
        Container(
          alignment: Alignment.centerLeft,
          width: 220,
          child: Text(
            _currentEx.name,
            maxLines: 2,
            style: TextStyle(color: Colors.white),
          ),
        ),

      ],
    );
  }

  Widget _weight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 60,
          alignment: Alignment.centerRight,
          child: DropdownButton<String>(
            isExpanded: true,
              hint: Text("Peso",style: TextStyle(color: Colors.white),),
              underline: Container(),
              items:
              _weightOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  _weightModifierFunction(dropdownValue);
                });
              }),
        ),
        Spacer(),
        Container(
          width: 100,
          height: 20,
          child: TextFormField(
            controller:  _weightController,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.bottom,
            textAlign: TextAlign.left,
            maxLength: 3,
            style: TextStyle(fontSize: 20,color: Colors.white),
            keyboardType: TextInputType.number,
            // initialValue:
            //     widget.rutina.ejercicios?[0].reps?[0].weight.toString(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIconConstraints: BoxConstraints(maxWidth: 20),
              suffixIcon: Container(
                  width: 20,
                  child: Text(
                    "Kg",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.right,
                  )),
              // suffixStyle: TextStyle(color: Colors.grey, fontSize: 24)
            ),
          ),
        ),
        SizedBox(width: 18,),
        _basicButton(Icons.remove, _removeWeight),
        _basicButton(Icons.add, _addWeight),

      ],
    );
  }

  Widget _reps() {
    return Row(
      children: [
        Text(
          "Reps",
          style: TextStyle(color: Colors.white),
        ),
        Spacer(),
        Container(
          width: 100,
          height: 20,
          child: TextFormField(
            controller: _repController,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.bottom,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white,fontSize: 20),
            // initialValue:
            //     widget.rutina.ejercicios?[0].reps?.length.toString(),
            maxLength: 2,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIconConstraints: BoxConstraints(maxWidth: 20),
              suffixIcon: Container(
                  width: 20,
                  child: Text(
                    "X",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.right,
                  )),
              // suffixStyle: TextStyle(color: Colors.grey, fontSize: 24)
            ),
          ),
        ),
        SizedBox(width: 18,),
        _basicButton(Icons.remove, _removeRep),
        _basicButton(Icons.add, _addRep)
      ],
    );
  }

  Widget _nextSerie(){
   return Positioned(
bottom: 24 ,
     child: GestureDetector(
       onTap: (){_finishSerie();},
       child: Container(
         width: MediaQuery.of(context).size.width,
         alignment: Alignment.center,
         child: Container(
           width: 48,
             height: 48,
           decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: Colors.red),
           child: Icon(Icons.done),
         ),
       ),
     ),

   ) ;
  }

  /// Cuando pasamos la serie se actualiza la rep actual con los datos nuevos
  /// y si han acabado las reps pasa al siguiente ejercicio
  _finishSerie(){
    setState(() {
      if(_currentRepsStored[_currentExIndex] >= _currentEx.reps!.length){
        print("$_currentExIndex ");
        if(_currentExIndex == widget.rutina.ejercicios!.length-1){
          print("límite");
          return;
        }else {
          _currentEx = widget.rutina.ejercicios![_currentExIndex+1];
          _currentExIndex += 1;
        }
      }else {
        _currentEx.reps![_currentExIndex].numRep = _repController.text as int;
        _currentEx.reps![_currentExIndex].weight = _weightController.text as double;
        _currentRepsStored[_currentExIndex] += 1;

      }
    });

  }

  _editExSerie() {}

  _openExMenu() {}

  _graphicEx() {}

  IconButton _basicButton(IconData _icon, Function? _onPressed) {
    return IconButton(
        onPressed: _onPressed != null ? (){_onPressed();} : null,
        icon: Container(
            width: 60,
            height: 60,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF3B3B3B)),
            child: Icon(
              _icon,
              color: Colors.white,
            )),
        color: Colors.grey);
  }



  _addWeight() {
    widget.rutina.ejercicios?[1].reps?[1].weight += _currentWeightModifier;
    print("añado peso");
    setState(() {
      _weightController.text =  widget.rutina.ejercicios![1].reps![1].weight.toString();
    });


  }

  _removeWeight() {
    widget.rutina.ejercicios?[_currentExIndex].reps?[1].weight -= _currentWeightModifier;
    setState(() {
      _weightController.text =  widget.rutina.ejercicios![1].reps![1].weight.toString();
    });

  }

  _addRep() {
    setState(() {
      print("tap");
      widget.rutina.ejercicios?[_currentExIndex].reps?.add(Reps(numRep: widget.rutina.ejercicios![_currentExIndex].reps!.length+1,weight: widget.rutina.ejercicios![0].reps![0].weight));
      int _actualReps = widget.rutina.ejercicios![_currentExIndex].reps!.length;
      _repController.text = _actualReps.toString();
    });
  }

  _removeRep() {
    setState(() {
      widget.rutina.ejercicios![_currentExIndex].reps?.remove(1);
    });
  }
  
  Widget _timer(){
    return Text(
      "${_trainingTime/60.round()} min"
    );
  }

  Widget _repsHistory(){
    return Expanded(
      child: SingleChildScrollView(
        child:
        // Container(
        //   width: MediaQuery.of(context).size.width / 2,
        //   height:  MediaQuery.of(context).size.height / 3 -MediaQuery.of(context).size.height / 10,
        //   child:
              Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            width:40,
                            child: Text("Serie")),
                        Container(
                            alignment: Alignment.centerRight,
                            width:40,
                            child: Text("Peso")),
                        Container(
                            alignment: Alignment.centerRight,
                            width:40,
                            child: Text("Reps")),
                      ],
                    ),
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _showReps(_currentEx.reps!),
                        _showReps(_currentEx.newReps!),
                      ]
                  ),
              ],
        ),
        ),
      // ),
    );
  }

  Widget _showReps(List<Reps> _reps){
    return Expanded(
      flex: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: _reps.length,
              itemBuilder: (BuildContext, index){
                return Container(
                  child: Row(
                    children: [
                      index == 0 ? Container(
                        alignment: Alignment.centerLeft,
                        width: 30,
                        height: 20,
                        child: Text("day"),
                      ) : Container(width: 30,),
                      Container(
                          alignment: Alignment.centerRight,
                          width:40,
                          child: Text(index.toString())),
                      Container(
                          alignment: Alignment.centerRight,
                          width: 40,
                          child: Text(_reps[index].weight.round().toString())),
                      Container(
                          alignment: Alignment.centerRight,
                          width: 40,
                          child: Text(_reps[index].numRep.toString())),
                    ],
                  ),
                );
              })
        ],
      ),
    );
    
  }

  _startTimer(){
    _trainingTimer = Timer.periodic(Duration(seconds: 1),(timer){
      setState(() {
        _trainingTime += 1;
      });
    });
  }


  _weightModifierFunction(String currentValue) {
    switch (currentValue) {
      case "+-0.25":
        _currentWeightModifier = 0.25;
        break;
      case "+-0.5":
        _currentWeightModifier = 0.5;
        break;
      default:
        _currentWeightModifier = 0.5;
        return;
    }
  }

  _storeReps(){
    widget.rutina.ejercicios!.forEach((element) {
      _currentRepsStored.add(1);
    });
  }
}
