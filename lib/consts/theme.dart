import 'package:flutter/material.dart';
import 'package:reso/model/offer.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.amber,
  buttonColor: const Color(0xFFe6e6e6),
  textTheme: TextTheme(
      headline1: const TextStyle(
          fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.w600),
      headline2: const TextStyle(fontSize: 18.0, color: Colors.black),
      headline3: const TextStyle(fontSize: 14.0, color: Colors.black),
      subtitle1:
          TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.5)),
      bodyText1: const TextStyle(fontSize: 12.0, color: Colors.black),
      bodyText2:
          TextStyle(fontSize: 12.0, color: Colors.black.withOpacity(0.5)),
      button: const TextStyle(fontSize: 18.0, color: Colors.white),
      caption: TextStyle(fontSize: 10.0, color: Colors.black.withOpacity(0.5))),
);

final Map<OfferType, Color> offerTypeToColor = <OfferType, Color>{
  OfferType.activity: Colors.amber,
  OfferType.food: Colors.green,
  OfferType.product: Colors.orange,
  OfferType.service: Colors.blue,
};
