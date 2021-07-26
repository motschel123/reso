import 'package:flutter/material.dart';

class DefaultProfileImage extends StatelessWidget {
  const DefaultProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/default_image.png'),
      backgroundColor: Colors.white,
      radius: 28.0,
    );
  }
}
