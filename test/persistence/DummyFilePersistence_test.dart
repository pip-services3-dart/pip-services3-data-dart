import 'package:test/test.dart';
import '../DummyPersistenceFixture.dart';
import './DummyFilePersistence.dart';

void main() {
  group('DummyFilePersistence', () {
    DummyFilePersistence persistence;
    DummyPersistenceFixture fixture;

    persistence = DummyFilePersistence('./data/dummies.json');

    fixture = DummyPersistenceFixture(persistence);

    test('Crud Operations', () async {
      await persistence.open(null);
      await persistence.clear(null);
      fixture.testCrudOperations();
      await persistence.close(null);
    });

    test('Batch Operations', () async {
      await persistence.open(null);
      await persistence.clear(null);
      fixture.testBatchOperations();
      await persistence.close(null);
    });
  });
}
