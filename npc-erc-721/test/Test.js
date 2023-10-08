const { expect } = require("chai");

// Import the ethers library
const { ethers } = require("hardhat");

async function runTests() {
  let contract;
  let owner;
  let addr1;
  let addr2;

  // Get the signers from ethers
  [owner, addr1, addr2] = await ethers.getSigners();

  // Deploy the contract
  const Contract = await ethers.getContractFactory("CosmicCowboys");
  contract = await Contract.deploy(owner.address);
  const contractAddress = await contract.getAddress()
  console.log("Contract deployed to address:", contractAddress);

  // Mint tokens
  await contract.safeMint(addr1.address, "ipfs://QmVLwvmGehsrNEvhcCnnsw5RQNseohgEkFNN1848zNzdng");
  console.log("Minted token 1");
  await contract.safeMint(addr2.address, "ipfs://QmVLwvmGehsrNEvhcCnnsw5RQNseohgEkFNN1848zNzdng");
  console.log("Minted token 2");

  const tokenURI = await contract.tokenURI(1);
  console.log(tokenURI);
};

runTests()
