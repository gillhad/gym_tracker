import 'package:flutter/material.dart';

BasicIconButton(IconData _icon, Function? _onPressed) {
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