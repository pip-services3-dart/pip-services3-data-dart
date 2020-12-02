import 'dart:async';
import 'dart:convert';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import './MemoryPersistence.dart';
import '../IWriter.dart';
import '../IGetter.dart';
import '../ISetter.dart';
import '../ILoader.dart';
import '../ISaver.dart';

/// Abstract persistence component that stores data in memory
/// and implements a number of CRUD operations over data items with unique ids.
/// The data items must implement [IIdentifiable interface](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/IIdentifiable-class.html).
///
/// In basic scenarios child classes shall only override [getPageByFilter],
/// [getListByFilter] or [deleteByFilter] operations with specific filter function.
/// All other operations can be used out of the box.
///
/// In complex scenarios child classes can implement additional operations by
/// accessing cached items via this._items property and calling [save] method
/// on updates.
///
/// See [MemoryPersistence]
///
/// ### Configuration parameters ###
///
/// - options:
///     - max_page_size:       Maximum number of items returned in a single page (default: 100)
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0     (optional) [ILogger](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/ILogger-class.html) components to pass log messages
///
/// ### Examples ###
///
///     class MyMemoryPersistence extends IdentifiableMemoryPersistence<MyData, string> {
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
///         Future<DataPage<MyData>> getPageByFilter(String correlationId, FilterParams filter, PagingParams paging){
///             return super.getPageByFilter(correlationId, composeFilter(filter), paging, null, null);
///         }
///
///     }
///
///    var persistence = MyMemoryPersistence();
///
///    var item = persistence.create("123", { id: "1", name: "ABC" })
///    var page = persistence.getPageByFilter(
///             "123",
///             FilterParams.fromTuples(["name", "ABC"]),
///             null);
///
///    print(page.data);          // Result: { id: "1", name: "ABC" }
///
///    item = persistence.deleteById("123", "1");
///                     ...
///

