import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for data processing components to update data items partially.
abstract class IPartialUpdater<T, K> {
  /// Updates only few selected fields in a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of data item to be updated.
  /// - [data]              a map with fields to be updated.
  /// Return          Future that receives updated item
  /// Throw error.
  Future<T?> updatePartially(String? correlation_id, K id, AnyValueMap data);
}
