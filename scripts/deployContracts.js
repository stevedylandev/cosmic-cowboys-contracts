// Import the ethers library
const { ethers } = require("hardhat");
const provider = new ethers.AlchemyProvider("goerli", process.env.ALCHEMY_KEY)
const { TokenboundClient } = require("@tokenbound/sdk");

async function Main() {


  // Get the signers from ethers
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider)
  const tokenboundClient = new TokenboundClient({ signer: wallet, chainId: 5 })
  console.log(`SERVER_WALLET_PRIVATE_KEY=${process.env.PRIVATE_KEY}`)
  console.log(`SERVER_WALLET_ADDRESS=${wallet.address}`)

  // Deploy NPC contract
  const NPCContract = await ethers.getContractFactory("CosmicCowboys");
  const npcContract = await NPCContract.deploy(wallet.address);
  const npcContractAddress = await npcContract.getAddress()
  console.log(`NPC_CONTRACT_ADDRESS=${npcContractAddress}`);

  // Deploy ERC-20 Contract
  const CurrencyContract = await ethers.getContractFactory("GoldenCorn");
  const currencyContract = await CurrencyContract.deploy(wallet.address);
  const currencyContractAddress = await currencyContract.getAddress()
  console.log(`CURRENCY_CONTRACT_ADDRESS=${currencyContractAddress}`)

  // Deploy 1155 Contracts
  const FoodContract = await ethers.getContractFactory("SpaceSlop");
  const foodContract = await FoodContract.deploy(wallet.address);
  const foodContractAddress = await foodContract.getAddress()
  console.log(`FOOD_CONTRACT_ADDRESS=${foodContractAddress}`);

  const SupplyContract = await ethers.getContractFactory("JupiterJunk");
  const supplyContract = await SupplyContract.deploy(wallet.address);
  const supplyContractAddress = await supplyContract.getAddress()
  console.log(`SUPPLY_CONTRACT_ADDRESS=${supplyContractAddress}`);

  // Deploy ERC6551
  /* const RegistryContract = await ethers.getContractFactory("ERC6551Registry");
  const registryContract = await RegistryContract.deploy();
  const registryContractAddress = await registryContract.getAddress()
  console.log("Registry Contract deployed to address:", registryContractAddress);

  const AccountContract = await ethers.getContractFactory("ERC6551Account");
  const accountContract = await AccountContract.deploy();
  const accountContractAddress = await accountContract.getAddress()
  console.log("Account Contract deployed to address:", accountContractAddress); */

  // Deploy Operator Contract
  const OperatorContract = await ethers.getContractFactory("Operator");
  const operatorContract = await OperatorContract.deploy(wallet.address, npcContractAddress, currencyContractAddress, foodContractAddress, supplyContractAddress)
  const operatorContractAddress = await operatorContract.getAddress()
  console.log(`OPERATOR_CONTRACT_ADDRESS=${operatorContractAddress}`)

  // Transfer NPC contract to Operator
  await npcContract.transferOwnership(operatorContractAddress);
  await currencyContract.transferOwnership(operatorContractAddress);
  await foodContract.transferOwnership(operatorContractAddress);
  await supplyContract.transferOwnership(operatorContractAddress);

  for (let i = 0; i < 20; i++) {
    // create NPC
    const npcTx = await operatorContract.createNPC(wallet.address, `ipfs://QmQbwCMwDETHHZ1g8YaSHqLBwCRgVHqFuRNRfiGyNqCcXj/${i}.json`)
    const npcTxReceipt = await npcTx.wait()
    console.log("NPC Created")

    // After the NPC is created
    const latestTokenId = await operatorContract.getLatestTokenId();

    // create TBA for NPC
    const tba = await tokenboundClient.createAccount({
      tokenContract: npcContractAddress,
      tokenId: latestTokenId,
    })
    console.log("TBA:", tba)

    // equip NPC via TBA
    //
    const fundNpcTx = await operatorContract.fundNPC(tba, 20)
    const fundNpxTxReceipt = await fundNpcTx.wait()
    console.log("NPC Funded")

    const feedNpcTx = await operatorContract.feedNPC(tba, 5)
    const feedNpcTxReceipt = await feedNpcTx.wait()
    console.log("NPC Fed")

    const supplyNpcTx = await operatorContract.supplyNPC(tba, 5)
    const supplyNpcTxReceipt = await supplyNpcTx.wait()
    console.log("NPC Supplied")

  }
}

Main()
