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
        _safeMint(msg.sender, currentMemberCount);
        currentMemberCount += 1;
        return currentMemberCount;
    }

    function membershipAvailable() public view returns (bool) {
        return currentMemberCount < 3;
    }
}

contract TPG is IERC721Receiver {

    TPGMembershipToken tokenContract;
    Treasury treasury;

    constructor() {
        tokenContract = new TPGMembershipToken();
        treasury = new Treasury();
    }

    function mintMembership() public payable {
        require(msg.value >= 1000000000000000000, "Mint price not met.");
        require(tokenContract.membershipAvailable(), "All memberships consumed.");
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
    uint256 totalReserves;

    function deposit() public payable {
        totalReserves = totalReserves + msg.value;
    }

    function getBalance() public view returns (uint256) {
        return totalReserves;
    }
}
