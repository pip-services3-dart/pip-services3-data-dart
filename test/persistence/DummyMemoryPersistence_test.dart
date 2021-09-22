import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../DummyPersistenceFixture.dart';
import './DummyMemoryPersistence.dart';

void main() {
  group('DummyMemoryPersistence', () {
    DummyMemoryPersistence persistence;
    DummyPersistenceFixture fixture;
    persistence = DummyMemoryPersistence();
    persistence.configure(ConfigParams());
    fixture = DummyPersistenceFixture(persistence);

    setUp(() async {
      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Crud Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Batch Operations', () async {
      await fixture.testBatchOperations();
    });

    test('Page Sort Operations', () async {
      await fixture.testPageSortingOperations();
    });

    test('List Sort Operations', () async {
      await fixture.testListSortingOperations();
    });
  });
}
