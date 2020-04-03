//  @module persistence 
//  @hidden 
// let _ = require('lodash');

// import { IIdentifiable } from 'pip-services3-commons-node';
// import { IConfigurable } from 'pip-services3-commons-node';
// import { ConfigParams } from 'pip-services3-commons-node';
// import { PagingParams } from 'pip-services3-commons-node';
// import { DataPage } from 'pip-services3-commons-node';
// import { AnyValueMap } from 'pip-services3-commons-node';
// import { ObjectWriter } from 'pip-services3-commons-node';
// import { IdGenerator } from 'pip-services3-commons-node';

// import { MemoryPersistence } from './MemoryPersistence';
// import { IWriter } from '../IWriter';
// import { IGetter } from '../IGetter';
// import { ISetter } from '../ISetter';
// import { ILoader } from '../ILoader';
// import { ISaver } from '../ISaver';

// 
// /// Abstract persistence component that stores data in memory
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
// /// @see [[MemoryPersistence]]
// /// 
// /// ### Configuration parameters ###
// /// 
// /// - options:
// ///     - max_page_size:       Maximum number of items returned in a single page (default: 100)
// /// 
// /// ### References ###
// /// 
// /// - <code>\*:logger:\*:\*:1.0</code>     (optional) [[https://rawgit.com/pip-services-node/pip-services3-components-node/master/doc/api/interfaces/log.ilogger.html ILogger]] components to pass log messages
// /// 
// /// ### Examples ###
// /// 
// ///     class MyMemoryPersistence extends IdentifiableMemoryPersistence<MyData, string> {
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
// ///     let persistence = new MyMemoryPersistence();
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
// export class IdentifiableMemoryPersistence<T extends IIdentifiable<K>, K> extends MemoryPersistence<T> 
//     implements IConfigurable, IWriter<T, K>, IGetter<T, K>, ISetter<T> {
//     protected _maxPageSize: number = 100;

//     
//     /// Creates a new instance of the persistence.
//     /// 
//     /// - loader    (optional) a loader to load items from external datasource.
//     /// - saver     (optional) a saver to save items to external datasource.
//      
//     public constructor(loader?: ILoader<T>, saver?: ISaver<T>) {
//         super(loader, saver);
//     }

//     
//     /// Configures component by passing configuration parameters.
//     /// 
//     /// - config    configuration parameters to be set.
//      
//     public configure(config: ConfigParams): void {
//         this._maxPageSize = config.getAsIntegerWithDefault("options.max_page_size", this._maxPageSize);
//     }

//     
//     /// Gets a page of data items retrieved by a given filter and sorted according to sort parameters.
//     /// 
//     /// This method shall be called by a public getPageByFilter method from child class that
//     /// receives FilterParams and converts them into a filter function.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - filter            (optional) a filter function to filter items
//     /// - paging            (optional) paging parameters
//     /// - sort              (optional) sorting parameters
//     /// - select            (optional) projection parameters (not used yet)
//     /// Return         Future that receives a data page or error.
//      
//     protected getPageByFilter(correlationId: string, filter: any, 
//         paging: PagingParams, sort: any, select: any, 
//         callback: (err: any, page: DataPage<T>) => void): void {
        
//         let items = this._items;

//         // Filter and sort
//         if (_.isFunction(filter))
//             items = _.filter(items, filter);
//         if (_.isFunction(sort))
//             items = _.sortUniqBy(items, sort);

//         // Extract a page
//         paging = paging != null ? paging : new PagingParams();
//         let skip = paging.getSkip(-1);
//         let take = paging.getTake(this._maxPageSize);

//         let total = null;
//         if (paging.total)
//             total = items.length;
        
//         if (skip > 0)
//             items = _.slice(items, skip);
//         items = _.take(items, take);
        
//         this._logger.trace(correlationId, "Retrieved %d items", items.length);
        
//         let page = new DataPage<T>(items, total);
//         callback(null, page);
//     }

