//const { ethers } = require("hardhat");
const ethers = require("ethers")
const provider = new ethers.AlchemyProvider("goerli", process.env.ALCHEMY_KEY)
const operatorAbi = require("../artifacts/contracts/Operator.sol/Operator.json")
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider)
const { TokenboundClient } = require("@tokenbound/sdk");


const main = async () => {

  const operatorContract = new ethers.Contract(process.env.OPERATOR_CONTRACT_ADDRESS, operatorAbi.abi, wallet)
  const tokenboundClient = new TokenboundClient({ signer: wallet, chainId: 5 })


  for (let i = 0; i < 19; i++) {
    // create NPC
    const npcTx = await operatorContract.createNPC(wallet.address, `ipfs://QmQbwCMwDETHHZ1g8YaSHqLBwCRgVHqFuRNRfiGyNqCcXj/${i}.json`)
    const npcTxReceipt = await npcTx.wait()
    console.log("NPC Created")

    // After the NPC is created
    const latestTokenId = await operatorContract.getLatestTokenId();

    // create TBA for NPC
    const tba = await tokenboundClient.createAccount({
      tokenContract: process.env.NPC_CONTRACT_ADDRESS,
      tokenId: latestTokenId,
    })
    console.log("TBA:", tba)

    // equip NPC via TBA

    const equipTx = await operatorContract.equipNPC(tba, 20, 5, 5)
    const equipTxReceipt = await equipTx.wait()
    console.log("NPC Equipped")
  }
}

main()
