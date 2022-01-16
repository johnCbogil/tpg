/*
 ______  __ __    ___      ____   ___   ___   ____  _        ___ __  _____      ____  __ __  ___ ___ 
|      ||  |  |  /  _]    |    \ /  _] /   \ |    \| |      /  _]  |/ ___/     /    ||  |  ||   |   |
|      ||  |  | /  [_     |  o  )  [_ |     ||  o  ) |     /  [_|_ (   \_     |   __||  |  || _   _ |
|_|  |_||  _  ||    _]    |   _/    _]|  O  ||   _/| |___ |    _] \|\__  |    |  |  ||  ~  ||  \_/  |
  |  |  |  |  ||   [_     |  | |   [_ |     ||  |  |     ||   [_    /  \ |    |  |_ ||___, ||   |   |
  |  |  |  |  ||     |    |  | |     ||     ||  |  |     ||     |   \    |    |     ||     ||   |   |
  |__|  |__|__||_____|    |__| |_____| \___/ |__|  |_____||_____|    \___|    |___,_||____/ |___|___|                

*/                                                                                     

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "hardhat/console.sol";

contract TPGMembershipToken is ERC721 {

    uint256 currentMemberCount;

    constructor() ERC721("The People's Gym Membership", "TPG") {
        currentMemberCount = 0;
    }

    function mintMembership() public payable returns (uint256) {
        require(currentMemberCount < 3, "All memberships consumed.");
        _safeMint(msg.sender, currentMemberCount);
        currentMemberCount += 1;
        return currentMemberCount;
    }
}

contract TPG is IERC721Receiver {
    TPGMembershipToken public tokenContract;
    Treasury public treasury;

    constructor() {
        tokenContract = new TPGMembershipToken();
        treasury = new Treasury();
    }

    function mintMembership() public payable {
        console.log("mintMembership msg.value: ", msg.value);
        require(msg.value >= 1, "Mint price not met.");
        tokenContract.mintMembership();
        treasury.deposit{ value: msg.value }();
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function getTreasuryBalance() public view returns (uint256) {
        return treasury.getBalance();
    }
}

contract Treasury {
    uint256 public totalReserves;

    function deposit() public payable {
        totalReserves = totalReserves + msg.value;
        console.log("Total reserves: ", totalReserves);
    }

    function getBalance() public view returns (uint256) {
        return totalReserves;
    }
}
