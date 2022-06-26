const {
    PrivateKey, FileCreateTransaction, FileAppendTransaction, ContractCreateTransaction
} = require("@hashgraph/sdk");
const {setupClient} = require("./client");
require("dotenv").config();
const treasuryKey = PrivateKey.fromString(process.env.TREASURY_PKEY);
let client;

async function setupByteCode(src) {
    let fileLocal = require(src); // check file exists
    return fileLocal.data.bytecode.object; //return bytecode
}

/**
 * Uploads SmartContract.json bytecode on Hedera
 * @param bytecode SC bytecode from abi
 * @returns file ID on Hedera Network
 */
async function uploadByteCode(bytecode) {
    const fileCreateTx = new FileCreateTransaction().setKeys([treasuryKey]).freezeWith(client);
    const fileCreateSign = await fileCreateTx.sign(treasuryKey);
    const fileCreateSubmit = await fileCreateSign.execute(client);
    const fileCreateRx = await fileCreateSubmit.getReceipt(client);
    const bytecodeFileId = fileCreateRx.fileId;
    console.log(`- The smart contract bytecode file ID is ${bytecodeFileId}`);

    // Append contents to the file
    const fileAppendTx = new FileAppendTransaction()
        .setFileId(bytecodeFileId)
        .setContents(bytecode)
        .setMaxChunks(15)
        .freezeWith(client);
    const fileAppendSign = await fileAppendTx.sign(treasuryKey);
    const fileAppendSubmit = await fileAppendSign.execute(client);
    const fileAppendRx = await fileAppendSubmit.getReceipt(client);
    console.log(`- Content added: ${fileAppendRx.status} \n`);

    console.log(`upload finished`);
    return bytecodeFileId;
}

/**
 * Register SC on Hedera
 * @param bytecodeFileID bytecode of SC to reg on Hedera Network
 * @returns void
 */
async function createSmartContract(bytecodeFileID) {
    // Instantiate the contract instance
    const contractTx = await new ContractCreateTransaction()
        //Set the file ID of the Hedera file storing the bytecode
        .setBytecodeFileId(bytecodeFileID)
        //Set the gas to instantiate the contract
        .setGas(2000000)
        //Provide the constructor parameters for the contract
        // .setConstructorParameters(new ContractFunctionParameters().addString("string"))
    ;

    //Submit the transaction to the Hedera test network
    const contractResponse = await contractTx.execute(client);
    //Get the receipt of the file create transaction
    const contractReceipt = await contractResponse.getReceipt(client);
    //Get the smart contract ID
    const newContractId = contractReceipt.contractId;
    //Log the smart contract ID
    console.log("The smart contract ID is " + newContractId);
}

async function deploySmartContract(abiLocation) {
    client = setupClient();
    const bytecode = await setupByteCode(abiLocation);
    const bytecodeFileId = await uploadByteCode(bytecode);
    // const bytecodeFileId = FileId.fromString("0.0.34933509");
    createSmartContract(bytecodeFileId);
}

deploySmartContract("../../Solidity/abis/Example.json");