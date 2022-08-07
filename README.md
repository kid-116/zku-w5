# zku.ONE C-4

**_Discord:_** mehultodi116@gmail.com <br/>
**_Email:_** kid116#4889

## Week 5
## Section A: Theoretical Questions
### P1: Scalability
<hr>

#### Q1
**Choose two specific blockchain scaling solutions and compare their implementations regarding the different trade-offs they make.**

An on-chain solution for scaling blockchains is sharding where the network is broken down into smaller manageable components operating parallelly to achieve a significant increase of the transaction capacity for the newtwork. In the simplest form of sharding, validators are randomly assigned to a subset of the blocks. Each such group of validators formed is called a committee. Let us assume our network to be having `b` blocks to validate and a total of `v` validators running full nodes and let's say we form `c` committees to process these blocks. Then, a validator must only validate `b / c` blocks. Each of these blocks will contain `v / c` signatures proving their validity which must be checked by all of the validators meaning that each validator must also check `v * b / c` signatures which is relatively a much smaller amount of work especially with the use of BLS signature aggregation. Therefore, the capacity of the network increases by a factor of `c` which depends upon the number of validators present in the network. This approach increases the throughput of the system without compromising on the the security as in a 100-chain multichain ecosystem, the needs only ~0.5% of the total stake to wreak havoc as they can focus on a 51% attack on a single chain whereas in a sharded blockchain, the attacker must have close to 30-40% of the entire stake to do the same as the chances of gaining a majority in any of the committees with less than 30% of the stake is virtually impossible as there is an exponential decay of the probability of this happening as the attacker's stake decreases.

Yet, another widely popular solution which tries to solve the problem of blockchain scalability is L2 layer which aggregates a large number of transactions on a sidechain and sends a bunch of these transactions rolled into a single transaction to the L1 chain to decongest the L1 layer. This is the realm of rollups. It is to be noted that this is an off-chain solution as it does not require any changes to the Ethereum protocol. It is also important to know that rollups derive their security directly from layer 1 Ethereum consensus where other sidechain solutions derive their security with the own set of validators.

With rollups, the major drawback is associated with the security of bridges. L2 Ethereum fueled the creation of dozens of new bridges and interoperability protocols as projects, every last one of which markets itself as trustless, secure and decentralized but cryptoeconomic systems are only as secure as their weakest link and needless to say, these bridges have brought on a number of high profile hacks and scams. Therefore, there seems to be a trade-off between scaling and security with these off-chain solutions requiring bridges. Sharding has it's share of drawbacks. The simplest of the sharding techniques - `random sampling` has weaker trust properties. Above, we explained how improbable it is to get a majority ina ny of the sharded committees but this probablity is not zero. As sharding progresses, the chance of a malicious actor gaining a majority of the system increases. This can cause a complete breakdown of the network as this can cause a ripple effect causing problems across shards as well.

#### Q2
**`ZkSync` and `StarkNet` are two of the most promising zkRollups currently available with differing strategies. Briefly explain the differentiations between the two rollups and your conclusion on which is more likely to win the zkRollup wars.**

Both of these scalability solutions are zkRollups which batches several transactions off-chain and bundles them into a single transaction to be added to the chain. They aslo provide succint zk-proofs which is validated on-chain to prove the validity of the rollups. The only difference between the two is the kind of zk-proofs they employ. zkSync makes use of SNARK proves whereas StarkNet exploits STARK proofs. The following tables gives us some comparison between the two variations - 

|                     | SNARKs         | STARKs                         |
|---------------------|----------------|--------------------------------|
| Prover complexity   | O(N x log(N))  | O(N x poly-log(N))             |
| Verifier complexity | O(1)           | O(poly-log(N))                 |
| Proof size          | O(1) - (288 B) | O(poly-log(N)) - (45 - 200 kB) |
| Gas cost            | 600k           | 2.5M                           |
| Trusted setup       | YES            | NO                             |
| Post quantum secure | NO             | YES                            |

It is difficult to predict which one of the two will prevail in the future. On the one hand SNARK proofs are more efficient in terms of gas costs but require a trusted setup due to the use of elliptic curves as opposed to the use of hash functions by STARK. This setup necessitates certain trust on the part of the users which is not at all desirable but at the same time, the setup ceremony - `Powers of Tau` almost eliminates the need for this trust as it is practically impossible to cheat the system as long as even one honest participant takes part in the open ceremony. As of right now, SNARKs enjoy majority adoption in the community because it has been present for a longer amount of time and this trend will continue into the forseeable future but as quantum computation becomes available for the masses I think the STARK's resistance against quantum computers will lead it to victory.

