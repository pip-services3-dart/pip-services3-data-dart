//  @module persistence 
//  @hidden 
// const fs = require('fs');

// import { IConfigurable } from 'pip-services3-commons-node';
// import { ConfigParams } from 'pip-services3-commons-node';
// import { ConfigException } from 'pip-services3-commons-node';
// import { FileException } from 'pip-services3-commons-node';
// import { JsonConverter } from 'pip-services3-commons-node';
// import { ArrayConverter } from 'pip-services3-commons-node';

// import { ILoader } from '../ILoader';
// import { ISaver } from '../ISaver';

// 
// /// Persistence component that loads and saves data from/to flat file.
// /// 
// /// It is used by [[FilePersistence]], but can be useful on its own.
// /// 
// /// ### Configuration parameters ###
// /// 
// /// - path:          path to the file where data is stored
// /// 
// /// ### Example ###
// /// 
// ///     let persister = new JsonFilePersister("./data/data.json");
// ///     
// ///     persister.save("123", ["A", "B", "C"], (err) => {
// ///         ...
// ///         persister.load("123", (err, items) => {
// ///             console.log(items);                      // Result: ["A", "B", "C"]
// ///         });
// ///     });
//  
// export class JsonFilePersister<T> implements ILoader<T>, ISaver<T>, IConfigurable {
//     private _path: string;

//     
//     /// Creates a new instance of the persistence.
//     /// 
//     /// - path  (optional) a path to the file where data is stored.
//      
//     public constructor(path?: string) {
//         this._path = path;
//     }

//     
//     /// Gets the file path where data is stored.
//     /// 
//     /// @returns the file path where data is stored.
//      
//     public get path(): string {
//         return this._path;
//     }

//     
//     /// Sets the file path where data is stored.
//     /// 
//     /// - value     the file path where data is stored.
//      
//     public set path(value: string) {
//         this._path = value;
//     }

//     
//     /// Configures component by passing configuration parameters.
//     /// 
//     /// - config    configuration parameters to be set.
//      
//     public configure(config: ConfigParams): void {
//         this._path = config.getAsStringWithDefault("path", this._path);
//     }

//     
//     /// Loads data items from external JSON file.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// Return         Future that receives loaded items or error.
//      
//     public load(correlation_id: string, callback: (err: any, data: T[]) => void): void {
//         if (this._path == null) {
//             callback(new ConfigException(null, "NO_PATH", "Data file path is not set"), null);
//             return;
//         }

//         if (!fs.existsSync(this._path)) {
//             callback(null, []);
//             return;
//         }

//         try {
//             let json: any = fs.readFileSync(this._path, "utf8");
//             let list = JsonConverter.toNullableMap(json);
//             let arr = ArrayConverter.listToArray(list);

//             callback(null, arr);
//         } catch (ex) {
//             let err = new FileException(correlation_id, "READ_FAILED", "Failed to read data file: " + this._path)
//                 .withCause(ex);

//             callback(err, null);
//         }
//     }

//     
//     /// Saves given data items to external JSON file.
//     /// 
//     /// - correlation_id    (optional) transaction id to trace execution through call chain.
//     /// - items             list if data items to save
//     /// Return         Future that error or null for success.
//      
//     public save(correlation_id: string, items: T[], callback?: (err: any) => void): void {
//         try {
//             let json = JsonConverter.toJson(items);
//             fs.writeFileSync(this._path, json);
//             if (callback) callback(null);
//         } catch (ex) {
//             let err = new FileException(correlation_id, "WRITE_FAILED", "Failed to write data file: " + this._path)
//                 .withCause(ex);

//             if (callback) callback(err);
//             else throw err;
//         }
//     }

// }
