import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get mainTheme {
    //1
    return ThemeData( //2
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        textTheme: TextTheme(

        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white
        ),
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0)),

        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF5A5959),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xBC628AEA),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        )
    );

  }
  }