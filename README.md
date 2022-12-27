# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Persistence components for Dart

This module is a part of the [Pip.Services](http://pipservices.org) polyglot microservices toolkit. It contains generic interfaces for data access components as well as abstract implementations for in-memory and file persistence.

The persistence components come in two kinds. The first kind is a basic persistence that can work with any object types and provides only minimal set of operations. 
The second kind is so called "identifieable" persistence with works with "identifable" data objects, i.e. objects that have unique ID field. The identifiable persistence provides a full set or CRUD operations that covers most common cases.

The module contains the following packages:
- **Core** - generic interfaces for data access components. 
- **Persistence** - in-memory and file persistence components, as well as JSON persister class.

<a name="links"></a> Quick links:

* [Memory persistence](https://www.pipservices.org/recipies/memory-persistence)
* [API Reference](https://pub.dev/documentation/pip_services3_data/latest/pip_services3_data/pip_services3_data-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)


* Warning! For the library to work correctly, the stored type must have a default costructor without parameters, as well as methods for converting from/to JSON.

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services3_data: version
```

Now you can install package from the command line:
```bash
pub get
```

For example, you need to implement persistence for a data object defined as following.

```dart
import 'package:pip_services3_commons/src/data/IIdentifiable.dart';

class MyObject implements IIdentifiable<String> {
  @override
  String? id;
  String key;
  String value;

  Dummy({String? id, String key, String value})
      : id = id,
        key = key,
        content = content;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    content = json['content'];
  }
}

```

Our persistence component shall implement the following interface with a basic set of CRUD operations.

```dart
abstract class IMyPersistence {
    void getPageByFilter(String correlationId, FilterParams filter, PagingParams paging);
    
    getOneById(String correlationId, String id);
    
    getOneByKey(String correlationId, String key;
    
    create(String correlationId, MyObject item);
    
    update(String correlationId, MyObject item);
    
    deleteById(String correlationId, String id);
}
```

To implement in-memory persistence component you shall inherit `IdentifiableMemoryPersistence`. 
Most CRUD operations will come from the base class. You only need to override `getPageByFilter` method with a custom filter function.
And implement a `getOneByKey` custom persistence method that doesn't exist in the base class.

```dart
import 'package:pip_services3_data/src/persistence/IdentifiableMemoryPersistence.dart';
import 'package:pip_services3_commons/src/data/FilterParams.dart';
import 'package:pip_services3_commons/src/data/PagingParams.dart';

class MyMemoryPersistence extends IdentifiableMemoryPersistence {
  MyMemoryPersistence(): super() {}

  composeFilter(FilterParams filter) {
    filter = filter != null ? filter : FilterParams();
    
    String id = filter.getAsNullableString("id");
    String tempIds = filter.getAsNullableString("ids");
    List<String> ids = tempIds != null ? tempIds.split(",") : null;
    String key = filter.getAsNullableString("key");

    return (item) {
      if (id != null && item.id != id)
        return false;
      if (ids != null && ids.indexOf(item.id) < 0)
        return false;
      if (key != null && item.key != key)
            return false;
      return true;
    };
  }
  
  Future<DataPage<MyData>> getPageByFilter(String correlationId, FilterParams filter, PagingParams paging){
    return super.getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }  
  
  Future<String> getOneByKey(String correlationId, String key) {
    
    final item =
      this._items.firstWhere((item) =>
          item.name == item.key == key,
          orElse: () {
            return null;
    });
    
    if (item != null) {
      this._logger.trace(correlationId, "Found object by key=%s", key);
    } else {
      this._logger.trace(correlationId, "Cannot find by key=%s", key);
    }
  }
}
```

It is easy to create file persistence by adding a persister object to the implemented in-memory persistence component.

```dart
import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_data/src/persistence/JsonFilePersister.dart';


class MyFilePersistence extends MyMemoryPersistence {
  JsonFilePersister<MyObject> _persister;

  MyFilePersistence([String path]):super(){
    this._persister = new JsonFilePersister<MyObject>(path);
    this._loader = this._persister;
    this._saver = this._persister;
  }

  configure(ConfigParams config) {
      super.configure(config);
      this._persister.configure(config);
  }
}
```

## Develop

For development you shall install the following prerequisites:
* Dart SDK 2
* Visual Studio Code or another IDE of your choice
* Docker

Install dependencies:
```bash
pub get
```

Run automated tests:
```bash
pub run test
```

Generate API documentation:
```bash
./docgen.ps1
```

Before committing changes run dockerized build and test as:
```bash
./build.ps1
./test.ps1
./clear.ps1
```

## Contacts

The Dart version of Pip.Services is created and maintained by:
- **Sergey Seroukhov**
- **Levichev Dmitry**

The documentation is written by:
- **Levichev Dmitry**