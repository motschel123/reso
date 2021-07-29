import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

//final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseStorage _imageBucket =
    FirebaseStorage.instanceFor(bucket: 'gs://images-bkfz5/');

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
    final String imageRef = compressedImage.hashCode.toString();

    return _imageBucket
        .ref(imageRef)
        .putFile(compressedImage)
        .then<String>((TaskSnapshot taskSnap) {
      if (taskSnap.state == TaskState.error) {
        throw Exception('image upload failed');
      } else
        return imageRef;
    });
  }

  static Future<void> deleteImage(String path) {
    return _imageBucket.ref(path).delete();
  }

  static Future<String> getImageUrl(String ref) {
    return _imageBucket.ref(ref).getDownloadURL();
  }
}
