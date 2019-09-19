import 'dart:io';

import 'package:flutter/foundation.dart';

class ImagesProvider with ChangeNotifier {
  List<File> _images = [];
  List<File> get images {
    return [..._images];
  }

  void addImages(File image) {
    _images.add(image);
    notifyListeners();
  }

  void deleteImage(int pos) {
    _images.removeAt(pos);
    notifyListeners();
  }
}
