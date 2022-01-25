const { expect } = require("chai");
const { BigNumber } = require("@ethersproject/bignumber");

describe("TPG contract", function () {

    function throwError() {
        throw console.error();
    }


    it("should revert when the mint price is not met", async function () {
        const TPGContract = await ethers.getContractFactory("TPG");
        const hardhatTPG = await TPGContract.deploy();
        await expect(hardhatTPG.mintMembership()).to.be.revertedWith(
            "Mint price not met."
          );
    });

    it("should return the correct treasury balance", async function () {
        const TPGContract = await ethers.getContractFactory("TPG");
        const hardhatTPG = await TPGContract.deploy();
        
        hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        expect(await hardhatTPG.getTreasuryBalance()).to.equal(BigNumber.from("1000000000000000000"));

        hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        expect(await hardhatTPG.getTreasuryBalance()).to.equal(BigNumber.from("2000000000000000000"));

        hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        expect(await hardhatTPG.getTreasuryBalance()).to.equal(BigNumber.from("3000000000000000000"));
    });

    it("should revert when there are no memberships remaining", async function () {
        const TPGContract = await ethers.getContractFactory("TPG");
        const hardhatTPG = await TPGContract.deploy();

        hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});
        hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")});

        await expect(hardhatTPG.mintMembership({value: ethers.utils.parseEther("1")})).to.be.revertedWith(
            "All memberships consumed."
          );
    });
});