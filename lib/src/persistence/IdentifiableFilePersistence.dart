import 'package:pip_services3_commons/pip_services3_commons.dart';

import './IdentifiableMemoryPersistence.dart';
import './JsonFilePersister.dart';

/// Abstract persistence component that stores data in flat files
/// and implements a number of CRUD operations over data items with unique ids.
/// The data items must implement [[https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/interfaces/data.iidentifiable.html IIdentifiable interface]].
///
/// In basic scenarios child classes shall only override [[getPageByFilter]],
/// [[getListByFilter]] or [[deleteByFilter]] operations with specific filter function.
/// All other operations can be used out of the box.
///
/// In complex scenarios child classes can implement additional operations by
/// accessing cached items via this._items property and calling [[save]] method
/// on updates.
///
/// See [[JsonFilePersister]]
/// See [[MemoryPersistence]]
///
/// ### Configuration parameters ###
///
/// - path:                    path to the file where data is stored
/// - options:
///     - max_page_size:       Maximum number of items returned in a single page (default: 100)
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0       (optional) [[https://rawgit.com/pip-services-node/pip-services3-components-node/master/doc/api/interfaces/log.ilogger.html ILogger]] components to pass log messages
///
/// ### Examples ###
///
///     class MyFilePersistence extends IdentifiableFilePersistence<MyData, String> {
///         MyFilePersistence([String path]):super(JsonPersister(path)) {
///         }
///
///         dynamic _composeFilter(FilterParams filter) {
///             filter = filter ?? FilterParams();
///             var name = filter.getAsNullableString("name");
///             return (item) {
///                 if (name != null && item.name != name)
///                     return false;
///                 return true;
///             };
///         }
///
///         Future<DataPage<MyData>> getPageByFilter(string correlationId, FilterParams filter, PagingParams paging){
///            return super.getPageByFilter(correlationId, _composeFilter(filter), paging, null, null);
///         }
///
///     }
///
///     var persistence = MyFilePersistence("./data/data.json");
///
///     await persistence.create("123", { id: "1", name: "ABC" });
///     var page = await persistence.getPageByFilter(
///             "123",
///             FilterParams.fromTuples([
///                 "name", "ABC"
///             ]),
///             null);
///
///     print(page.data);          // Result: { id: "1", name: "ABC" }
///
///     var item = await persistence.deleteById("123", "1");
///                     ...
///

class IdentifiableFilePersistence<T extends IIdentifiable<K>, K>
    extends IdentifiableMemoryPersistence<T, K> {
  JsonFilePersister<T> _persister;

  /// Creates a new instance of the persistence.
  ///
  /// - [persister]    (optional) a persister component that loads and saves data from/to flat file.
  IdentifiableFilePersistence([JsonFilePersister<T> persister]) {
    persister = persister ?? JsonFilePersister<T>();
    loader = persister;
    saver = persister;
    _persister = persister;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _persister.configure(config);
  }
}
