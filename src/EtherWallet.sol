// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

  // Basic example of Wallet:
  // - Anyone can send ETH
  // - Only the owner can withdraw

contract EtherWallet {
  error EtherWallet__NotEnoughEthSent(address sender, uint256 amount);
  error EtherWallet__NotEnoughFunds(address sender, uint256 balance);

  mapping(address => uint256) public balances;

  function depositEth() public payable {
    if (msg.value <= 0) {
      revert EtherWallet__NotEnoughEthSent(msg.sender, msg.value);
    }
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint256 amount) public {
    uint256 balance = balances[msg.sender];
    if(balance <= amount) {
      revert EtherWallet__NotEnoughFunds(msg.sender, balance);
    }
    (bool success, ) = payable(msg.sender).call{value: amount}("");
    require (success);
    balances[msg.sender] -= amount;
  }

  function getBalance(address _address) public view returns (uint256) {
      return balances[_address];
  }
}
