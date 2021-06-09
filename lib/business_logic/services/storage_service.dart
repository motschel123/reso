import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class StorageService {
  /// return the imageReference to the uploaded image
  static Future<String> uploadImage(File image,
      {final bool compress = true}) async {
    final File? compressedImage;
    if (compress) {
      compressedImage = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path, '${image.absolute.path}_comp.jpg',
          quality: 5);

      if (compressedImage == null) {
        print('Image null');
        throw Exception('Unable to compress image');
      }
    } else {
      compressedImage = image;
    }

    final String imageRef =
        '${FirebaseAuth.instance.currentUser!.uid}/${compressedImage.hashCode}';

    await _storage.ref(imageRef).putFile(compressedImage);
    return imageRef;
  }

  static Future<void> deleteFile(String path) {
    return _storage.ref(path).delete();
  }

  static Future<String> getDownloadURL(String ref) {
    return _storage.ref(ref).getDownloadURL();
  }
}
