import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../lib/src/IGetter.dart';
import '../lib/src/IWriter.dart';
import '../lib/src/IPartialUpdater.dart';
import './Dummy.dart';

abstract class IDummyPersistence
    implements
        IGetter<Dummy, String>,
        IWriter<Dummy, String>,
        IPartialUpdater<Dummy, String> {
  Future<DataPage<Dummy>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging);
  Future<List<Dummy>> getListByIds(String correlationId, List<String> ids);
  @override
  Future<Dummy> getOneById(String correlationId, String id);
  @override
  Future<Dummy> create(String correlationId, Dummy item);
  @override
  Future<Dummy> update(String correlationId, Dummy item);
  @override
  Future<Dummy> updatePartially(
      String correlationId, String id, AnyValueMap data);
  @override
  Future<Dummy> deleteById(String correlationId, String id);
  Future deleteByIds(String correlationId, List<String> id);
}
