import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for data processing components that can query a list of data items.
abstract class IQuerableReader<T> {
  /// Gets a list of data items using a query string.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [query]             (optional) a query string
  /// - [sort]              (optional) sort parameters
  /// Return         Future that receives list of items
  /// Throws error.
  Future<List<T>> getListByQuery(
      String? correlation_id, String? query, SortParams? sort);
}
