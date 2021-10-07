import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar defaultAppBar(
    {required BuildContext context,
    required Widget title,
    List<Widget>? actions}) {
  return AppBar(
    actions: actions,
    elevation: 0,
    backgroundColor: Colors.white,
    title: Align(
      alignment: Alignment.centerLeft,
      child: title,
    ),
  );
}
