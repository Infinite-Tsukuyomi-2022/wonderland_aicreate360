const { ethers } = require("hardhat");

const NFT = artifacts.require("SETTVDAO");

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

  nft = await deploy('SETTVDAO', {
    contract: "SETTVDAO",
    from: deployer.address,
    args: [
    ],
  });

  console.log("SETTVDAO address: ", nft.address);
};

module.exports.tags = ['SETTVDAO'];