class IdentifiableMemoryPersistence<T extends IIdentifiable<K>, K>
    extends MemoryPersistence<T>
    implements IConfigurable, IWriter<T, K>, IGetter<T, K>, ISetter<T> {
  /// Creates a new instance of the persistence.
  ///
  /// - [loader]    (optional) a loader to load items from external datasource.
  /// - [saver]     (optional) a saver to save items to external datasource.
  IdentifiableMemoryPersistence([ILoader<T> loader, ISaver<T> saver])
      : super(loader, saver);

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    maxPageSize =
        config.getAsIntegerWithDefault('options.max_page_size', maxPageSize);
  }

  /// Gets a list of data items retrieved by given unique ids.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [ids]               ids of data items to be retrieved
  /// Return                Future that receives a data list
  /// Throw error.
  Future<List<T>> getListByIds(String correlationId, List<K> ids) {
    var filter = (T item) {
      return ids.indexOf(item.id) >= 0;
    };
    return getListByFilterEx(correlationId, filter, null, null);
  }

  /// Gets a data item by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of data item to be retrieved.
  /// Return         Future that receives data item or error.
  @override
  Future<T> getOneById(String correlationId, K id) async {
    var items = List<T>.from(this.items.where((x) {
      return x.id == id;
    }));
    var item = items.isNotEmpty ? items[0] : null;

    if (item != null) {
      logger.trace(correlationId, 'Retrieved item %s', [id]);
    } else {
      logger.trace(correlationId, 'Cannot find item by %s', [id]);
    }

    return item;
  }

  /// Creates a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              an item to be created.
  /// Return         (optional) Future that receives created item or error.

  @override
  Future<T> create(String correlationId, T item) async {
    var clone_item;
    if (item is ICloneable) {
      clone_item = (item as ICloneable).clone();
    } else {
      var jsonMap = json.decode(json.encode(item));
      clone_item = TypeReflector.createInstanceByType(T, []);
      clone_item.fromJson(jsonMap);
    }

    if (clone_item.id == null) {
      ObjectWriter.setProperty(clone_item, 'id', IdGenerator.nextLong());
    }

    items.add(clone_item);
    logger.trace(correlationId, 'Created item %s', [clone_item.id]);
    await save(correlationId);
    return clone_item;
  }

  /// Sets a data item. If the data item exists it updates it,
  /// otherwise it create a new data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              a item to be set.
  /// Return         (optional) Future that receives updated item or error.
  @override
  Future<T> set(String correlationId, T item) async {
    var clone_item;
    if (item is ICloneable) {
      clone_item = (item as ICloneable).clone();
    } else {
      var jsonMap = json.decode(json.encode(item));
      clone_item = TypeReflector.createInstanceByType(T, []);
      clone_item.fromJson(jsonMap);
    }

    if (clone_item.id == null) {
      ObjectWriter.setProperty(clone_item, 'id', IdGenerator.nextLong());
    }

    if (clone_item.id == null) {
      ObjectWriter.setProperty(item, 'id', IdGenerator.nextLong());
    }

    var index = List.from(items.map((x) {
      return x.id;
    })).indexOf(clone_item.id);

    if (index < 0) {
      items.add(clone_item);
    } else {
      items[index] = clone_item;
    }
    logger.trace(correlationId, 'Set item %s', [clone_item.id]);
    await save(correlationId);
    return clone_item;
  }

  /// Updates a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              an item to be updated.
  /// Return         (optional) Future that receives updated item
  /// Throws error.
  @override
  Future<T> update(String correlationId, T item) async {
    var index = List.from(items.map((x) {
      return x.id;
    })).indexOf(item.id);

    if (index < 0) {
      logger.trace(correlationId, 'Item %s was not found', [item.id]);
      return null;
    }

    var clone_item;
    if (item is ICloneable) {
      clone_item = (item as ICloneable).clone();
    } else {
      var jsonMap = json.decode(json.encode(item));
      clone_item = TypeReflector.createInstanceByType(T, []);
      clone_item.fromJson(jsonMap);
    }

    if (clone_item.id == null) {
      ObjectWriter.setProperty(clone_item, 'id', IdGenerator.nextLong());
    }

    items[index] = clone_item;
    logger.trace(correlationId, 'Updated item %s', [clone_item.id]);

    await save(correlationId);

    return clone_item;
  }

  /// Updates only few selected fields in a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of data item to be updated.
  /// - [data]              a map with fields to be updated.
  /// Return         Future that receives updated item
  /// Throws error.
  Future<T> updatePartially(
      String correlationId, K id, AnyValueMap data) async {
    var index = List.from(items.map((x) {
      return x.id;
    })).indexOf(id);

    if (index < 0) {
      logger.trace(correlationId, 'Item %s was not found', [id]);
      return null;
    }

    var item = items[index];
    ObjectWriter.setProperties(item, data);

    items[index] = item;
    logger.trace(correlationId, 'Partially updated item %s', [id]);

    await save(correlationId);
    return item;
  }

  /// Deleted a data item by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of the item to be deleted
  /// Return                Future that receives deleted item
  /// Throws error.
  @override
  Future<T> deleteById(String correlationId, K id) async {
    var index = List.from(items.map((x) {
      return x.id;
    })).indexOf(id);

    if (index < 0) {
      logger.trace(correlationId, 'Item %s was not found', [id]);
      return null;
    }

    var item = items[index];
    items.removeAt(index);
    logger.trace(correlationId, 'Deleted item by %s', [id]);
    await save(correlationId);
    return item;
  }

  /// Deletes multiple data items by their unique ids.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [ids]               ids of data items to be deleted.
  /// Return                 Future that receives null for success.
  /// Throws error
  Future deleteByIds(String correlationId, List<K> ids) async {
    var filter = (T item) {
      return ids.indexOf(item.id) >= 0;
    };
    await deleteByFilterEx(correlationId, filter);
  }
}
