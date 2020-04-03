import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import '../ILoader.dart';
import '../ISaver.dart';

/// Abstract persistence component that stores data in memory.
///
/// This is the most basic persistence component that is only
/// able to store data items of any type. Specific CRUD operations
/// over the data items must be implemented in child classes by
/// accessing this.items property and calling [[save]] method.
///
/// The component supports loading and saving items from another data source.
/// That allows to use it as a base class for file and other types
/// of persistence components that cache all data in memory.
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0       (optional) [[https://rawgit.com/pip-services-node/pip-services3-components-node/master/doc/api/interfaces/log.ilogger.html ILogger]] components to pass log messages
///
/// ### Example ###
///
///     class MyMemoryPersistence extends MemoryPersistence<MyData> {
///
///        Future<MyData> getByName(String correlationId, String name) async {
///             var item = _.find(items, (d) => d.name == name);
///            return item;
///         });
///
///         Future<MyData> set(String correlatonId, MyData item) async {
///             items = _.filter(items, (d) => d.name != name);
///             items.add(item);
///             await save(correlationId);
///             return item;
///         }
///     }
///
///     var persistence = MyMemoryPersistence();
///
///     persistence.set("123", { name: "ABC" })
///     var item = await persistence.getByName("123", "ABC")
///     print(item);                   // Result: { name: "ABC" }
///

class MemoryPersistence<T> implements IReferenceable, IOpenable, ICleanable {
  var logger = CompositeLogger();
  var items = <T>[];
  ILoader<T> loader;
  ISaver<T> saver;
  bool opened = false;

  /// Creates a new instance of the persistence.
  ///
  /// - [loader]    (optional) a loader to load items from external datasource.
  /// - [saver]     (optional) a saver to save items to external datasource.

  MemoryPersistence([ILoader<T> loader, ISaver<T> saver]) {
    this.loader = loader;
    this.saver = saver;
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    logger.setReferences(references);
  }

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.

  @override
  bool isOpen() {
    return opened;
  }

  /// Opens the component.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future open(String correlationId) async {
    await _load(correlationId);
    opened = true;
  }

  Future _load(String correlationId) async {
    if (loader == null) {
      return null;
    }

    var items = await loader.load(correlationId);
    this.items = items;
    logger.trace(correlationId, 'Loaded %d items', [items.length]);
  }

  /// Closes component and frees used resources.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future close(String correlationId) async {
    await save(correlationId);
    opened = false;
  }

  /// Saves items to external data source using configured saver component.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// Return         (optional) Future that receives error or null for success.
  Future save(String correlationId) async {
    if (saver == null) {
      return null;
    }

    await saver.save(correlationId, items);
    logger.trace(correlationId, 'Saved %d items', [items.length]);
  }

  /// Clears component state.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future clear(String correlationId) async {
    items = <T>[];
    logger.trace(correlationId, 'Cleared items');
    await save(correlationId);
  }
}
