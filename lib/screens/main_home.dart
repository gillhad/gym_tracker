import 'package:flutter/material.dart';
import 'package:gym_tracker/screens/history.dart';

import 'home.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
int _selectedIndex = 0;
_onItemTapped(int index){
  setState(() {
    _selectedIndex = index;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _bottomNavigationBar(),
      body:
      navigationSelect[_selectedIndex],


    );
  }
  
  BottomNavigationBar _bottomNavigationBar(){
    return BottomNavigationBar(
  unselectedItemColor: Color(0x61D4D0D0),
  selectedItemColor: Colors.white,
  backgroundColor: Color(0xFF37393D),
  iconSize: 18,
  selectedFontSize: 12,
  currentIndex: _selectedIndex,
  type: BottomNavigationBarType.fixed,
  onTap: _onItemTapped,
  items: <BottomNavigationBarItem>[BottomNavigationBarItem(
      icon: Container(width: 50, height: 25, margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _selectedIndex == 0 ? Color(0x6BAFADAD) : Color(0xFF37393D)),
      child: Icon(Icons.play_circle_outline)),label: "Inicio"),
    BottomNavigationBarItem(

        icon: Container(width: 50,height: 25, margin: EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    color: _selectedIndex == 1 ? Color(0x6BAFADAD) : Color(0xFF37393D)),
    child:

        Icon(Icons.show_chart_outlined)), label: "Estadística"),
    BottomNavigationBarItem(icon: Container(width: 50,height: 25, margin: EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    color: _selectedIndex == 2 ? Color(0x6BAFADAD) : Color(0xFF37393D)),
    child: Icon(Icons.history,)), label: "Historial"),
    BottomNavigationBarItem(icon: Container(width: 50,height: 25, margin: EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    color: _selectedIndex == 3 ? Color(0x6BAFADAD) : Color(0xFF37393D)),
    child: Icon(Icons.person_outline)), label: "Cuerpo"),
        BottomNavigationBarItem(icon: Container(width: 50,height: 25, margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _selectedIndex == 4 ? Color(0x6BAFADAD) : Color(0xFF37393D)),
            child: Icon(Icons.menu)), label: "Mas"),
  ]
  );
}

List<Widget> navigationSelect = <Widget>[
  Home(),
  History(),
];


}



