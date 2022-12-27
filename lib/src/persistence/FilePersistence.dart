import 'package:pip_services3_commons/pip_services3_commons.dart';

import './JsonFilePersister.dart';
import './MemoryPersistence.dart';

/// Abstract persistence component that stores data in flat files
/// and caches them in memory.
///
/// This is the most basic persistence component that is only
/// able to store data items of any type. Specific CRUD operations
/// over the data items must be implemented in child classes by
/// accessing _items property and calling [save] method.
///
/// See [MemoryPersistence]
/// See [JsonFilePersister]
///
/// ### Configuration parameters ###
///
/// - [path]:                path to the file where data is stored
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0   (optional) [ILogger](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/ILogger-class.html) components to pass log messages
///
/// ### Example ###
///
///     class MyJsonFilePersistence extends FilePersistence<MyData> {
///         MyJsonFilePersistence([String path]): super(JsonPersister(path)) {
///         }
///
///          Future<MyData> getByName(String? correlationId, String name) async {
///             var item = items.firstWhere((d) => d.name == name);
///             return item;
///         });
///
///         Future<MyData> set(String correlatonId, MyData item) {
///             items = List.from(item.where((d) => d.name != name));
///             items.add(item);
///             await save(correlationId);
///             return item;
///         }
///
///     }

class FilePersistence<T> extends MemoryPersistence<T> implements IConfigurable {
  JsonFilePersister<T> persister;

  /// Creates a new instance of the persistence.
  ///
  /// - [persister]    (optional) a persister component that loads and saves data from/to flat file.

  FilePersistence([JsonFilePersister<T>? persister])
      : persister = persister ?? JsonFilePersister<T>() {
    saver = this.persister;
    loader = this.persister;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    persister.configure(config);
  }
}
