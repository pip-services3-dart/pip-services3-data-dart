import 'package:test/test.dart';
import '../../lib/src/persistence/JsonFilePersister.dart';
import '../Dummy.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

void main() {
  group('JsonFilePersister', () {
    JsonFilePersister<Dummy> _persister;

    _persister = JsonFilePersister<Dummy>();

    test('Configure With No Path Key', () {
      try {
        _persister.configure(ConfigParams());
      } catch (ex) {
        expect(ex, isNotNull);
        expect(ex is ConfigException, isTrue);
      }
    });

    test('Configure If Path Key Check Property', () {
      var fileName = '../JsonFilePersisterTest';
      _persister.configure(ConfigParams.fromTuples(['path', fileName]));
      expect(fileName, _persister.path);
    });
  });
}
