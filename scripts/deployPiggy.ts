import { HardhatRuntimeEnvironment } from 'hardhat/types';
import hre from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();

async function main() {
  const [deployer] = await hre.ethers.getSigners();


  const allowedTokens = [
    "0x6f14C02Fc1F78322cFd7d707aB90f18baD3B54f5", // USDT Test Token
    "0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8", // USDC Test Token
    "0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357"  // DAI Test Token
  ];

  const developer = deployer.address;

  const Factory = await hre.ethers.getContractFactory("MyPiggyFactory");
  console.log("Deploying MyPiggyFactory contract...");
  
  const factory = await Factory.deploy(developer, allowedTokens);
  await factory.waitForDeployment();

  const factoryAddress = await factory.getAddress();
  console.log("MyPiggyFactory deployed to:", factoryAddress);
  console.log("Developer address:", developer);
  console.log("Allowed tokens:", allowedTokens);

  console.log("Waiting for verification...");
  try {
    await new Promise((resolve) => setTimeout(resolve, 60000));
    
    await hre.run("verify:verify", {
      address: factoryAddress,
      constructorArguments: [developer, allowedTokens],
    });
    console.log("Contract verified!");
  } catch (error) {
    console.log("Verification failed:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
