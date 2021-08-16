import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/firestore.dart';

class StorageCircleAvatar extends StatelessWidget {
  const StorageCircleAvatar(this._imageRef,
      {final Key? key, final double? radius, final Color? color})
      : _color = color ?? Colors.white,
        _radius = radius ?? 28.0,
        super(key: key);

  final String _imageRef;
  final double _radius;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: FirebaseImage(_imageRef),
      backgroundColor: _color,
      radius: _radius,
    );
  }
}

class FutureStorageCircleAvatar extends StatelessWidget {
  const FutureStorageCircleAvatar(this.imageRefFuture,
      {final Key? key, final double? radius, final Color? color})
      : color = color ?? Colors.white,
        radius = radius ?? 28.0,
        super(key: key);

  final Future<String> imageRefFuture;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: imageRefFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snap) =>
            StorageCircleAvatar(
              snap.hasData ? snap.data! : DEFAULT_PROFILE_IMAGE_PATH,
              color: color,
              radius: radius,
            ));
  }
}
