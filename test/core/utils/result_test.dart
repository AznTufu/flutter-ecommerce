import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rendu/core/utils/result.dart';

void main() {
  group('Result Utility Tests', () {
    test('Success creates instance with data', () {
      const result = Success<int>(42);
      
      expect(result, isA<Success<int>>());
      expect(result.data, 42);
    });

    test('Failure creates instance with message', () {
      const result = Failure<int>('Error occurred');
      
      expect(result, isA<Failure<int>>());
      expect(result.message, 'Error occurred');
      expect(result.exception, null);
    });

    test('Failure can store exception', () {
      final exception = Exception('Test exception');
      final result = Failure<int>('Error with exception', exception);
      
      expect(result.message, 'Error with exception');
      expect(result.exception, exception);
    });

    test('isSuccess returns true for Success', () {
      const result = Success<String>('test');
      
      expect(result.isSuccess, true);
      expect(result.isFailure, false);
    });

    test('isFailure returns true for Failure', () {
      const result = Failure<String>('error');
      
      expect(result.isFailure, true);
      expect(result.isSuccess, false);
    });

    test('dataOrNull returns data for Success', () {
      const result = Success<int>(100);
      
      expect(result.dataOrNull, 100);
    });

    test('dataOrNull returns null for Failure', () {
      const result = Failure<int>('error');
      
      expect(result.dataOrNull, null);
    });

    test('errorOrNull returns message for Failure', () {
      const result = Failure<int>('Something went wrong');
      
      expect(result.errorOrNull, 'Something went wrong');
    });

    test('errorOrNull returns null for Success', () {
      const result = Success<int>(42);
      
      expect(result.errorOrNull, null);
    });

    test('when executes success callback for Success', () {
      const result = Success<int>(10);
      
      final output = result.when(
        success: (data) => 'Value: $data',
        failure: (message) => 'Error: $message',
      );
      
      expect(output, 'Value: 10');
    });

    test('when executes failure callback for Failure', () {
      const result = Failure<int>('Network error');
      
      final output = result.when(
        success: (data) => 'Value: $data',
        failure: (message) => 'Error: $message',
      );
      
      expect(output, 'Error: Network error');
    });

    test('when can return different types', () {
      const result = Success<String>('test');
      
      final intOutput = result.when(
        success: (data) => data.length,
        failure: (message) => 0,
      );
      
      expect(intOutput, 4);
      expect(intOutput, isA<int>());
    });

    test('Result works with complex types', () {
      final result = Success<List<String>>(['a', 'b', 'c']);
      
      expect(result.isSuccess, true);
      expect(result.dataOrNull, ['a', 'b', 'c']);
      expect(result.dataOrNull?.length, 3);
    });

    test('Result can be used in pattern matching', () {
      Result<int> getNumber(bool shouldFail) {
        if (shouldFail) {
          return const Failure('Failed to get number');
        }
        return const Success(42);
      }
      
      final successResult = getNumber(false);
      final failureResult = getNumber(true);
      
      expect(successResult.isSuccess, true);
      expect(failureResult.isFailure, true);
    });
  });
}
