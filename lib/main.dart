import 'package:flutter/material.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/Feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const Feed(),
    );
  }
}
