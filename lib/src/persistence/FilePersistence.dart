import 'package:pip_services3_commons/pip_services3_commons.dart';

import './JsonFilePersister.dart';
import './MemoryPersistence.dart';

/// Abstract persistence component that stores data in flat files
/// and caches them in memory.
///
/// This is the most basic persistence component that is only
/// able to store data items of any type. Specific CRUD operations
/// over the data items must be implemented in child classes by
/// accessing this._items property and calling [[save]] method.
///
/// See [[MemoryPersistence]]
/// See [[JsonFilePersister]]
///
/// ### Configuration parameters ###
///
/// - path:                path to the file where data is stored
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0   (optional) [[https://rawgit.com/pip-services-node/pip-services3-components-node/master/doc/api/interfaces/log.ilogger.html ILogger]] components to pass log messages
///
/// ### Example ###
///
///     class MyJsonFilePersistence extends FilePersistence<MyData> {
///         public constructor(path?: string) {
///             super(new JsonPersister(path));
///         }
///
///         public getByName(correlationId: string, name: string, callback: (err, item) => void): void {
///             let item = _.find(this._items, (d) => d.name == name);
///             callback(null, item);
///         });
///
///         public set(correlatonId: string, item: MyData, callback: (err) => void): void {
///             this._items = _.filter(this._items, (d) => d.name != name);
///             this._items.push(item);
///             this.save(correlationId, callback);
///         }
///
///     }

class FilePersistence<T> extends MemoryPersistence<T> implements IConfigurable {
  JsonFilePersister<T> persister;

  /// Creates a new instance of the persistence.
  ///
  /// - [persister]    (optional) a persister component that loads and saves data from/to flat file.

  FilePersistence([JsonFilePersister<T> persister]) {
    this.persister = persister ?? JsonFilePersister<T>();
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
