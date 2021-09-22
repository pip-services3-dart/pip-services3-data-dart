import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for data processing components that can query a page of data items.

abstract class IQuerablePageReader<T> {
  /// Gets a page of data items using a query string.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [query]             (optional) a query string
  /// - [paging]            (optional) paging parameters
  /// - [sort]              (optional) sort parameters
  /// Return          Future that receives list of items or error.

  Future<DataPage<T>> getPageByQuery(String? correlation_id, String query,
      PagingParams paging, SortParams sort);
}
