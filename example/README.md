# Examples for Components

This package contains various design patterns for working with data and provides implementation of 
reusable data processing and persistence components:

- **MemoryPersistence**
* Example:

```dart
     class MyMemoryPersistence extends MemoryPersistence<MyData> {

        Future<MyData> getByName(String correlationId, String name) async {
             var item = _.find(items, (d) => d.name == name);
            return item;
         });

         Future<MyData> set(String correlatonId, MyData item) async {
             items = _.filter(items, (d) => d.name != name);
             items.add(item);
             await save(correlationId);
             return item;
         }
     }

     var persistence = MyMemoryPersistence();

     persistence.set("123", { name: "ABC" })
     var item = await persistence.getByName("123", "ABC")
     print(item);                   // Result: { name: "ABC" }

```

- **IdentifiableMemoryPersistence**
* Example:

```dart
class DummyMemoryPersistence
    extends IdentifiableMemoryPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyMemoryPersistence() : super();

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      String correlationId, filter, PagingParams paging) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    return super.getPageByFilterEx(correlationId, (Dummy item) {
      if (key != null && item.key != key) {
        return false;
      }
      return true;
    }, paging, null, null);
  }
}
```

- **FilePersistence**
* Example:

``` dart
     class MyJsonFilePersistence extends FilePersistence<MyData> {
        MyJsonFilePersistence([String path]) : super(JsonPersister(path)){
        }

        Future<MyData> getByName(String correlationId, String name) async {
             var item = _.find(items, (d) => d.name == name);
             return item;
        });
        @override
        Future<MyData> set(String correlatonId, MyData item) {
             items = List.from(item.where((d) => d.name != name));
             items.add(item);
             await save(correlationId);
             return item;
        }
    }

```

- **IdentifiableFilePersistence**
* Example:

```dart
     class MyFilePersistence extends IdentifiableFilePersistence<MyData, String> {
         MyFilePersistence([String path]):super(JsonPersister(path)) {
         }

         dynamic _composeFilter(FilterParams filter) {
             filter = filter ?? FilterParams();
             var name = filter.getAsNullableString("name");
             return (item) {
                 if (name != null && item.name != name)
                     return false;
                 return true;
             };
         }

         Future<DataPage<MyData>> getPageByFilter(string correlationId, FilterParams filter, PagingParams paging){
            return super.getPageByFilter(correlationId, _composeFilter(filter), paging, null, null);
         }

     }

     var persistence = MyFilePersistence("./data/data.json");

     await persistence.create("123", { id: "1", name: "ABC" });
     var page = await persistence.getPageByFilter(
             "123",
             FilterParams.fromTuples([
                 "name", "ABC"
             ]),
             null);
             
     print(page.data);          // Result: { id: "1", name: "ABC" }

     var item = await persistence.deleteById("123", "1");

```

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services3-dart/pip-services3-data-dart/tree/master/test).
