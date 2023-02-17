import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";
import hre from "hardhat";

describe("ERC20", function () {

	async function init() {
		const myERC20 = await hre.ethers.getContractFactory("MyERC20");
		const myERC20deployed = await myERC20.deploy("My", "My");

		const [owner, acc1, acc2] = await ethers.getSigners();
		
		return {myERC20deployed, owner, acc1, acc2};
	}

	it("mint is OK", async function() {
		const {myERC20deployed, owner} = await loadFixture(init);

		const mintNum = 200;
		await myERC20deployed.mint(mintNum);
		
		expect(await myERC20deployed.balanceOf(owner.address)).to.equals(mintNum);
	});


	it("transfer is OK",async () => {
		const {myERC20deployed, acc1, acc2} = await loadFixture(init);

		const mintNum = 200;
		await myERC20deployed.connect(acc1).mint(mintNum);
		await myERC20deployed.connect(acc2).mint(mintNum);

		expect(await myERC20deployed.connect(acc1).balanceOf(acc1.address)).to.equals(mintNum);
		expect(await myERC20deployed.connect(acc2).balanceOf(acc2.address)).to.equals(mintNum);

		await myERC20deployed.connect(acc1).transfer(acc2.address, 50);
		expect(await myERC20deployed.balanceOf(acc2.address)).to.equals(mintNum + 50);
		expect(await myERC20deployed.balanceOf(acc1.address)).to.equals(mintNum - 50);
	})
})