import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lecture.dart';

class LectureProvider with ChangeNotifier {
  List<Lecture> _lectures = [];
  bool _isLoading = true;

  List<Lecture> get lectures => _lectures;
  bool get isLoading => _isLoading;

  LectureProvider() {
    loadLectures();
  }

  Future<void> loadLectures() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final List<String>? lecturesJson = prefs.getStringList('lectures');
    
    if (lecturesJson != null) {
      _lectures = lecturesJson.map((json) => Lecture.fromJson(json)).toList();
      // Sort by date descending
      _lectures.sort((a, b) => b.date.compareTo(a.date));
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveLectures() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> lecturesJson = _lectures.map((l) => l.toJson()).toList();
    await prefs.setStringList('lectures', lecturesJson);
  }

  Future<void> addLecture(Lecture lecture) async {
    _lectures.insert(0, lecture);
    notifyListeners();
    await saveLectures();
  }

  Future<void> updateLecture(Lecture updatedLecture) async {
    final index = _lectures.indexWhere((l) => l.id == updatedLecture.id);
    if (index >= 0) {
      _lectures[index] = updatedLecture;
      notifyListeners();
      await saveLectures();
    }
  }

  Future<void> deleteLecture(String id) async {
    _lectures.removeWhere((l) => l.id == id);
    notifyListeners();
    await saveLectures();
  }
}
