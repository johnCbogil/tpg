// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Treasury {
    uint256 totalReserves;

    function deposit() public payable {
        totalReserves = totalReserves + msg.value;
    }

    function getBalance() public view returns (uint256) {
        return totalReserves;
    }
}