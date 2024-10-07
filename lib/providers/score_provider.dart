import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreProvider with ChangeNotifier {
  int _score = 0;
  List<int> _highScores = [];

    ScoreProvider() {
    _loadHighScores();
  }

  int get score => _score;
  List<int> get highScores => _highScores;



  void updateScore(int increment) {
    _score += increment;
    notifyListeners(); // Notify listeners when score changes
  }

  void resetScore() {
    _addHighScore(_score);
    _score = -1;
    notifyListeners();
  }


  Future<void> _addHighScore(int score) async {
    _highScores.add(score);
    _highScores.sort((a, b) => b.compareTo(a)); // Tri décroissant
    _highScores = _highScores.take(5).toList(); // Garde les 5 meilleurs scores
    await _saveHighScores();
  }
  Future<void> _saveHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('highScores', _highScores.map((e) => e.toString()).toList());
  }
  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('highScores');
    if (scores != null) {
      _highScores = scores.map((e) => int.parse(e)).toList();
    }
  }
}


