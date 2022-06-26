const {
    ContractCallQuery,
    ContractId,
    ContractExecuteTransaction
} = require("@hashgraph/sdk");
const {setupClient} = require("./utils/client");
const {eToNumber} = require("./utils/utils");
require("dotenv").config();
let client;
client = setupClient();

async function getNewNumber(contractId) {
    const contractQuery = new ContractExecuteTransaction()
        .setGas(60000)
        .setContractId(contractId)
        .setFunction("setRNG");
    const submitExecTx = await contractQuery.execute(client);
    await submitExecTx.getReceipt(client);
    // const receipt2 = await submitExecTx.getReceipt(client);
    // console.log("New number generation " +receipt2.status.toString());
    const contractQuery2 = new ContractCallQuery()
        .setGas(30000)
        .setContractId(contractId)
        .setFunction("getRNG")
    ;
    const getMessage = await contractQuery2.execute(client);
    return eToNumber(getMessage.getInt256(0));
}

async function example() {
    const exampleSDK = ContractId.fromString(process.env.EXAMPLE_SDK_SC);
    let message;
    for (let i = 0; i < 10; i++) {
        message = await getNewNumber(exampleSDK);
        console.log(`Random number #${i} from ExampleSDK.sol : ${message}`);
    }
}

example();