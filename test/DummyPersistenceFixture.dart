import 'package:test/test.dart';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import './Dummy.dart';
import './IDummyPersistence.dart';

class DummyPersistenceFixture {
  final _dummy1 = Dummy(id: null, key: 'Key 1', content: 'Content 1');
  final _dummy2 = Dummy(id: null, key: 'Key 2', content: 'Content 2');

  final IDummyPersistence _persistence;

  DummyPersistenceFixture(IDummyPersistence persistence)
      : _persistence = persistence;

  Future testCrudOperations() async {
    Dummy dummy1;
    Dummy dummy2;

    // Create one dummy
    var result = await _persistence.create(null, _dummy1);
    dummy1 = result!;
    expect(dummy1, isNotNull);
    expect(dummy1.id, isNotNull);
    expect(_dummy1.key, dummy1.key);
    expect(_dummy1.content, dummy1.content);

    // Create another dummy
    result = await _persistence.create(null, _dummy2);
    dummy2 = result!;
    expect(dummy2, isNotNull);
    expect(dummy2.id, isNotNull);
    expect(_dummy2.key, dummy2.key);
    expect(_dummy2.content, dummy2.content);

    var page = await _persistence.getPageByFilter(null, null, null);
    expect(page, isNotNull);
    expect(page.data.length, 2);

    // Get count
    var count = await _persistence.getCountByFilter(null, null);
    expect(count, 2);

    // Update the dummy
    dummy1.content = 'Updated Content 1';
    result = await _persistence.update(null, dummy1);
    expect(result, isNotNull);
    expect(dummy1.id, result?.id);
    expect(dummy1.key, result?.key);
    expect(dummy1.content, result?.content);

    // Partially update the dummy
    result = await _persistence.updatePartially(null, dummy1.id!,
        AnyValueMap.fromTuples(['content', 'Partially Updated Content 1']));

    expect(result, isNotNull);
    expect(dummy1.id, result!.id);
    expect(dummy1.key, result.key);
    expect('Partially Updated Content 1', result.content);

    // Get the dummy by Id
    result = await _persistence.getOneById(null, dummy1.id!);
    // Try to get item
    expect(result, isNotNull);
    expect(dummy1.id, result!.id);
    expect(dummy1.key, result.key);
    expect('Partially Updated Content 1', result.content);

    // Delete the dummy
    result = await _persistence.deleteById(null, dummy1.id);
    expect(result, isNotNull);
    expect(dummy1.id, result!.id);
    expect(dummy1.key, result.key);
    expect('Partially Updated Content 1', result.content);

    // Get the deleted dummy
    result = await _persistence.getOneById(null, dummy1.id!);
    // Try to get item
    expect(result, isNull);
  }

  Future testBatchOperations() async {
    Dummy dummy1;
    Dummy dummy2;

    // Create one dummy
    var result = await _persistence.create(null, _dummy1);
    dummy1 = result!;
    expect(dummy1, isNotNull);
    expect(dummy1.id, isNotNull);
    expect(_dummy1.key, dummy1.key);
    expect(_dummy1.content, dummy1.content);

    // Create another dummy
    result = await _persistence.create(null, _dummy2);
    dummy2 = result!;
    expect(dummy2, isNotNull);
    expect(dummy2.id, isNotNull);
    expect(_dummy2.key, dummy2.key);
    expect(_dummy2.content, dummy2.content);

    // Read batch
    var items = await _persistence.getListByIds(null, [dummy1.id!, dummy2.id!]);
    expect(items.length, 2);

    // Delete batch
    try {
      await _persistence.deleteByIds(null, [dummy1.id!, dummy2.id!]);
    } catch (err) {
      expect(err, isNull);
    }

    // Read empty batch
    items = await _persistence.getListByIds(null, [dummy1.id!, dummy2.id!]);
    expect(items.length, 0);
  }

  Future testPageSortingOperations() async {
    for (var d = 0; d < 20; d++) {
      await _persistence.create(
          null,
          Dummy(
              id: RandomString.nextString(16, 16),
              content: RandomString.nextString(1, 50),
              key: 'Key $d'));
    }

    var sortFunc = (Dummy d) => d.content?.length ?? 0 * -1;

    var page = await _persistence.getSortedPage(null, sortFunc);

    var prevDp = page.data[0];
    for (var dp = 1; dp < page.data.length; dp++) {
      expect(prevDp.content!.length >= page.data[dp].content!.length, isTrue);
      prevDp = page.data[dp];
    }
  }

  Future testListSortingOperations() async {
    // Create random objects
    for (var d = 0; d < 20; d++) {
      await _persistence.create(
          null,
          Dummy(
              id: RandomString.nextString(16, 16),
              content: RandomString.nextString(1, 50),
              key: 'Key $d'));
    }

    var sortFunc = (Dummy d) => d.content?.length ?? 0 * -1;
    var list = await _persistence.getSortedList(null, sortFunc);

    var prevDp = list[0];
    for (var dp = 1; dp < list.length; dp++) {
      expect(prevDp.content!.length >= list[dp].content!.length, isTrue);
      prevDp = list[dp];
    }
  }
}
