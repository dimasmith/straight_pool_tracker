import 'package:flutter_test/flutter_test.dart';
import 'package:straight_pool_tracker/model/training.dart';

void main() {
  group('trainings', () {
    test('start new training', () {
      Trainings trainings = Trainings();

      trainings.start();

      expect(trainings.current(), isNotNull);
      expect(trainings.isRunning(), true);
    });

    test('training is not active by default', () {
      Trainings trainings = Trainings();

      expect(trainings.current(), isNull);
      expect(trainings.isRunning(), false);
    });

    test('finish training stops current training', () {
      Trainings trainings = Trainings();
      trainings.start();

      trainings.finish();

      expect(trainings.current(), isNull);
    });

  });
}