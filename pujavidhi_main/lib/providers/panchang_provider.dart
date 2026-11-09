import 'package:flutter/material.dart';
import '../models/panchang_model.dart';

class PanchangProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  late PanchangData _panchangData;

  DateTime get selectedDate => _selectedDate;
  PanchangData get panchangData => _panchangData;

  PanchangProvider() {
    _panchangData = PanchangData.forDate(_selectedDate);
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _panchangData = PanchangData.forDate(date);
    notifyListeners();
  }

  void goToToday() {
    selectDate(DateTime.now());
  }

  void nextDay() {
    selectDate(_selectedDate.add(const Duration(days: 1)));
  }

  void previousDay() {
    selectDate(_selectedDate.subtract(const Duration(days: 1)));
  }
}