//     
//     /// Gets a list of data items retrieved by a given filter and sorted according to sort parameters.
//     /// 
//     /// This method shall be called by a public getListByFilter method from child class that
//     /// receives FilterParams and converts them into a filter function.
//     /// 
//     /// - correlationId    (optional) transaction id to trace execution through call chain.
//     /// - filter           (optional) a filter function to filter items
//     /// - paging           (optional) paging parameters
//     /// - sort             (optional) sorting parameters
//     /// - select           (optional) projection parameters (not used yet)
//     /// Return        Future that receives a data list or error.
//      
//     protected getListByFilter(correlationId: string, filter: any, sort: any, select: any,
//         callback: (err: any, items: T[]) => void): void {
        
//         let items = this._items;

//         // Apply filter
//         if (_.isFunction(filter))
//             items = _.filter(items, filter);

//         // Apply sorting
//         if (_.isFunction(sort))
//             items = _.sortUniqBy(items, sort);
        
//         this._logger.trace(correlationId, "Retrieved %d items", items.length);
        
//         callback(null, items);
//     }

//     
//     /// Gets a list of data items retrieved by given unique ids.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - ids               ids of data items to be retrieved
//     /// Return        Future that receives a data list or error.
//      
//     public getListByIds(correlationId: string, ids: K[],
//         callback: (err: any, items: T[]) => void): void {
//         let filter = (item: T) => {
//             return _.indexOf(ids, item.id) >= 0;
//         }
//         this.getListByFilter(correlationId, filter, null, null, callback);
//     }

//     
//     /// Gets a random item from items that match to a given filter.
//     /// 
//     /// This method shall be called by a public getOneRandom method from child class that
//     /// receives FilterParams and converts them into a filter function.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - filter            (optional) a filter function to filter items.
//     /// Return         Future that receives a random item or error.
//      
//     protected getOneRandom(correlationId: string, filter: any, callback: (err: any, item: T) => void): void {
//         let items = this._items;

//         // Apply filter
//         if (_.isFunction(filter))
//             items = _.filter(items, filter);

//         let item: T = items.length > 0 ? _.sample(items) : null;
        
//         if (item != null)
//             this._logger.trace(correlationId, "Retrieved a random item");
//         else
//             this._logger.trace(correlationId, "Nothing to return as random item");
                        
//         callback(null, item);
//     }

//     
//     /// Gets a data item by its unique id.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - id                an id of data item to be retrieved.
//     /// Return         Future that receives data item or error.
//      
//     public getOneById(correlationId: string, id: K, callback: (err: any, item: T) => void): void {
//         let items = this._items.filter((x) => {return x.id == id;});
//         let item = items.length > 0 ? items[0] : null;

//         if (item != null)
//             this._logger.trace(correlationId, "Retrieved item %s", id);
//         else
//             this._logger.trace(correlationId, "Cannot find item by %s", id);

//         callback(null, item);
//     }

//     
//     /// Creates a data item.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// - item              an item to be created.
//     /// Return         (optional) Future that receives created item or error.
//      
//     public create(correlationId: string, item: T, callback?: (err: any, item: T) => void): void {
//         item = _.clone(item);
//         if (item.id == null)
//             ObjectWriter.setProperty(item, "id", IdGenerator.nextLong());

//         this._items.push(item);
//         this._logger.trace(correlationId, "Created item %s", item.id);

//         this.save(correlationId, (err) => {
//             if (callback) callback(err, item)
//         });
//     }

//     
//     /// Sets a data item. If the data item exists it updates it,
//     /// otherwise it create a new data item.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// - item              a item to be set.
//     /// Return         (optional) Future that receives updated item or error.
//      
//     public set(correlationId: string, item: T, callback?: (err: any, item: T) => void): void {
//         item = _.clone(item);
//         if (item.id == null)
//             ObjectWriter.setProperty(item, "id", IdGenerator.nextLong());

