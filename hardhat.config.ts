require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
const {ALCHEMY_SEPOLIA_API_KEY_URL,ACCOUNT_PRIVATE_KEY,ETHERSCAN_API_KEY}= process.env

module.exports = {
  solidity: "0.8.28",

  networks: {
  
    sepolia: {
      url: ALCHEMY_SEPOLIA_API_KEY_URL,
      accounts: [`0x${ACCOUNT_PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
};
