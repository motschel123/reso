import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
      headline1: const TextStyle(fontSize: 24.0, color: Colors.black),
      headline2: const TextStyle(fontSize: 14.0, color: Colors.black),
      bodyText1: const TextStyle(fontSize: 10.0, color: Colors.black),
      bodyText2:
          TextStyle(fontSize: 10.0, color: Colors.black.withOpacity(0.5))),
);
