const balance = require("@openzeppelin/test-helpers/src/balance");
const {
	artifacts,
	ethers
} = require("hardhat");
const { int } = require("hardhat/internal/core/params/argumentTypes");

async function main() {
	//  - Test
	//  - Mainnet
	let nftAddress = ""; 
	let quantity = [1];
	let userAddress = ['0x8C300Fb9BefEcaAcFb161167D417190a097d9f56'];

	const OOPSContract = await ethers.getContractFactory("SETTVDAO");
	const contract = await OOPSContract.attach(nftAddress);

	console.log("Airdrop " + userAddress.length + " NFTs.")
	
	await contract.airdrop(userAddress, quantity);
	}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});