// Import the ethers library
const { ethers } = require("hardhat");

async function CosmicCoyboys() {
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

async function GoldenCorn() {
  let contract;
  let owner;
  let addr1;
  let addr2;

  // Get the signers from ethers
  [owner, addr1, addr2] = await ethers.getSigners();

  // Deploy the contract
  const Contract = await ethers.getContractFactory("GoldenCorn");
  contract = await Contract.deploy(owner.address);
  const contractAddress = await contract.getAddress()
  console.log("Contract deployed to address:", contractAddress);

  // Mint tokens
  await contract.mint(addr1.address, 100);
  console.log("Minted token 1");

  const balance = await contract.balanceOf(addr1.address);
  console.log(balance)

}

async function TBA() {
  let contract;
  let owner;
  let addr1;
  let addr2;

  // Get the signers from ethers
  [owner, addr1, addr2] = await ethers.getSigners();

  // Deploy the contract
  const RegistryContract = await ethers.getContractFactory("ERC6551Registry");
  const regristryContract = await RegistryContract.deploy();
  const registryContractAddress = await regristryContract.getAddress()
  console.log("Registry Contract deployed to address:", registryContractAddress);

  const AccountContract = await ethers.getContractFactory("ERC6551Account");
  const accountContract = await AccountContract.deploy();
  const accountContractAddress = await accountContract.getAddress()
  console.log("Account Contract deployed to address:", accountContractAddress);

}

TBA()
