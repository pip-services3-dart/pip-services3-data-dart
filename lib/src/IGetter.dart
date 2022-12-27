import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for data processing components that can get data items.

abstract class IGetter<T extends IIdentifiable<K>, K> {
  /// Gets a data items by its unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of item to be retrieved.
  /// Return                that receives an item
  /// Throw error.
  Future<T?> getOneById(String? correlation_id, K id);
}
