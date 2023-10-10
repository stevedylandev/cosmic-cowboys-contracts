// Import the ethers library
const { ethers } = require("hardhat");

async function Operator() {

  let owner;
  let addr1;
  let addr2;
  let deployedAccountTx, deployedAccountReceipt, deployedAccountAddress;

  // Get the signers from ethers
  [owner, addr1, addr2] = await ethers.getSigners();

  // Deploy NPC contract
  const NPCContract = await ethers.getContractFactory("CosmicCowboys");
  const npcContract = await NPCContract.deploy(owner.address);
  const npcContractAddress = await npcContract.getAddress()
  console.log("NPC Contract deploywed to address:", npcContractAddress);

  // Deploy ERC-20 Contract
  const CurrencyContract = await ethers.getContractFactory("GoldenCorn");
  const currencyContract = await CurrencyContract.deploy(owner.address);
  const currencyContractAddress = await currencyContract.getAddress()
  console.log("NPC Contract deploywed to address:", currencyContractAddress);

  // Deploy 1155 Contracts
  const FoodContract = await ethers.getContractFactory("SpaceSlop");
  const foodContract = await FoodContract.deploy(owner.address);
  const foodContractAddress = await foodContract.getAddress()
  console.log("NPC Contract deploywed to address:", foodContractAddress);

  const SupplyContract = await ethers.getContractFactory("JupiterJunk");
  const supplyContract = await SupplyContract.deploy(owner.address);
  const supplyContractAddress = await supplyContract.getAddress()
  console.log("NPC Contract deploywed to address:", supplyContractAddress);

  // Deploy ERC6551
  const RegistryContract = await ethers.getContractFactory("ERC6551Registry");
  const registryContract = await RegistryContract.deploy();
  const registryContractAddress = await registryContract.getAddress()
  console.log("Registry Contract deployed to address:", registryContractAddress);

  const AccountContract = await ethers.getContractFactory("ERC6551Account");
  const accountContract = await AccountContract.deploy();
  const accountContractAddress = await accountContract.getAddress()
  console.log("Account Contract deployed to address:", accountContractAddress);

  // Deploy Operator Contract
  const OperatorContract = await ethers.getContractFactory("Operator");
  const operatorContract = await OperatorContract.deploy(owner.address, npcContractAddress, currencyContractAddress, foodContractAddress, supplyContractAddress)
  const operatorContractAddress = await operatorContract.getAddress()
  console.log("Operator Contract deployed to address:", operatorContractAddress)

  // Transfer NPC contract to Operator
  await npcContract.transferOwnership(operatorContractAddress);
  await currencyContract.transferOwnership(operatorContractAddress);
  await foodContract.transferOwnership(operatorContractAddress);
  await supplyContract.transferOwnership(operatorContractAddress);

  // create NPC
  const npcTx = await operatorContract.createNPC(owner.address, "ipfs://")
  const npcTxReceipt = await npcTx.wait()

  // After the NPC is created
  const latestTokenId = await operatorContract.getLatestTokenId();
  console.log("Latest Token ID:", latestTokenId.toString());

  // create TBA for NPC
  deployedAccountTx = await registryContract.createAccount(
    accountContractAddress,
    5,
    npcContractAddress,
    latestTokenId.toString(),
    0,
    "0x"
  )
  deployedAccountReceipt = await deployedAccountTx.wait()
  console.log(deployedAccountReceipt)

  // equip NPC via TBA

}
