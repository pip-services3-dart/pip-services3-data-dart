import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for data processing components that can retrieve a list of data items by filter.
abstract class IFilteredReader<T> {
  /// Gets a list of data items using filter parameters.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) filter parameters
  /// - [sort]              (optional) sort parameters
  /// Return                Future that receives list of items
  /// Throw error.
  Future<List<T>> getListByFilter(
      String? correlation_id, FilterParams? filter, SortParams? sort);
}
