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

    test('Crud Operations', () async {
      await persistence.clear(null);
      fixture.testCrudOperations();
    });

    test('Batch Operations', () async {
      await persistence.clear(null);
      fixture.testBatchOperations();
    });
  });
}
