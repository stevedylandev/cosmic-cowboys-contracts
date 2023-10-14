# Cosmic Cowboys Contracts

This repo contains the Solidity smart contracts for Cosmic Cowboys, a dynamic on-chain game that gives life to NPC using ERC-6551 and AI. 

The project consists of several elements: 
- A primary key that can deploy / own the contracts 
- An altered ERC-721 where each NFT is an NPC. The additions to the contract include on-chain state like health and location.
- ERC-20 Contract for the in game currency
- Two ERC-1155 Contracts for in game supplies and items 
- A custom "Operator" contract that abstracts the other contracts and allows on chain dynamics.
- A custom implementation of ERC-6551 for deploying to chains that may not have an implementation address, like Scroll. 

With this repo we deploy all the previously mentioned contracts and mint 20 NPC characters, give each their own Tokenbound Account, and mint currency and items to those accounts. The end result will also give env variables that can be used for the front end portion of the app. 

# Deploying

Fist clone this repo and install dependences
```
git clone https://github.com/stevedylandev/cosmic-cowboys-contracts && cd cosmic-cowboys-contracts && npm install
```

To deploy the contracts you can create a `.env` file with the following variables:

```
PRIVATE_KEY=
ALCHEMY_URL=
ALCHEMY_URL_BASE=
ALCHEMY_KEY=
ALCHEMY_KEY_BASE=
SEPOLIA_URL=
SEPOLIA_KEY=
ETHERSCAN_API_KEY=
```
Depending what networks you want to deploy to you can alter those variables. 

Once ready you can deploy with your choice of network like goerli
```
npx hardhat run scripts/deployContracts.js --network goerli
```
Once you run this it will deploy all contracts as well as setup the NPCs for the game. 
