import 'package:flutter/material.dart';

class CourseState extends ChangeNotifier {
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