import 'package:flutter_test/flutter_test.dart';

import 'package:baby_plan_v3/models/prediction_result.dart';
import 'package:baby_plan_v3/services/prediction_service.dart';

void main() {
  group('PredictionType', () {
    test('fromValue returns correct type for valid values', () {
      expect(PredictionType.fromValue(0), equals(PredictionType.eat));
      expect(PredictionType.fromValue(2), equals(PredictionType.sleep));
      expect(PredictionType.fromValue(3), equals(PredictionType.poop));
    });

    test('fromValue returns null for invalid values', () {
      expect(PredictionType.fromValue(1), isNull);
      expect(PredictionType.fromValue(4), isNull);
      expect(PredictionType.fromValue(-1), isNull);
    });

    test('enum values have correct properties', () {
      expect(PredictionType.eat.value, equals(0));
      expect(PredictionType.eat.label, equals('吃奶'));
      expect(PredictionType.sleep.value, equals(2));
      expect(PredictionType.sleep.label, equals('睡眠'));
      expect(PredictionType.poop.value, equals(3));
      expect(PredictionType.poop.label, equals('排泄'));
    });
  });

  group('PredictionResult', () {
    test('formattedTime returns correct format', () {
      final prediction = PredictionResult(
        type: PredictionType.eat,
        predictedTime: DateTime(2024, 1, 15, 14, 30),
        confidence: 0.8,
        description: 'Test prediction',
      );

      expect(prediction.formattedTime, equals('14:30'));
    });

    test('isMerged returns false when no related predictions', () {
      final prediction = PredictionResult(
        type: PredictionType.eat,
        predictedTime: DateTime.now(),
        confidence: 0.8,
        description: 'Test prediction',
      );

      expect(prediction.isMerged, isFalse);
    });

    test('isMerged returns true when related predictions exist', () {
      final related = PredictionResult(
        type: PredictionType.poop,
        predictedTime: DateTime.now().add(const Duration(minutes: 5)),
        confidence: 0.7,
        description: 'Related prediction',
      );

      final prediction = PredictionResult(
        type: PredictionType.eat,
        predictedTime: DateTime.now(),
        confidence: 0.8,
        description: 'Test prediction',
        relatedPredictions: [related],
      );

      expect(prediction.isMerged, isTrue);
    });

    test('primaryTip returns tips when available', () {
      final prediction = PredictionResult(
        type: PredictionType.eat,
        predictedTime: DateTime.now(),
        confidence: 0.8,
        description: 'Test prediction',
        tips: 'Custom tip',
      );

      expect(prediction.primaryTip, equals('Custom tip'));
    });

    test('primaryTip returns default tip when tips is null', () {
      final prediction = PredictionResult(
        type: PredictionType.eat,
        predictedTime: DateTime.now(),
        confidence: 0.8,
        description: 'Test prediction',
      );

      expect(prediction.primaryTip, equals(PredictionType.eat.defaultTip));
    });

    test('copyWith creates correct copy', () {
      final original = PredictionResult(
        type: PredictionType.eat,
        predictedTime: DateTime(2024, 1, 15, 14, 30),
        confidence: 0.8,
        description: 'Original',
      );

      final copy = original.copyWith(confidence: 0.9);

      expect(copy.type, equals(original.type));
      expect(copy.predictedTime, equals(original.predictedTime));
      expect(copy.confidence, equals(0.9));
      expect(copy.description, equals(original.description));
    });
  });

  group('PredictionState', () {
    test('hasPrediction returns correct value', () {
      final withPrediction = PredictionState(
        prediction: PredictionResult(
          type: PredictionType.eat,
          predictedTime: DateTime.now(),
          confidence: 0.8,
          description: 'Test',
        ),
      );

      final withoutPrediction = const PredictionState();

      expect(withPrediction.hasPrediction, isTrue);
      expect(withoutPrediction.hasPrediction, isFalse);
    });

    test('hasOngoingActivity returns correct value', () {
      final withOngoing = const PredictionState(ongoingActivityType: 0);
      final withoutOngoing = const PredictionState();

      expect(withOngoing.hasOngoingActivity, isTrue);
      expect(withoutOngoing.hasOngoingActivity, isFalse);
    });

    test('copyWith creates correct copy', () {
      const original = PredictionState(isLoading: true);
      final copy = original.copyWith(isLoading: false);

      expect(copy.isLoading, isFalse);
    });
  });

  group('PredictionService constants', () {
    test('historyWindowDays is 14 (extended for time slot samples)', () {
      expect(PredictionService.historyWindowDays, equals(14));
    });

    test('mergeWindowMinutes is 15', () {
      expect(PredictionService.mergeWindowMinutes, equals(15));
    });

    test('minHistoryRecords is 5', () {
      expect(PredictionService.minHistoryRecords, equals(5));
    });

    test('timeSlotMinSamples is 3', () {
      expect(PredictionService.timeSlotMinSamples, equals(3));
    });

    test('timeSlotWeightHigh is 0.4', () {
      expect(PredictionService.timeSlotWeightHigh, equals(0.4));
    });

    test('globalHistoryWeightHigh is 0.3', () {
      expect(PredictionService.globalHistoryWeightHigh, equals(0.3));
    });

    test('benchmarkWeight is 0.3', () {
      expect(PredictionService.benchmarkWeight, equals(0.3));
    });

    test('weights sum to 1.0 for high samples case', () {
      expect(
        PredictionService.timeSlotWeightHigh +
            PredictionService.globalHistoryWeightHigh +
            PredictionService.benchmarkWeight,
        equals(1.0),
      );
    });

    test('weights sum to 1.0 for low samples case', () {
      expect(
        PredictionService.timeSlotWeightLow +
            PredictionService.globalHistoryWeightLow +
            PredictionService.benchmarkWeight,
        equals(1.0),
      );
    });
  });
}