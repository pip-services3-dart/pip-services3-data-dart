import 'dart:async';
import 'dart:io';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../ILoader.dart';
import '../ISaver.dart';

/// Persistence component that loads and saves data from/to flat file.
///
/// It is used by [FilePersistence], but can be useful on its own.
///
/// ### Configuration parameters ###
///
/// - [path]:          path to the file where data is stored
///
/// ### Example ###
///
///     var persister = JsonFilePersister("./data/data.json");
///
///     await persister.save("123", ["A", "B", "C"]);
///         ...
///     var items = await persister.load("123");
///     print(items);  // Result: ["A", "B", "C"]
///

class JsonFilePersister<T> implements ILoader<T>, ISaver<T>, IConfigurable {
  String? path_;

  /// Creates a new instance of the persistence.
  ///
  /// - [path]  (optional) a path to the file where data is stored.

  JsonFilePersister([String? path]) {
    path_ = path;
  }

  /// Gets the file path where data is stored.
  ///
  /// Return the file path where data is stored.
  String? get path {
    return path_;
  }

  /// Sets the file path where data is stored.
  ///
  /// - [value]     the file path where data is stored.
  set path(String? value) {
    path_ = value;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    path = config.getAsNullableString('path') ?? path;
  }

  /// Loads data items from external JSON file.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// Return         Future that receives loaded items
  /// Throws error.
  @override
  Future<List<T>> load(String? correlation_id) async {
    if (path == null || path == '') {
      throw ConfigException(null, 'NO path', 'Data file path is not set');
    }

    var file = File(path!);

    if (!file.existsSync()) {
      return <T>[];
    }

    try {
      var json = file.readAsStringSync();
      var list = JsonConverter.toNullableMap(json);
      var arr = ArrayConverter.listToArray(list);

      try {
        var objectsList = arr.map((item) {
          var obj = TypeReflector.createInstanceByType(T, []);
          obj.fromJson(item);
          return obj as T;
        }).toList();

        return objectsList;
      } on NoSuchMethodError {
        throw Exception('Data class must have fromJson method for conversions');
      }
    } catch (ex) {
      var err = FileException(correlation_id, 'READ_FAILED',
              'Failed to read data file: ' + path.toString())
          .withCause(ex);
      throw err;
    }
  }

  /// Saves given data items to external JSON file.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [items]             list if data items to save
  /// Return         Future that error or null for success.
  @override
  Future save(String? correlation_id, List<T?> items) async {
    try {
      var json = JsonConverter.toJson(items);
      File(path!).writeAsStringSync(json!);
      return null;
    } catch (ex) {
      var err = FileException(correlation_id, 'WRITE_FAILED',
              'Failed to write data file: ' + path.toString())
          .withCause(ex);
      throw err;
    }
  }
}
