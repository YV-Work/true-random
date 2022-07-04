# Contents
- `example.js` & `exampleSDK.js` contain examples of usage of TrueRandom.sol with Hashgraph SDK.
- `utils` folder contains client connection script as well as overkill contract deployment tool
- `utils/utils.js` contains logger helper  converting big numbers to user friendly format


# !IMPORTANT!

Before running example scripts, create `.env` file in this directory. 

Add following: 
```sh
MY_ACCOUNT_ID = 0.0.YOUR_ACCOUNT #used to connect client.js to blockchain
MY_PRIVATE_KEY = YOUR_PKEY
TREASURY_PKEY = YOUR_TREASURY_PKEY #used as SC treasury when deploying scripts
EXAMPLE_SC = 0.0.46810020 #Example.sol Smart Contract address (specified is Hedera Testnet addr)
EXAMPLE_SDK_SC = 0.0.46813450 #ExampleSDK.sol same thing 
TRUE_RANDOM_TESTNET = 0.0.46813450
TRUE_RANDOM_PREVIEWNET = 0.0.3882
```

Alternatively, replace `process.env.*` references in code with your own values.

