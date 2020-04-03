// let assert = require('chai').assert;

// import { JsonFilePersister } from '../../src/persistence/JsonFilePersister';
// import { Dummy } from '../Dummy';
// import { ConfigParams } from 'pip-services3-commons-node';
// import { ConfigException } from 'pip-services3-commons-node';

// suite('JsonFilePersister', ()=> {
//     var _persister: JsonFilePersister<Dummy>;

//     setup(function() {
//         _persister = new JsonFilePersister<Dummy>();
//     });

//     test('Configure With No Path Key', () => {
//         try {
//             _persister.configure(new ConfigParams());
//         } catch(ex) {
//             assert.isNotNull(ex);
//             assert.isTrue(ex instanceof ConfigException);
//         }
//     });

//     test('Configure If Path Key Check Property', () => {
//         let fileName: string = "../JsonFilePersisterTest";
//         _persister.configure(ConfigParams.fromTuples("path", fileName));
//         assert.equal(fileName, _persister.path);
//     });

// });