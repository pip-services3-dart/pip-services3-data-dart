//  @module persistence 
// import { IIdentifiable } from 'pip-services3-commons-node';
// import { ConfigParams } from 'pip-services3-commons-node';

// import { IdentifiableMemoryPersistence } from './IdentifiableMemoryPersistence';
// import { JsonFilePersister } from './JsonFilePersister'

// 
// /// Abstract persistence component that stores data in flat files
// /// and implements a number of CRUD operations over data items with unique ids.
// /// The data items must implement [[https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/interfaces/data.iidentifiable.html IIdentifiable interface]].
// /// 
// /// In basic scenarios child classes shall only override [[getPageByFilter]],
// /// [[getListByFilter]] or [[deleteByFilter]] operations with specific filter function.
// /// All other operations can be used out of the box. 
// /// 
// /// In complex scenarios child classes can implement additional operations by 
// /// accessing cached items via this._items property and calling [[save]] method
// /// on updates.
// /// 
// /// See [[JsonFilePersister]]
// /// See [[MemoryPersistence]]
// /// 
// /// ### Configuration parameters ###
// /// 
// /// - path:                    path to the file where data is stored
// /// - options:
// ///     - max_page_size:       Maximum number of items returned in a single page (default: 100)
// /// 
// /// ### References ###
// /// 
// /// - <code>\*:logger:\*:\*:1.0</code>       (optional) [[https://rawgit.com/pip-services-node/pip-services3-components-node/master/doc/api/interfaces/log.ilogger.html ILogger]] components to pass log messages
// /// 
// /// ### Examples ###
// /// 
// ///     class MyFilePersistence extends IdentifiableFilePersistence<MyData, string> {
// ///         public constructor(path?: string) {
// ///             super(new JsonPersister(path));
// ///         }
// ///       
// ///         private composeFilter(filter: FilterParams): any {
// ///             filter = filter || new FilterParams();
// ///             let name = filter.getAsNullableString("name");
// ///             return (item) => {
// ///                 if (name != null && item.name != name)
// ///                     return false;
// ///                 return true;
// ///             };
// ///         }
// ///       
// ///         public getPageByFilter(correlationId: string, filter: FilterParams, paging: PagingParams, 
// ///                 callback: (err: any, page: DataPage<MyData>) => void): void {
// ///             super.getPageByFilter(correlationId, this.composeFilter(filter), paging, null, null, callback);
// ///         }
// ///       
// ///     }
// /// 
// ///     let persistence = new MyFilePersistence("./data/data.json");
// ///     
// ///     persistence.create("123", { id: "1", name: "ABC" }, (err, item) => {
// ///         persistence.getPageByFilter(
// ///             "123",
// ///             FilterParams.fromTuples("name", "ABC"),
// ///             null,
// ///             (err, page) => {
// ///                 console.log(page.data);          // Result: { id: "1", name: "ABC" }
// ///     
// ///                 persistence.deleteById("123", "1", (err, item) => {
// ///                     ...
// ///                 });
// ///             }
// ///         )
// ///     });
//  
// export class IdentifiableFilePersistence<T extends IIdentifiable<K>, K> extends IdentifiableMemoryPersistence<T, K> {
//     protected readonly _persister: JsonFilePersister<T>;

//     
//     /// Creates a new instance of the persistence.
//     /// 
//     /// - persister    (optional) a persister component that loads and saves data from/to flat file.
//      
//     public constructor(persister?: JsonFilePersister<T>) {
//         if (persister == null) 
//             persister = new JsonFilePersister<T>();

//         super(persister, persister);

//         this._persister = persister;
//     }

//     
//     /// Configures component by passing configuration parameters.
//     /// 
//     /// - config    configuration parameters to be set.
//      
//     public configure(config: ConfigParams): void {
//         super.configure(config);
//         this._persister.configure(config);
//     }

// }
