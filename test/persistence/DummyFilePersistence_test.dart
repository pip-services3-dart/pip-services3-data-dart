import 'package:test/test.dart';
import '../DummyPersistenceFixture.dart';
import './DummyFilePersistence.dart';

void main() {
  group('DummyFilePersistence', () {
    DummyFilePersistence persistence;
    DummyPersistenceFixture fixture;

    persistence = DummyFilePersistence('./data/dummies.json');
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
