const {
	assert,
	expect
} = require('chai');
const {
	BN,
	time,
	expectRevert,
	constants,
	balance
} = require('@openzeppelin/test-helpers');
const {
	artifacts,
	ethers
} = require('hardhat');

describe("Contract Construct", function () {

	let Token;
	let contract;
	let owner;
	let addr1;
	let addr2;
	let addrs;

	before(async function () {

		Token = await ethers.getContractFactory("wonderland_aicreate360");
		[owner, addr1, addr2, ...addrs] = await ethers.getSigners();

		contract = await Token.deploy();
		console.log("wonderland_aicreate360 deployed to:", contract.address);
		console.log("Owner:", owner.address);
		console.log("addr1:", addr1.address);
		console.log("addr2:", addr2.address);
		// console.log("addrs:", addrs);

	});

	describe("Contract Test", function () {

		it("airdrop Function", async function () {

			await contract.connect(owner).airdrop([addr1.address, addr2.address], [66, 200]);
			expect(await contract.totalSupply()).to.equal(316);
		});

		it("transfer Function", async function () {

			await contract.connect(owner).transferFrom(owner.address, addr2.address, 49);
		});

		// it("soulBound Function", async function () {

		// 	await contract.connect(addr1).transferFrom(addr1.address, addr2.address, 50);
		// });

		it("setSwitch Function", async function () {
			await contract.connect(owner).setSwitch(1, 1647198840, 1, 1647198840, 1);
		});

		it("setSigner Function", async function () {
			await contract.connect(owner).setSigner(owner.address);
		});

		// it("setPrice Function", async function () {
		// 	await contract.connect(owner).set_PRICE("40000000000000000");
		// });

		it("mintWhitelist Function", async function () {

			let quantity = 1;
			let maxQuantity = 1;

			const domain = {
				name: 'wonderland_aicreate360',
				version: '1.0.0',
				chainId: 31337,
				// verifyingContract: '0x8cADCa5B79C6cfe2555707EaE764FC2f0156C611'
				verifyingContract: '0x03BDD595639Fb287622Fc1A0baced3f3E1186ACE'
			};

			const types = {
				NFT: [{
						name: 'addressForClaim',
						type: 'address'
					},
					{
						name: 'maxQuantity',
						type: 'uint256'
					},
				],
			};

			var value = {
				addressForClaim: addr1.address,
				maxQuantity: maxQuantity
			};

			signature = await owner._signTypedData(domain, types, value);
			console.log(signature);
			await contract.connect(addr1).mintWhitelist(quantity, maxQuantity, signature/*, {value: "50000000000000000"}*/);

			expect(await contract.totalSupply()).to.equal(317);

		});

		it("mintNFT Function", async function () {
			await contract.connect(addr2).mintNFT(1/*, {value: "100000000000000000"}*/);
			expect(await contract.totalSupply()).to.equal(318);
		});

		it("burn Function", async function () {
			await contract.connect(addr1).burn(addr1.address, 51);
			expect(await contract.totalSupply()).to.equal(317);
		});

		it("setURI Function", async function () {
			await contract.connect(owner).setURI("Test");
			console.log(await contract.connect(owner).tokenURI(0));

		});

		// it("withdrawAll Function", async function () {
		// 	await contract.connect(owner).setTreasury("0x5279246E3626Cebe71a4c181382A50a71d2A4156");
		// 	await contract.connect(owner).withdrawAll();
		// });
	});
});