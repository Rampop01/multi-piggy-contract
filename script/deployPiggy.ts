const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  

  const OnchainThrift = await hre.ethers.getContractFactory("onchainThrift");
  console.log("Deploying onchainThrift contract...");

  // Constructor parameters
  const owner = deployer.address;
  const developer = deployer.address;
  const token = "0x.."; 
  const duration = 30 * 24 * 60 * 60;

  const piggyBank = await OnchainThrift.deploy(owner, developer, token, duration);
  await piggyBank.waitForDeployment();

  const piggyAddress = await piggyBank.getAddress();
  console.log("onchainThrift deployed to:", piggyAddress);


  await hre.run("verify:verify", {
    address: piggyAddress,
    constructorArguments: [owner, developer, token, duration],
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
