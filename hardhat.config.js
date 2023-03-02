require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-truffle5");
require('hardhat-deploy');
require("hardhat-gas-reporter");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require('solidity-coverage');


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },

  networks:{
    hardhat: {
      accounts:{
        "mnemonic": process.env.HARDHAT_TEST_MNEMONIC
      }
    },
    mumbai: {
      url: process.env.ALCHEMY_API_MUMBAI_URL,
      accounts:{
        "mnemonic": process.env.MUMBAI_TEST_MNEMONIC
      }
    },
    polygon: {
      url: process.env.ALCHEMY_API_MAINNET_KEY, 
      accounts:[process.env.MAINNET_PRIVATE_KEY],
      gas: 2747558,
      gasPrice: 120000000000
    }
  },  
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};