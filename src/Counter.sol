// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 private count;

    constructor (uint _count) {
      count = _count;
    }

    function incrementCounter() public {
      count += 1;
    }

    function decrementCounter() public {
      count -= 1;
    }

    function getCounter() public view returns(uint256){
      return count;
    }
}
