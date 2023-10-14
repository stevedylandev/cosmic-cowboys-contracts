require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    goerli: {
      url: `${process.env.ALCHEMY_URL}`,
      accounts: [process.env.PRIVATE_KEY],
    },
    scrollSepolia: {
      url: "https://sepolia-rpc.scroll.io/" || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 1500000000,

    },
    'base-goerli': {
      url: `${process.env.ALCHEMY_URL_BASE}`,
      accounts: [process.env.PRIVATE_KEY],
      gasPrice: 1000000000,
    },
    sepolia: {
      url: `${process.env.SEPOLIA_URL}`,
      accounts: [process.env.PRIVATE_KEY],
    }
  },
  /* etherscan: {
    apiKey: {
      "base-goerli": "PLACEHOLDER_STRING"
    },
    customChains: [
      {
        network: "base-goerli",
        chainId: 84531,
        urls: {
          apiURL: "https://api-goerli.basescan.org/api",
          browserURL: "https://goerli.basescan.org"
        }
      }
    ]
  }, */
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }

};
