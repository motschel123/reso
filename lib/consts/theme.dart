import 'package:flutter/material.dart';
import 'package:reso/model/offer.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.amber,
  buttonColor: const Color(0xFFe6e6e6),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedItemColor: Color(0xFFe6e6e6),
    showSelectedLabels: false,
  ),
  inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      )),
  textTheme: TextTheme(
    headline1: const TextStyle(
        fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.w600),
    headline2: const TextStyle(fontSize: 18.0, color: Colors.black),
    headline3: const TextStyle(fontSize: 14.0, color: Colors.black),
    subtitle1: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.5)),
    bodyText1: const TextStyle(fontSize: 12.0, color: Colors.black),
    bodyText2: TextStyle(fontSize: 12.0, color: Colors.black.withOpacity(0.5)),
    button: const TextStyle(fontSize: 18.0, color: Colors.white),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFF111111),
  canvasColor: const Color(0xFF111111),
  buttonColor: const Color(0xFF888888),
  toggleableActiveColor: Colors.amber,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF111111),
    selectedItemColor: Colors.white,
    unselectedItemColor: Color(0xFF888888),
    showSelectedLabels: false,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 12.0, color: Color(0xFF888888)),
      focusColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: Colors.red),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: Color(0xFF888888)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF888888)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      )),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.w600),
    headline2: TextStyle(fontSize: 18.0, color: Colors.white),
    headline3: TextStyle(fontSize: 14.0, color: Colors.white),
    subtitle1: TextStyle(fontSize: 14.0, color: Color(0xFF888888)),
    bodyText1: TextStyle(fontSize: 12.0, color: Colors.white),
    bodyText2: TextStyle(fontSize: 12.0, color: Color(0xFF888888)),
    button: TextStyle(fontSize: 18.0, color: Colors.white),
  ),
);

final Map<OfferType, Color> offerTypeToColor = <OfferType, Color>{
  OfferType.activity: Colors.amber,
  OfferType.food: Colors.green,
  OfferType.product: Colors.orange,
  OfferType.service: Colors.blue,
};