### P2: Interoperability
<hr>

#### Q1
**Briefly explain what would be the different components required to create a bridge application for token transfers. Assume ERC20 tokens are being transferred between EVM chains for simplicity.**

Bridges are used to move assets between two different blockchain networks. First of all, the assets must be ERC20 tokens for this to be possible, therefore ERC20 contracts must be present on both the networks. In the source-chain, the token to be transferred say ETH is changed to a Wrapped-ETH token whose ownership is handed over to the bridge conctract in the same network. The bridge contract thus communicates with the corresponding bridge contract in the target blockchain to move the assets received to the intended address in the target blockchain which may or may not belong to sender. Finally, certain amount of Wrapper assets are held by the bridge contract in the source blockchain and an address in the destination blockchain. The communication across blockchain requires certain protocol stack which consists of `Crosschain Messaging` which allows the identification of the source of a message, `Crosschain Function Calls` which allows for the calling of functions across separate networks and finally `Crosschain Application` which basically builds on top of these two protocols to help in the process of building crosschain applications as the name suggests.

#### Q2
**Aztec utilizes a set of zero-knowledge proofs to shield both native assets and assets that conform with certain standards (e.g. ERC20) on a Turing-complete general-purpose computation.​​ Briefly explain the concept of AZTEC Note and how the notes are used to privately represent various assets on a blockchain.**

Under the hood, the smart contract - `AZTEC Computation Engine` or `ACE` is responsible for the functionalities offered by `AZTEC Notes`. Firstly, it delegates the validation of the proofs to specific transactions within the contract and secondly, it updates the states of the note registry on receiving a valid proof. The user's balance of any AZTEC asset is made up of the sum of all the valid notes their address owns in a given registry. It is sort of like a mixer with different modular features to build on top of, allowing Web3 developers to provide features like secure privacy on public blockchain analogous to real word financial transactions. Some of the toolkits offered by AZTEC are - 

1. **Join Split (Transfer)** - It allows for input notes to be joined or split with each of these notes destined for different addresses. This is similiar to the UTXO model used by Bitcoin.

2. **Bilateral Swap (Trade)** - This allows for an atomic swap of two notes to take place.

It ensures privacy for the users as all of these transaction amounts are homorphically encrypted which has a special property of hiding its actual value but at the same time, allowing for complex mathematical operations on the private value. This sort of encryption scheme allows transactions to be validated such as to validate that in a Bilateral swap, the makers bid note is equal to the takers ask note or that the interest payment for a loan is some exact value. AZTEC enables confidential tansactions out of the box as transaction amounts are encrypted however using Ethereum addresses the transaction graph of AZTEC is not anonymous meaning the sender and the recepient of the transactions can be identified. But anonymity can be achieved using stealth addresses on the part of the recepients and by using third-party relayers which hides the payment of gas and provides full anonymity.

### P3: Final Project
<hr>

# zkTelepathy
This project demonstrates a small stepping stone toward #2 of Brian Gu’s Six ZK Moonshots 17. The idea is to have an on-chain data marketplace where users can trade private data, for example, “a high-res image that downsamples to a known low-res image”, using ZK.

Telepathy is a fun game which may be implemented using zk-proofs since it requires some information to be hidden from one of the players. It consists of a grid with different symbols of different colors each cells. One of the players, chooses a cell in the grid and the other must figure out the chosen hidden cell. The player may guess a row, column, symbol and color and the other player must acknowledge with a "Yes" even if one of the attributes is a match else "No".

# Application Type
zkGame

# Proposal Overview
Within the scope of this proposal, the MVP is to implement a dApp that uses ZK to prove that the response given by the player who chose the cell is valid and he does not change his choice halfway through the game and an attractive and smooth UI attract players.

# Use Cases
- Fun game to relax and maybe win some tokens which holds no monetary value to discourage gambling.
- More importantly, it is learning project to kickstart my journey in the realm of zero-knowledge.

# Competitive Landscape
The game has to compete with other zkGames to attract users. It is also similar to games such as mastermind and battleship as it requires one of the players to hide certain information from the other and this is where zero-knowledge proofs come in. I think the game has the advantage of being short and a few rounds can be played without a few rounds. A disadvantage for the game might be it repetitive nature. To spice things up, the game may start with a certain number of tokens wagered by both the participants and fow each round they may pony up certain number of these tokens. To win the game a player must empty-out the other party.
