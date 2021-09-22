import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import '../Dummy.dart';
import '../IDummyPersistence.dart';

class DummyMemoryPersistence
    extends IdentifiableMemoryPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyMemoryPersistence() : super();

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      String? correlationId, FilterParams? filter, PagingParams? paging) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    return super.getPageByFilterEx(correlationId, (Dummy item) {
      if (key != null && item.key != key) {
        return false;
      }
      return true;
    }, paging, null);
  }

  @override
  Future<int> getCountByFilter(
      String? correlationId, FilterParams? filter) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    return super.getCountByFilterEx(correlationId, (Dummy item) {
      if (key != null && item.key != key) {
        return false;
      }
      return true;
    });
  }

  @override
  Future<DataPage<Dummy>> getSortedPage(
      String? correlationId, Function sort) async {
    return await super.getPageByFilterEx(correlationId, null, null, sort, null);
  }

  @override
  Future<List<Dummy>> getSortedList(
      String? correlationId, Function sort) async {
    return await super.getListByFilterEx(correlationId, null, sort, null);
  }
}
