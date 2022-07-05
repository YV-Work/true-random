const {
    ContractFunctionParameters,
    ContractCallQuery,
    ContractId,
    ContractExecuteTransaction
} = require("@hashgraph/sdk");
const {setupClient} = require("./utils/client");
const {eToNumber} = require("./utils/utils");
const {HEDERA: TrueRandomAddress} = require("@yv-work/true-random-sol/js/const");
require("dotenv").config();
let client = setupClient();

/**
 * SDK call query, does not alter RNG state, can return value to SDK
 * @param contractId TrueRandom.sol address on currently used network
 * @param seed Client side seed, solidity addr, uint, string, bytes accepted; later trimmed to 16B
 * @returns {BigNumber} RNG output
 */
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

/**
 * SDK transaction execution, does alter RNG state,
 * used as precaution call, initially designed as inner SC call only
 * @param contractId TrueRandom.sol address on currently used network
 * @param seed Client side seed, solidity addr, uint, string, bytes accepted; later trimmed to 16B
 */
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

/**
 * Refreshes `TrueRandom` state, then proceeds to generate numbers using contract calls instead of transactions
 * @returns void
 */
async function example() {
    // const trueRandomSC = ContractId.fromString(process.env.TRUE_RANDOM); // 0.0.46810017 on testnet, 0.0.3882 on prevnet
    const trueRandomSC = ContractId.fromString(TrueRandomAddress.TESTNET); // 0.0.46810017 on testnet, 0.0.3882 on prevnet
    await setRandomNumber(trueRandomSC, Math.random()); // TrueRandom seed alteration
    for (let i = 0; i < 10; i++) {
        // choose whatever (un)predictable seed is preferred
        const message = await getRandomNumber(trueRandomSC, i);
        console.log(`Random number #${i} from TrueRandom.sol : ${message}`);
    }
}

example();

/**
 * Console output:
 * The create transaction status is SUCCESS
 * Random number #0 from TrueRandom.sol : 18114410647450686485110357129895260126172084019975092813400904323803151357909
 * Random number #1 from TrueRandom.sol : 15380647104406322516357419236604279514135151637637382266167863205190796435377
 * Random number #2 from TrueRandom.sol : 14551374402402427764929039470994222797657133679562236808978439431248646498909
 * Random number #3 from TrueRandom.sol : 44685999415314256626054233382223667584328464289127901779707984818376682088606
 * Random number #4 from TrueRandom.sol : 79640918447752952605557253427072275887503621242604617813163398239923923866371
 * Random number #5 from TrueRandom.sol : 20989148606943352203846146959249585217015664810711387894151566615186086635855
 * Random number #6 from TrueRandom.sol : 113205924085051798296156509342064423938480343000758758719539446691065680515257
 * Random number #7 from TrueRandom.sol : 16456143980664236905686619291558297630576116830819377618735957533993604750707
 * Random number #8 from TrueRandom.sol : 18726669335296204071440488125603256353204012358954528591598301033516150718942
 * Random number #9 from TrueRandom.sol : 15253445182021783825082191044779104807548941218851976250591076738097963084702
 */