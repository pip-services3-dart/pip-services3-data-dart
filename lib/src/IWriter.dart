import 'dart:async';

/// Interface for data processing components that can create, update and delete data items.
abstract class IWriter<T, K> {
  /// Creates a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              an item to be created.
  /// Return                Future that receives created item
  /// Throw error.
  Future<T?> create(String? correlation_id, T item);

  /// Updates a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              an item to be updated.
  /// Return                Future that receives updated item
  /// Throw error.
  Future<T?> update(String? correlation_id, T item);

  /// Deleted a data item by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of the item to be deleted
  /// Return                Future that receives deleted item
  /// Throw error.
  Future<T?> deleteById(String? correlation_id, K id);
}
