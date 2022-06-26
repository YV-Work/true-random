const {
    ContractCallQuery,
    ContractId,
    ContractExecuteTransaction
} = require("@hashgraph/sdk");
const {setupClient} = require("./utils/client");
const {eToNumber} = require("./utils/utils");
require("dotenv").config();
const client = setupClient();

/**
 * Alternative usage to example.js
 * The JS SDK calls to an ExampleSDK.sol SC which queries and stores RNG from TrueRandom
 * for use across entire app, be it set of smart contracts or SDK off-chain logic
 * @param contractId ExampleSDK.sol address (true-random/examples/Solidity/ExampleSDK.sol)
 * @returns {BigNumber} 32B RNG
 */
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

/**
 * Downside of such logic is cost inefficiency + execution time
 * However, in real dapp usecases you are unlikely to encounter
 * a need to generate 320B of Random numbers...
 * @returns void
 */
async function example() {
    const exampleSDK = ContractId.fromString(process.env.EXAMPLE_SDK_SC); // 0.0.46813450 on Testnet
    let message;
    for (let i = 0; i < 10; i++) {
        message = await getNewNumber(exampleSDK);
        console.log(`Random number #${i} from ExampleSDK.sol : ${message}`);
    }
}

example();