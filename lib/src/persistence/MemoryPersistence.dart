//  @module persistence 
// import { IReferenceable } from 'pip-services3-commons-node';
// import { IReferences } from 'pip-services3-commons-node';
// import { IOpenable } from 'pip-services3-commons-node';
// import { ICleanable } from 'pip-services3-commons-node';
// import { CompositeLogger } from 'pip-services3-components-node';

// import { ILoader } from '../ILoader';
// import { ISaver } from '../ISaver';

// 
// /// Abstract persistence component that stores data in memory.
// /// 
// /// This is the most basic persistence component that is only
// /// able to store data items of any type. Specific CRUD operations
// /// over the data items must be implemented in child classes by
// /// accessing <code>this._items</code> property and calling [[save]] method.
// /// 
// /// The component supports loading and saving items from another data source.
// /// That allows to use it as a base class for file and other types
// /// of persistence components that cache all data in memory. 
// /// 
// /// ### References ###
// /// 
// /// - <code>\*:logger:\*:\*:1.0</code>       (optional) [[https://rawgit.com/pip-services-node/pip-services3-components-node/master/doc/api/interfaces/log.ilogger.html ILogger]] components to pass log messages
// /// 
// /// ### Example ###
// /// 
// ///     class MyMemoryPersistence extends MemoryPersistence<MyData> {
// ///          
// ///         public getByName(correlationId: string, name: string, callback: (err, item) => void): void {
// ///             let item = _.find(this._items, (d) => d.name == name);
// ///             callback(null, item);
// ///         }); 
// ///       
// ///         public set(correlatonId: string, item: MyData, callback: (err) => void): void {
// ///             this._items = _.filter(this._items, (d) => d.name != name);
// ///             this._items.push(item);
// ///             this.save(correlationId, callback);
// ///         }
// ///       
// ///     }
// /// 
// ///     let persistence = new MyMemoryPersistence();
// ///     
// ///     persistence.set("123", { name: "ABC" }, (err) => {
// ///         persistence.getByName("123", "ABC", (err, item) => {
// ///             console.log(item);                   // Result: { name: "ABC" }
// ///         });
// ///     });
//  
// export class MemoryPersistence<T> implements IReferenceable, IOpenable, ICleanable {
//     protected _logger: CompositeLogger = new CompositeLogger();
//     protected _items: T[] = [];
//     protected _loader: ILoader<T>;
//     protected _saver: ISaver<T>;
//     protected _opened: boolean = false;

//     
//     /// Creates a new instance of the persistence.
//     /// 
//     /// - loader    (optional) a loader to load items from external datasource.
//     /// - saver     (optional) a saver to save items to external datasource.
//      
//     public constructor(loader?: ILoader<T>, saver?: ISaver<T>) {
//         this._loader = loader;
//         this._saver = saver;
//     }

//     
// 	/// Sets references to dependent components.
// 	/// 
// 	/// - references 	references to locate the component dependencies. 
//      
//     public setReferences(references: IReferences): void {
//         this._logger.setReferences(references);
//     }

//     
// 	/// Checks if the component is opened.
// 	/// 
// 	/// @returns true if the component has been opened and false otherwise.
//      
//     public isOpen(): boolean {
//         return this._opened;
//     }

//     
// 	/// Opens the component.
// 	/// 
// 	/// - correlationId 	(optional) transaction id to trace execution through call chain.
//     /// Return			Future that receives error or null no errors occured.
//      
//     public open(correlationId: string,  callback?: (err: any) => void): void {
//         this.load(correlationId, (err) => {
//             this._opened = true;
//             if (callback) callback(err);
//         });
//     }

//     private load(correlationId: string, callback?: (err: any) => void): void {
//         if (this._loader == null) {
//             if (callback) callback(null);
//             return;
//         }
            
//         this._loader.load(correlationId, (err: any, items: T[]) => {
//             if (err == null) {
//                 this._items = items;
//                 this._logger.trace(correlationId, "Loaded %d items", this._items.length);
//             }
//             if (callback) callback(err);
//         });
//     }

//     
// 	/// Closes component and frees used resources.
// 	/// 
// 	/// - correlationId 	(optional) transaction id to trace execution through call chain.
//     /// Return			Future that receives error or null no errors occured.
//      
//     public close(correlationId: string, callback?: (err: any) => void): void {
//         this.save(correlationId, (err) => {
//             this._opened = false;
            
//             if (callback) callback(err);
//         });
//     }

//     
//     /// Saves items to external data source using configured saver component.
//     /// 
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// Return         (optional) Future that receives error or null for success.
//      
//     public save(correlationId: string, callback?: (err: any) => void): void {
//         if (this._saver == null) {
//             if (callback) callback(null);
//             return;
//         }

//         let task = this._saver.save(correlationId, this._items, (err: any) => {
//             if (err == null)
//                 this._logger.trace(correlationId, "Saved %d items", this._items.length);

//             if (callback) callback(err);
//         });
//     }

//     
// 	/// Clears component state.
// 	/// 
// 	/// - correlationId 	(optional) transaction id to trace execution through call chain.
//     /// Return			Future that receives error or null no errors occured.
//      
//     public clear(correlationId: string, callback?: (err?: any) => void): void {
//         this._items = [];
//         this._logger.trace(correlationId, "Cleared items");
//         this.save(correlationId, callback);
//     }

// }
