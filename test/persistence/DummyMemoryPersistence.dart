import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../lib/src/persistence/IdentifiableMemoryPersistence.dart';
import '../Dummy.dart';
import '../IDummyPersistence.dart';

class DummyMemoryPersistence
    extends IdentifiableMemoryPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyMemoryPersistence() : super();

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      String correlationId, filter, PagingParams paging) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    return super.getPageByFilterEx(correlationId, (Dummy item) {
      if (key != null && item.key != key) {
        return false;
      }
      return true;
    }, paging, null, null);
  }
}
