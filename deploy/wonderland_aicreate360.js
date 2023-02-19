const { ethers } = require("hardhat");

const NFT = artifacts.require("wonderland_aicreate360");

module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId,
  getUnnamedAccounts,
}) => {
  const {deploy, all} = deployments;
  const accounts = await ethers.getSigners();
  const deployer = accounts[0];
  console.log("");
  console.log("Deployer: ", deployer.address);

  nft = await deploy('wonderland_aicreate360', {
    contract: "wonderland_aicreate360",
    from: deployer.address,
    args: [
    ],
  });

  console.log("wonderland_aicreate360 address: ", nft.address);
};

module.exports.tags = ['wonderland_aicreate360'];