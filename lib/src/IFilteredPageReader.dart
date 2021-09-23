import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for data processing components that can retrieve a page of data items by a filter.
abstract class IFilteredPageReader<T> {
  /// Gets a page of data items using filter parameters.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) filter parameters
  /// - [paging]            (optional) paging parameters
  /// - [sort]              (optional) sort parameters
  /// Return                Future that receives list of items
  /// Throw error.
  Future<DataPage<T>> getPageByFilter(String? correlation_id,
      FilterParams? filter, PagingParams? paging, SortParams? sort);
}
