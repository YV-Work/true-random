const {
    ContractFunctionParameters,
    ContractCallQuery,
    ContractId,
    ContractExecuteTransaction
} = require("@hashgraph/sdk");
const {setupClient} = require("./utils/client");
const {eToNumber} = require("./utils/utils");
require("dotenv").config();
let client;
client = setupClient();

async function getRandomNumber(contractId, seed) {
    const contractQuery = await new ContractCallQuery()
        .setGas(30000)
        .setContractId(contractId)
        .setFunction("get",
            new ContractFunctionParameters().addString( seed.toString())
        )
    ;
    //Submit to a Hedera network
    const getMessage = await contractQuery.execute(client);
    // Get an RNG uint from the result at index 0
    return eToNumber(getMessage.getInt256(0));
}

async function setRandomNumber(contractId, seed) {
    const contractQuery = await new ContractExecuteTransaction()
        .setGas(60000)
        .setContractId(contractId)
        .setFunction("create",
            new ContractFunctionParameters().addString(seed.toString())
        );
    const submitExecTx = await contractQuery.execute(client);
    const receipt = await submitExecTx.getReceipt(client);
    console.log("The create transaction status is " +receipt.status.toString());
}

async function example() {
    const trueRandomSC = ContractId.fromString(process.env.TRUE_RANDOM);
    await setRandomNumber(trueRandomSC, Math.random());
    for (let i = 0; i < 10; i++) {
        // choose whatever (un)predictable seed is preferred
        const message = await getRandomNumber(trueRandomSC, i);
        console.log(`Random number #${i} from TrueRandom.sol : ${message}`);
    }
}

example();