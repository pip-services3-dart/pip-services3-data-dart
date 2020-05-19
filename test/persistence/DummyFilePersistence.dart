import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import './DummyMemoryPersistence.dart';
import '../Dummy.dart';

class DummyFilePersistence extends DummyMemoryPersistence {
  JsonFilePersister<Dummy> _persister;

  DummyFilePersistence([String path]) : super() {
    _persister = JsonFilePersister<Dummy>(path);
    loader = _persister;
    saver = _persister;
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _persister.configure(config);
  }
}
