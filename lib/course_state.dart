import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  final Set<String> favorites = {};

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    notifyListeners();
  }

  bool isFavorite(String code) {
    return favorites.contains(code);
  }
}