//         let index = this._items.map((x) => { return x.id; }).indexOf(item.id);

//         if (index < 0) this._items.push(item);
//         else this._items[index] = item;

//         this._logger.trace(correlationId, "Set item %s", item.id);

//         this.save(correlationId, (err) => {
//             if (callback) callback(err, item)
//         });
//     }

//     
//     /// Updates a data item.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// - item              an item to be updated.
//     /// Return         (optional) Future that receives updated item or error.
//      
//     public update(correlationId: string, item: T, callback?: (err: any, item: T) => void): void {
//         let index = this._items.map((x) => { return x.id; }).indexOf(item.id);

//         if (index < 0) {
//             this._logger.trace(correlationId, "Item %s was not found", item.id);
//             callback(null, null);
//             return;
//         }

//         item = _.clone(item);
//         this._items[index] = item;
//         this._logger.trace(correlationId, "Updated item %s", item.id);

//         this.save(correlationId, (err) => {
//             if (callback) callback(err, item)
//         });
//     }

//     
//     /// Updates only few selected fields in a data item.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// - id                an id of data item to be updated.
//     /// - data              a map with fields to be updated.
//     /// Return         Future that receives updated item or error.
//      
//     public updatePartially(correlationId: string, id: K, data: AnyValueMap,
//         callback?: (err: any, item: T) => void): void {
            
//         let index = this._items.map((x) => { return x.id; }).indexOf(id);

//         if (index < 0) {
//             this._logger.trace(correlationId, "Item %s was not found", id);
//             callback(null, null);
//             return;
//         }

//         let item: any = this._items[index];
//         item = _.extend(item, data.getAsObject())
//         this._items[index] = item;
//         this._logger.trace(correlationId, "Partially updated item %s", id);

//         this.save(correlationId, (err) => {
//             if (callback) callback(err, item)
//         });
//     }

//     
//     /// Deleted a data item by it's unique id.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// - id                an id of the item to be deleted
//     /// Return         (optional) Future that receives deleted item or error.
//      
//     public deleteById(correlationId: string, id: K, callback?: (err: any, item: T) => void): void {
//         var index = this._items.map((x) => { return x.id; }).indexOf(id);
//         var item = this._items[index];

//         if (index < 0) {
//             this._logger.trace(correlationId, "Item %s was not found", id);
//             callback(null, null);
//             return;
//         }

//         this._items.splice(index, 1);
//         this._logger.trace(correlationId, "Deleted item by %s", id);

//         this.save(correlationId, (err) => {
//             if (callback) callback(err, item)
//         });
//     }

//     
//     /// Deletes data items that match to a given filter.
//     /// 
//     /// This method shall be called by a public deleteByFilter method from child class that
//     /// receives FilterParams and converts them into a filter function.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - filter            (optional) a filter function to filter items.
//     /// Return         (optional) Future that receives error or null for success.
//      
//     protected deleteByFilter(correlationId: string, filter: any, callback?: (err: any) => void): void {
//         let deleted = 0;
//         for (let index = this._items.length - 1; index>= 0; index--) {
//             let item = this._items[index];
//             if (filter(item)) {
//                 this._items.splice(index, 1);
//                 deleted++;
//             }
//         }

//         if (deleted == 0) {
//             callback(null);
//             return;
//         }

//         this._logger.trace(correlationId, "Deleted %s items", deleted);

//         this.save(correlationId, (err) => {
//             if (callback) callback(err)
//         });
//     }

//     
//     /// Deletes multiple data items by their unique ids.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - ids               ids of data items to be deleted.
//     /// Return         (optional) Future that receives error or null for success.
//      
//     public deleteByIds(correlationId: string, ids: K[], callback?: (err: any) => void): void {
//         let filter = (item: T) => {
//             return _.indexOf(ids, item.id) >= 0;
//         }
//         this.deleteByFilter(correlationId, filter, callback);
//     }

// }
