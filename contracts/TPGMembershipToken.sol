// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

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