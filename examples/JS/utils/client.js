const {Client} = require("@hashgraph/sdk");

require("dotenv").config();

/**
 * set up Hashgraph SDK client, ID and PKEY configuration inside
 * TODO : unwrap config or make per env functions
 * @returns {NodeClient}
 */
function setupClient() {

    //Grab your Hedera testnet account ID and private key from your .env file
    const myAccountId = process.env.MY_ACCOUNT_ID;
    const myPrivateKey = process.env.MY_PRIVATE_KEY;

    // If we weren't able to grab it, we should throw a new error
    if (myAccountId == null ||
        myPrivateKey == null ) {
        throw new Error("Environment variables myAccountId and myPrivateKey must be present");
    }

    // Create our connection to the Hedera network
    // The Hedera JS SDK makes this really easy!
    const client = Client.forTestnet();

    client.setOperator(myAccountId, myPrivateKey);

    return client;
}

module.exports = { setupClient }