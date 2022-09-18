// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EtherWallet.sol";

contract EtherWalletTest is Test {
    EtherWallet public etherWallet;
    address player1 = address(1);
    address player2 = address(2);
    address player3 = address(3);

    function setUp() public {
        etherWallet = new EtherWallet();
        vm.deal(player1, 5 ether);
        vm.deal(player2, 5 ether);
        vm.deal(player3, 5 ether);
    }

    function testDepositEth() public {
        vm.startPrank(player1);
        uint256 initialBalance = etherWallet.getBalance(player1);
        etherWallet.depositEth{value: 1 ether}();
        uint256 playerBalance = etherWallet.getBalance(player1);
        emit log_named_uint("Player balance", playerBalance);
        assertEq(initialBalance, 0 ether);
        assertEq(playerBalance, 1 ether);
        assertLt(initialBalance, playerBalance);
        vm.stopPrank();

        vm.startPrank(player2);
        uint256 player2Balance = etherWallet.getBalance(player2);
        assertEq(player2Balance, 0);
        vm.stopPrank();

        vm.startPrank(player3);
        vm.expectRevert(
            abi.encodeWithSelector(
                EtherWallet.EtherWallet__NotEnoughEthSent.selector,
                player3,
                0
            )
        );
        etherWallet.depositEth{value: 0}();
        vm.stopPrank();
    }

    function testWithdraw() public {
        // revert if no balance
        vm.startPrank(player1);
        uint256 initialBalance = etherWallet.getBalance(player1);
        emit log_named_uint("Player initial balance", initialBalance);
        vm.expectRevert(
            abi.encodeWithSelector(
                EtherWallet.EtherWallet__NotEnoughFunds.selector,
                player1,
                0
            )
        );
        etherWallet.withdraw(1000000000000000000);
        vm.stopPrank();

        //pass if player has deposited
        vm.startPrank(player2);
        etherWallet.depositEth{value: 1 ether}();
        uint256 initialBalancePlayer2 = etherWallet.getBalance(player2);
        etherWallet.withdraw(500000000000000000); // 0.5 eth
        uint256 updatedBalance = etherWallet.getBalance(player2);
        emit log_named_uint("Player2 initial blance", initialBalancePlayer2);
        emit log_named_uint("Player2 balance after withdraw", updatedBalance);
        assertGe(initialBalancePlayer2, updatedBalance);
        assertEq(updatedBalance, 0.5 ether);
        vm.stopPrank();

        // make sure you can withdraw more than you have
        vm.startPrank(player3);
        etherWallet.depositEth{value: 0.5 ether}();
        vm.expectRevert(
            abi.encodeWithSelector(
                EtherWallet.EtherWallet__NotEnoughFunds.selector,
                player3,
                500000000000000000
            )
        );
        etherWallet.withdraw(600000000000000000); // 1.5 eth
        vm.stopPrank();
    }

    function testGetBalance() public {
        vm.startPrank(player1);
        uint256 initialBalancePlayer1 = etherWallet.getBalance(player1);
        assertEq(initialBalancePlayer1, 0);

        etherWallet.depositEth{value: 1 ether}();
        uint256 updatedBalance = etherWallet.getBalance(player1);
        assertEq(updatedBalance, 1 ether);
    }
}
