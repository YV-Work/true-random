#Simple. Cheap. Secure.

True Random is a blockchain smart contract utility designed to provide all users with the most secure and simple yet cheap (relatively) way of generating random numbers...

## RNG theory
> Random number generation is a process of generating a sequence of numbers or symbols that cannot be reasonably predicted better than by chance.

Currently, true randomness in code can only be achieved by hardware random number generators that use electrical, thermal or optical noise as a true, unpredictable, physical source of statistical variation.
An alternative to true [HRNGs](https://en.wikipedia.org/wiki/Hardware_random_number_generator "hardware random-number generators") generation is algo-driven generation, which is used by many systems and programming languages.

Any algorithm-driven RNG is _in theory_ fully predictable and therefore exploitable. Algo [PRNGs](https://en.wikipedia.org/wiki/Pseudorandom_number_generator "pseudo-random number generators") are usually designed to generate a random output from a given seed; the most commonly used seeds are timestamp and server file system. Any output produced by an algorithm can be considered predetermined and is therefore susceptible to forgery if sufficient computing power is available. Using the system timestamp as a seed simply means that:
> Given sufficient computing power, an occurrence of the desired hash output of the algorithm with a timestamp as seed can be found in the reasonably distant future.

## Problems and complications

> "While a pseudorandom number generator based solely on deterministic logic can never be regarded as a "true" random number source in the purest sense of the word, in practise they are generally sufficient even for demanding security-critical applications."
> _- ["True" vs pseudo-random numbers](https://en.wikipedia.org/wiki/Random_number_generation#"True"_vs._pseudo-random_numbers)_

A DLT/blockchain architecture presents some obstacles to achieving this state.

### Off chain computation alternative

While an off-chain algorithm or HRNG machine can provide a more truthful RNG, an oracle or centralised connection is required to deliver data to the chain. Such design poses two major problems for malicious attacks by the malicious off-chain logic (influencing randomness in certain way), by the oracle provider or the off-chain server owner. While decentralised oracles begin to exist, the call cost is simply too high to use such data source for a large number of on-chain computations.

### Blockchain predetermination

Any attempt at randomness is further sabotaged by the fact that blockchain and DLT of any kind are completely predeterministic by design, as every node is expected to compute and confirm the same result as every other node.
Any future or past event on chain can be calculated and confirmed locally.

### Falsification of timestamps

Another solution would be to rely on the timestamp as the seed. This leads to numerous problems. One of them is that the source of the block timestamp is determined by the block miner. Malicious miners can shift a block's timestamp within a 10-14 seconds window of block being created. Since the block time is not constant and varies between 1 and 19 seconds depending on many factors, miners have a safe period of few seconds in which to shift the timestamp and create a "random" number.

_[See Note #3 under time-units section](https://docs.soliditylang.org/en/latest/units-and-global-variables.html?highlight=block.timestamp#time-units) of official solidity documentation._

### `block.timestamp` Refresh Rate

Assuming all block miners are not malicious, updating block.timestamp still takes a few seconds, so creating 5 values for 5 calls from 5 accounts within a block can result in accounts receiving identical pseudo-random results. Similarly, multiple calls for random numbers within a client transaction.

![Identical RNGs returned](./docs/block_timestamp_refresh_rate.png?raw=true "Block.timestamp Refresh Rate")

### TL;DR

To sum up:
1. RNG cannot be placed off-chain
2. RNG cannot _fully_ rely on user-generated input
3. RNG cannot _fully_ rely on the timestamp provided by the call
4. RNG cannot _fully_ rely on any other value with same or lower refresh rate than block.timestamp

There are few ways to avoid or prevent the malicious misuse of pseudorandomness by each of potentially malicious actors.

## `TrueRandom.sol` solution

A comprehensive understanding of blockchain PRNG problems points the way to what we believe is one of the best solutions in terms of security with reasonable cost-effectiveness. In this section we explain each possible option that can be used to solve some of the problems highlighted.

### Smart Contract/User generated salt
Sending msg.sender, msg.value, user call parameters or balances as a salt will lead to an easily predictable result. However, such input can completely mitigate any third-party involvement or malicious shifts by the node owner or block miner, as the algorithm does not rely on a variable within their control.

:heavy_check_mark: **This salt is vulnerable to the 2nd problem, but protects the PRNG from vulnerabilities 4 and 3.**

### PRNG stored salt
Another option is to store salt in the random number generator. Each time the RNG is called, the salt must be updated with the result of the previous algo hashing.
> PRNG stores salt **1**, user A generates a random number **74** from the hash with salt **1**, the number **74** is stored as salt for the next call. User B requests the next number and generates number **13** from salt **74**. Salt **13** is stored for the next call of the PRNG.

The use of stored Salt eliminates user's ability to influence the seemingly predictable hashing algorithm, but poses a great risk for an attack on the 3rd vulnerability, as any private property of the smart contract can theoretically be read from the binary state of the smart contract storing such value. 
This results in some "frontrunning" risk if the node owner can exploit such knowledge to hijack the best possible hashing output for himself by precompiling outcome off-chain to then abuse it when the on-chain app uses this value for its computations (and if RNG is the key to some advantageous app/game outcomes ). Assuming several apps call a single smart contract at irregular intervals, a common RNG source is frequently updated with new values which lowers any option of predictability.

:heavy_check_mark: **It is reasonable to assume that this option completely protects PRNG from the 2nd and 4th problems, but makes PRNG vulnerable to the 3rd potential attack.**

### `block.timestamp`
Despite the poor refresh rate and potential malicious shitfing, the block.timestamp value is limited to a certain range or options set by the system (+ malicious miners).
Therefore, this value is completely independent of the user and cannot be abused.

:heavy_check_mark: **`Block.timestamp` can therefore be considered a reasonably reliable protection against the 2nd problem, although it is vulnerable to the 3rd.**

### Combined solution

So instead of using one specific PRNG source, `TrueRandom.sol` combines all 3 options in order to generate byte record that's virtually protected from all attack anglesd by all combined seeds.

![TrueRandom.sol Salt assembly](./docs/TrueRandomSalt.jpg?raw=true "True Random salt")

To stay within 32B to 32B conversion (proven to be cheaper than direct encoding and reliable in regard to integer overflow, PRNG trims all incoming variables to fit such bytes structure. 
As of solidity 0.8.8 variables are always trimmed down so the produced timestamp value is always made form lower, refreshing digits.

Unpredictability of such PRNG lies in the idea that system, other developers, potentially miners, as well as user, all have influence on hashing algorithm. So despite unequal influence of said parties, _no single entity can reasonably predict hashing output better than by chance_.
Fulfilling the key demand of "True" RNG.

TODO add a chapter about usage from SDKs vs usage from 

_Currently deployed only on Ethereum Rinkeby and Hedera previewnet, testnet, `TrueRandom.sol` contains set of useful functions to protect your randomly generated numbers, make more cost efficient calls with less security but for 80% gas needed and utilise general mechanism which makes this smart contract sufficiently unpredictable._