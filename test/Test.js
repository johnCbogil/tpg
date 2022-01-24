const { expect } = require("chai");
const { BigNumber } = require("@ethersproject/bignumber");

describe("TPG contract", function () {

    it("should throw an error when the mint price is not met", async function () {


    });

    it("should return the correct treasury balance", async function () {
        const TPGContract = await ethers.getContractFactory("TPG");
        const hardhatTPG = await TPGContract.deploy();
        
        await hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        expect(await hardhatTPG.getTreasuryBalance()).to.equal(BigNumber.from("1000000000000000000"));

        await hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        expect(await hardhatTPG.getTreasuryBalance()).to.equal(BigNumber.from("2000000000000000000"));

        await hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        expect(await hardhatTPG.getTreasuryBalance()).to.equal(BigNumber.from("3000000000000000000"));
    });

    it("should enforce max member count", async function () {

    });
});