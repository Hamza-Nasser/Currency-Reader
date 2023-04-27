import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImageDetection extends ChangeNotifier {
  XFile? picture;
  bool _isArabic = false;
  bool get isArabic => _isArabic;
  set isArabic(bool arabic) {
    _isArabic = arabic;
    notifyListeners();
  }

  Future<String?> detectCurrency(XFile picture, bool arabic) async {
    String? currencyDetection;
    try {
      if (arabic) {
        // load model with arabic labels
      } else {
        // load model with x lang labels
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return currencyDetection;
  }
}
