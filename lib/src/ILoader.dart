import 'dart:async';

/// Interface for data processing components that load data items.
abstract class ILoader<T> {
  /// Loads data items.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// Return                Future that receives a list of data items
  /// Throw error.
  Future<List<T>> load(String? correlation_id);
}
