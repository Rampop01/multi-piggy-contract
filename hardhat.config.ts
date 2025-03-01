import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();


const config = {
  solidity: "0.8.28",

  networks: {
  
    sepolia: {
      url: process.env.ALCHEMY_SEPOLIA_API_KEY_URL,
      accounts: [`0x${process.env.ACCOUNT_PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
