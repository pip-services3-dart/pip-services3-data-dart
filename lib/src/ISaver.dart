import 'dart:async';

/// Interface for data processing components that save data items.
abstract class ISaver<T> {
  /// Saves given data items.
  ///
  /// - correlation_id    (optional) transaction id to trace execution through call chain.
  /// - item              a list of items to save.
  /// Return         (optional) Future that receives null for success.
  /// Throw error
  Future save(String? correlation_id, List<T> items);
}
