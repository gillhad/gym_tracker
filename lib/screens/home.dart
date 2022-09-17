import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/arguments/arguments_class.dart';
import 'package:gym_tracker/navigation/navigator_router.dart';
import 'package:gym_tracker/navigation/navigator_routes.dart';
import 'package:gym_tracker/utils/mock_data.dart';
import 'package:gym_tracker/utils/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey key = GlobalKey();
  late List<Rutina> rutinas = [];
  bool _isOpen = true;
  ExpandableController _expandableController = ExpandableController();
  bool _editMenuOpen = false;
  bool _menuPositioned = false;
  DayOfWeek _dayOfWeek = DayOfWeek.Lunes;
  late Color _createRoutineColor = Colors.red;
  TextEditingController _newRoutineName = TextEditingController();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
        'items': 'item'
      },
    );
    setMessage('logEvent succeeded');
  }

  callback(){
    setState(() {

    });
  }

  @override
  void initState() {
    _sendAnalyticsEvent();
    super.initState();
    rutinas.add(Mock.rutina);
    rutinas.add(Mock.rutina);
    rutinas.add(Mock.rutina);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1D1F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBar(),
                Text(
                  "Rutinas",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 8,
                ),
                _rutinas(),
              ],
            ),
            Positioned(
                bottom: 15,
                right: 15,
                child: FloatingActionButton(
                  backgroundColor: Color(0xBC628AEA),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  onPressed: () {
                    setState(() {
                      _editMenuOpen = true;
                      Future.delayed(Duration(milliseconds: 100), () {
                        setState(() {
                          _menuPositioned = true;
                        });
                        print(_menuPositioned);
                      });
                    });
                    ;
                  },
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.black,
                  ),
                )),
            _editMenuOpen ? _editOptions() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      alignment: Alignment.center,
      height: 42,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Color(0XFF3F3F40)),
          width: MediaQuery.of(context).size.width * 5 / 6,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 6),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text(
                  "Base de datos de ejercicios",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                IconButton(
                    color: Colors.white,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: null)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rutinas() {
    return Expanded(
      child: ReorderableListView.builder(
          padding: EdgeInsets.all(12),
          // itemExtent: 42,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Rutina item = rutinas.removeAt(oldIndex);
              rutinas.insert(newIndex, item);
            });
          },
          itemCount: rutinas.length,
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              key: Key(index.toString()),
              onTap: () {
                Navigator.pushNamed(context, NavigationRoutes.routines,arguments: RoutineDisplayArguments(rutina: rutinas[index]));
              },
              child: Container(
                margin: EdgeInsets.only(top: 12, bottom: 12),
                height: 24,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(3)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.drag_indicator,
                      color: Colors.grey,
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: rutinas[index].color != null ? rutinas[index].color : Colors.grey,
                          shape: BoxShape.circle),
                      child: Icon(Icons.event_note),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      rutinas[index].name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _editOptions() {
    print(_editMenuOpen);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Color(0xBE383333)),
      child: Stack(
        children: [
          AnimatedPositioned(
              bottom: _menuPositioned ? 180 : 15,
              // width: _menuPositioned ? 200 : 45,
              right: 15,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 300),
              child: Container(
                alignment: Alignment.centerRight,
                width: 220,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text("Administrador de planes")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.task),
                      ),
                    )
                  ],
                ),
              )),
          AnimatedPositioned(
              bottom: _menuPositioned ? 140 : 15,
              // width: _menuPositioned ? 200 : 45,
              right: 15,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 300),
              child: Container(
                  alignment: Alignment.centerRight,
                  width: 220,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text("Selección plan")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.content_copy),
                        ),
                      )
                    ],
                  ))),
          AnimatedPositioned(
              bottom: _menuPositioned ? 100 : 15,
              // width: _menuPositioned ? 200 : 45,
              right: 15,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 300),
              child: Container(
                alignment: Alignment.centerRight,
                width: 220,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _newRutina();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text("Crear rutina")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.library_add),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
              bottom: 15,
              right: 15,
              child: FloatingActionButton(
                backgroundColor: Color(0xBC628AEA),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                onPressed: () {
                  setState(() {
                    _editMenuOpen = false;
                    _menuPositioned = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _newRutina() async {
    return showDialog(
      builder: (context) {
        return
          SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Color(0xFF3C4142),
                actions: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height * 5 / 9,
                    width: MediaQuery.of(context).size.width * 4 / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text("Crear rutina",style: TextStyle(color: Colors.white),)),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          height: 60,
                          child: InputDecorator(
                            decoration: InputDecoration(
                                labelText: "Nombre",
                                labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF507FBA),width: 2)
                              )
                            ),
                            child:
                            TextField(
                              style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                            controller: _newRoutineName,
                              decoration: InputDecoration.collapsed(hintText: ''
                                )
                              )

                          ),
                        ),
                        _etiqueta(setState),
                        _colorSelection(setState),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),
                            TextButton(onPressed: (){
                              _createNewRoutine();
                              Navigator.pop(context);}, child: Text("OK")),
                          ],
                        )
                      ],

                    ),
                  ),


                ],
              );
            }),
          );

      },
      context: context,
    );
  }

  Widget _etiqueta(StateSetter setState) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Etiqueta",style: TextStyle(color: Colors.white)),
          Row(children: [
            _etiquetaDia("Lun", DayOfWeek.Lunes, context, setState),
            _etiquetaDia("Mar", DayOfWeek.Martes, context, setState),
            _etiquetaDia("Mie", DayOfWeek.Miercoles, context, setState),
            _etiquetaDia("Jue", DayOfWeek.Jueves, context, setState),
            _etiquetaDia("Vie", DayOfWeek.Viernes, context, setState),
          ]),
          Row(
            children: [
              _etiquetaDia("Sab", DayOfWeek.Sabado, context, setState),
              _etiquetaDia("Dom", DayOfWeek.Domingo, context, setState),
              _etiquetaDia("···", DayOfWeek.Todos, context, setState),
            ],
          )
        ],
      ),
    );
  }

  Widget _colorSelection(StateSetter setState) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Código de color",style: TextStyle(color: Colors.white)),
          Row(children: [
            _colorSelectionValue(Colors.red, context, setState),
            _colorSelectionValue(Colors.green, context, setState),
            _colorSelectionValue(Colors.yellow, context, setState),
            _colorSelectionValue(Colors.blue, context, setState),
            _colorSelectionValue(Colors.deepOrange, context, setState),
            _colorSelectionValue(Colors.deepPurple, context, setState),
          ]),
          Row(
            children: [
              _colorSelectionValue(Colors.lime, context, setState),
              _colorSelectionValue(Colors.pink, context, setState),
              _colorSelectionValue(Colors.teal, context, setState),
              _colorSelectionValue(Colors.indigo, context, setState),
              _colorSelectionValue(Colors.brown, context, setState),
              GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(8),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Text("···"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _etiquetaDia(String _dayText, DayOfWeek _day, BuildContext context,
      StateSetter _setState) {
    return GestureDetector(
      onTap: () {
        _setState(() {
          _dayOfWeek = _day;
          print(_day);
          print(_dayOfWeek);
          _dayText = "a";
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(8),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _day == _dayOfWeek ? Colors.blue : Color(0xFFFDFDFE),
          shape: BoxShape.circle,
        ),
        child: Text(_dayText),
      ),
    );
  }

  Widget _colorSelectionValue(
      Color _color, BuildContext context, StateSetter _setState) {
    return GestureDetector(
      onTap: () {
        _setState(() {
          _createRoutineColor = _color;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(8),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
        child: _createRoutineColor == _color ? Icon(Icons.done) : null,
      ),
    );
  }

  _createNewRoutine() async{
    rutinas.add(Rutina(name: _newRoutineName.text, color: _createRoutineColor));

    final FirebaseAnalytics analytics;
    final FirebaseAnalyticsObserver observer;
    var db = FirebaseFirestore.instance;
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815
    };
    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
    print("rutina creada");
  }
}
