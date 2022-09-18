// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

  // Basic example of Wallet:
  // - Anyone can send ETH
  // - Only the owner can withdraw
error EtherWallet__NotEnoughEthSent(address sender, uint256 amount);

contract EtherWallet {
  mapping(address => uint256) public deposit;

  function deposit() public payable {
    require (msg.value >= 0) {
      revert EtherWallet__NotEnoughEthSent(msg.sender, msg.value);
    }
    deposit[msg.sender] += msg.value;
  }

  function withdraw() public {

  }
}
