// import { FilterParams } from 'pip-services3-commons-node';
// import { PagingParams } from 'pip-services3-commons-node';
// import { DataPage } from 'pip-services3-commons-node';

// import { IdentifiableMemoryPersistence } from '../../src/persistence/IdentifiableMemoryPersistence';
// import { Dummy } from '../Dummy';
// import { IDummyPersistence } from '../IDummyPersistence';

// export class DummyMemoryPersistence 
//     extends IdentifiableMemoryPersistence<Dummy, string> 
//     implements IDummyPersistence {

//     public constructor() {
//         super();
//     }

//     public getPageByFilter(correlationId: string, filter: FilterParams, paging: PagingParams, 
//         callback: (err: any, page: DataPage<Dummy>) => void): void {

//         filter = filter != null ? filter : new FilterParams();
//         let key = filter.getAsNullableString("key");

//         super.getPageByFilter(correlationId, (item) => {
//             if (key != null && item.key != key)
//                 return false;
//             return true;
//         }, paging, null, null, callback);
//     }
// }