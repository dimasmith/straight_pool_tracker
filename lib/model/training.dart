import 'package:flutter/material.dart';

class Training extends ChangeNotifier {
  final List<Inning> _innings = [];
  List<TrainingEvent> _events = [];

  Training() {
    _startInning();
  }

  Training.fromEvents(List<TrainingEvent> events) {
    _startInning();
    for (var event in events) {
      if (event is PotEvent) {
        _handlePot();
      }
      if (event is MissEvent) {
        _handleMiss();
      }
      if (event is FoulEvent) {
        _handleFoul();
      }
    }
    _events = events;
  }

  int countInnings() {
    return _innings.length;
  }

  List<Inning> innings() {
    return _innings;
  }

  Inning currentInning() {
    return _innings.last;
  }

  void pot() {
    _registerEvent(PotEvent());
    _handlePot();
    notifyListeners();
  }

  void foul() {
    _registerEvent(FoulEvent());
    _handleFoul();
    notifyListeners();
  }

  void miss() {
    if (_events.isNotEmpty && _events.last is! MissEvent) {
      _registerEvent(MissEvent());
      _handleMiss();
      notifyListeners();
    }
  }

  int score() {
    int score = 0;
    for (var event in _events) {
      if (event is PotEvent) {
        score += 1;
      }
      if (event is FoulEvent) {
        score -= 1;
      }
    }
    return score;
  }

  void finish() {
    _innings.clear();
    _events.clear();
    _startInning();
    notifyListeners();
  }

  void _handlePot() {
    currentInning().scoreBalls();
  }

  void _handleFoul() {
    var inning = currentInning();
    inning.foul();
    _startInning();
  }

  void _handleMiss() {
    var inning = currentInning();
    if (inning.score() > 0) {
      _startInning();
    }
  }

  void _startInning() {
    _innings.add(Inning());
  }

  void _registerEvent(TrainingEvent event) {
    _events.add(event);
  }

  /// Check if the last action can be undone.
  bool canUndo() {
    return _events.isNotEmpty;
  }

  /// Undo the last training event
  void undo() {
    if (canUndo()) {
      _events.removeLast();
      _replayEvents();
      notifyListeners();
    }
  }

  void _replayEvents() {
    _innings.clear();
    _startInning();
    for (var event in _events) {
      if (event is PotEvent) {
        _handlePot();
      }
      if (event is MissEvent) {
        _handleMiss();
      }
      if (event is FoulEvent) {
        _handleFoul();
      }
    }
  }
}

class Inning {
  int _points = 1;
  bool _foul = false;

  Inning({int points = 0, bool foul = false}) {
    _points = points;
    _foul = foul;
  }

  int score() {
    if (hasFoul()) {
      return _points - 1;
    }
    return _points;
  }

  bool hasFoul() {
    return _foul;
  }

  void scoreBalls({int pottedBalls = 1}) {
    _points += pottedBalls;
  }

  void correctScore() {
    if (_points > 0) {
      _points--;
    }
  }

  void foul() {
    _foul = true;
  }
}

abstract class TrainingEvent {
  final int type;
  final DateTime date;

  TrainingEvent(this.type, this.date);
}

class PotEvent extends TrainingEvent {
  PotEvent() : super(0, DateTime.now());
}

class MissEvent extends TrainingEvent {
  MissEvent() : super(1, DateTime.now());
}

class FoulEvent extends TrainingEvent {
  FoulEvent() : super(-1, DateTime.now());
}
