// import { ConfigParams } from 'pip-services3-commons-node';
// import { Dummy } from '../Dummy';
// import { DummyPersistenceFixture } from '../DummyPersistenceFixture';
// import { DummyFilePersistence } from './DummyFilePersistence';

// suite('DummyFilePersistence', ()=> {    
//     let persistence: DummyFilePersistence;
//     let fixture: DummyPersistenceFixture;
 
//     setup(function(done) {
//         persistence = new DummyFilePersistence('./data/dummies.json');

//         fixture = new DummyPersistenceFixture(persistence);

//         persistence.open(null, (err) => {
//             if (err) done(err);
//             else persistence.clear(null, done);
//         });
//     });
    
//     teardown((done) => {
//         persistence.close(null, done);
//     });

//     test('Crud Operations', (done) => {
//         fixture.testCrudOperations(done);
//     });

//     test('Batch Operations', (done) => {
//         fixture.testBatchOperations(done);
//     });
// });