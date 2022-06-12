import 'package:flutter_test/flutter_test.dart';
import 'package:straight_pool_tracker/model/training.dart';

void main() {
  test('calculate normal inning score', () {
    final inning = Inning(points: 12);

    expect(inning.score(), 12);
  });

  test('calculate fouled inning score', () {
    final fouledInning = Inning(points: 12, foul: true);

    expect(fouledInning.score(), 11);
  });

  test('record inning points increases score', () {
    final runningInning = Inning(points: 1);

    runningInning.scoreBalls();

    expect(runningInning.score(), 2);
  });

  test('record multiple potted balls into inning', () {
    final runningInning = Inning(points: 1);

    runningInning.scoreBalls(pottedBalls: 2);

    expect(runningInning.score(), 3);
  });

  group('current inning', () {
    test('current inning is empty by default', () {
      final training = Training();

      Inning? currentInning = training.currentInning();

      expect(currentInning.score(), 0);
      expect(currentInning.hasFoul(), false);
    });

    test('incrementing inning increases the score', () {
      final training = Training();

      training.pot();

      expect(training.currentInning().score(), 1);
    });

    test('fouling inning closes current inning', () {
      final training = Training();
      training.pot();
      training.pot();
      int inningsCount = training.innings().length;

      training.foul();

      expect(training.innings().length, inningsCount + 1);
    });

    test('missing on inning closes current inning', () {
      final training = Training();
      training.pot();
      training.pot();
      int inningsCount = training.innings().length;

      training.miss();

      expect(training.innings().length, inningsCount + 1);
    });

    test('missing without potted balls does not record new inning', () {
      final training = Training();
      int inningsCount = training.innings().length;

      training.miss();

      expect(training.innings().length, inningsCount);
    });
  });

  group('training score', () {
    test('initial score of training is 0', () {
        final training = Training();

        int score = training.score();

        expect(score, 0);
    });

    test('includes points in the current inning', () {
        final training = Training();
        training.pot();
        training.pot();

        int score = training.score();

        expect(score, 2);
    });
  });

  group('training from events', () {
    test('do not close inning until miss or foul', () {
      Training training = Training.fromEvents([PotEvent(), PotEvent()]);

      expect(training.countInnings(), 1);
      expect(training.currentInning().score(), 2);
    });

    test('close inning on miss', () {
      Training training = Training.fromEvents([PotEvent(), MissEvent()]);

      expect(training.countInnings(), 2);
      expect(training.score(), 1);
      expect(training.currentInning().score(), 0);
    });

    test('close inning on foul and deduct points', () {
      Training training = Training.fromEvents([PotEvent(), FoulEvent()]);

      expect(training.countInnings(), 2);
      expect(training.score(), 0);
      expect(training.currentInning().score(), 0);
    });
  });

  group('undo training events', () {
    test('prohibit undoing when there are no events', () {
      Training training = Training.fromEvents([]);

      expect(training.canUndo(), false);
    });

    test('allow undoing when training has events', () {
      Training training = Training.fromEvents([PotEvent()]);

      expect(training.canUndo(), true);
    });

    test('undo potted ball', () {
      Training training = Training.fromEvents([PotEvent()]);

      training.undo();

      expect(training.score(), 0);
    });
  });
}
