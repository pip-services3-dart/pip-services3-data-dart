import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import './DummyMemoryPersistence.dart';
import '../Dummy.dart';

class DummyFilePersistence extends DummyMemoryPersistence {
  final JsonFilePersister<Dummy> _persister;

  DummyFilePersistence([String? path])
      : _persister = JsonFilePersister<Dummy>(path),
        super() {
    loader = _persister;
    saver = _persister;
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _persister.configure(config);
  }
}
