import 'dart:async';

/// Interface for data processing components that can set (create or update) data items.
abstract class ISetter<T> {
  /// Sets a data item. If the data item exists it updates it,
  /// otherwise it create a new data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              a item to be set.
  /// Return         (optional) Future that receives updated item
  /// Throw error.
  Future<T> set(String? correlation_id, T item);
}
