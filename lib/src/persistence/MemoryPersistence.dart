import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import '../ILoader.dart';
import '../ISaver.dart';
import 'dart:convert';

/// Abstract persistence component that stores data in memory.
///
/// This is the most basic persistence component that is only
/// able to store data items of any type. Specific CRUD operations
/// over the data items must be implemented in child classes by
/// accessing this.items property and calling [save] method.
///
/// The component supports loading and saving items from another data source.
/// That allows to use it as a base class for file and other types
/// of persistence components that cache all data in memory.
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0       (optional) [ILogger](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/ILogger-class.html) components to pass log messages
///
/// ### Example ###
///
///     class MyMemoryPersistence extends MemoryPersistence<MyData> {
///
///        Future<MyData> getByName(String? correlationId, String name) async {
///             var item = items.firstWhere((d) => d.name == name);
///            return item;
///         });
///
///         Future<MyData> set(String correlatonId, MyData item) async {
///             items = items.where((d) => d.name != name);
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
  ILoader<T>? loader;
  ISaver<T>? saver;
  bool opened = false;
  int maxPageSize = 100;

  /// Creates a new instance of the persistence.
  ///
  /// - [loader]    (optional) a loader to load items from external datasource.
  /// - [saver]     (optional) a saver to save items to external datasource.

  MemoryPersistence([ILoader<T>? loader, ISaver<T>? saver]) {
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
  Future open(String? correlationId) async {
    await _load(correlationId);
    opened = true;
  }

  Future _load(String? correlationId) async {
    if (loader == null) {
      return null;
    }

    var items = await loader!.load(correlationId);
    this.items = items;
    logger.trace(correlationId, 'Loaded %d items', [items.length]);
  }

  /// Closes component and frees used resources.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future close(String? correlationId) async {
    await save(correlationId);
    opened = false;
  }

  /// Saves items to external data source using configured saver component.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// Return         (optional) Future that receives error or null for success.
  Future save(String? correlationId) async {
    if (saver == null) {
      return null;
    }

    await saver!.save(correlationId, items);
    logger.trace(correlationId, 'Saved %d items', [items.length]);
  }

  /// Clears component state.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return			Future that receives error or null no errors occured.
  @override
  Future clear(String? correlationId) async {
    items = <T>[];
    logger.trace(correlationId, 'Cleared items');
    await save(correlationId);
  }

  /// Gets a page of data items retrieved by a given filter and sorted according to sort parameters.
  ///
  /// This method shall be called by a public getPageByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// - [sort]              (optional) sorting parameters
  /// - [select]            (optional) projection parameters (not used yet)
  /// Return         Future that receives a data page
  /// Throws error.
  Future<DataPage<T>> getPageByFilterEx(String? correlationId, Function? filter,
      PagingParams? paging, Function? sort,
      [select]) async {
    var items = this.items.toList();

    // Filter and sort
    if (filter != null) {
      items = List<T>.from(items.where((item) => filter(item)));
    }
    if (sort != null) {
      items.sort((a, b) {
        var sa = sort(a);
        var sb = sort(b);
        if (sa > sb) return -1;
        if (sa < sb) return 1;
        return 0;
      });
    }

    // Extract a page
    paging = paging ?? PagingParams();
    var skip = paging.getSkip(-1);
    var take = paging.getTake(maxPageSize);

    var total;
    if (paging.total) {
      total = items.length;
    }

    if (skip > 0) {
      items.removeRange(0, skip <= items.length ? skip : items.length);
    }
    items =
        items.getRange(0, take <= items.length ? take : items.length).toList();

    logger.trace(correlationId, 'Retrieved %d items', [items.length]);

    var page = DataPage<T>(items, total ?? 0);
    return page;
  }

  /// Gets a list of data items retrieved by a given filter and sorted according to sort parameters.
  ///
  /// This method shall be called by a public getListByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [correlationId]    (optional) transaction id to trace execution through call chain.
  /// - [filter]           (optional) a filter function to filter items
  /// - [paging]           (optional) paging parameters
  /// - [sort]             (optional) sorting parameters
  /// - [select]           (optional) projection parameters (not used yet)
  /// Return                Future that receives a data list
  /// Throw  error.
  Future<List<T>> getListByFilterEx(
      String? correlationId, Function? filter, Function? sort, select) async {
    var items = this.items;

    // Apply filter
    if (filter != null) {
      items = List<T>.from(items.where((item) => filter(item)));
    }

    // Apply sorting
    if (sort != null) {
      items.sort((a, b) {
        var sa = sort(a);
        var sb = sort(b);
        if (sa > sb) return -1;
        if (sa < sb) return 1;
        return 0;
      });
    }

    logger.trace(correlationId, 'Retrieved %d items', [items.length]);

    return items;
  }

  /// Gets a random item from items that match to a given filter.
  ///
  /// This method shall be called by a public getOneRandom method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items.
  /// Return         Future that receives a random item
  /// Throw error.
  Future<T?> getOneRandom(String? correlationId, Function? filter) async {
    var items = this.items;

    // Apply filter
    if (filter != null) {
      items = List<T>.from(items.where((item) => filter(item)));
    }

    T? item;
    if (items.isNotEmpty) {
      items.shuffle();
      item = items[0];
    }

    if (item != null) {
      logger.trace(correlationId, 'Retrieved a random item');
    } else {
      logger.trace(correlationId, 'Nothing to return as random item');
    }

    return item;
  }

  /// Deletes data items that match to a given filter.
  ///
  /// This method shall be called by a public deleteByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items.
  /// Return                Future that receives null for success.
  /// Throws error
  Future deleteByFilterEx(String? correlationId, Function filter) async {
    var deleted = 0;
    if (!(filter is Function)) {
      throw Exception('Filter parameter must be a function.');
    }

    for (var index = items.length - 1; index >= 0; index--) {
      var item = items[index];
      if (filter(item)) {
        items.removeAt(index);
        deleted++;
      }
    }

    if (deleted == 0) {
      return null;
    }

    logger.trace(correlationId, 'Deleted %s items', [deleted]);
    await save(correlationId);
  }

  /// Creates a data item.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [item]              an item to be created.
  /// Return         (optional) Future that receives created item or error.
  Future<T?> create(String? correlationId, T item) async {
    var clone_item;
    if (item is ICloneable) {
      clone_item = (item).clone();
    } else {
      var jsonMap = json.decode(json.encode(item));
      clone_item = TypeReflector.createInstanceByType(T, []);
      clone_item.fromJson(jsonMap);
    }

    items.add(clone_item);
    logger.trace(correlationId, 'Created item %s', [clone_item.id]);
    await save(correlationId);
    return clone_item;
  }

  /// Gets a count of data items retrieved by a given filter.
  ///
  /// This method shall be called by a public getCountByFilter method from child class that
  /// receives FilterParams and converts them into a filter function.
  /// - [correlationId]    (optional) transaction id to trace execution through call chain.
  /// - [filter]           (optional) a filter function to filter items
  /// Return                Future that receives a data count
  /// Throw  error.
  Future<int> getCountByFilterEx(
      String? correlationId, Function? filter) async {
    // Filter
    var count = 0;
    if (filter != null) {
      for (var item in items) {
        if (filter(item)) {
          count++;
        }
      }
    }
    logger.trace(correlationId, 'Find %d items', [count]);
    return count;
  }
}
