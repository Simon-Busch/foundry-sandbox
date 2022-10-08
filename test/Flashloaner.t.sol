// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;
import "forge-std/Test.sol";

// forge test --match-contract FlashloanerTest -vvvv
contract FlashloanerTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testExample() public {
        assertTrue(true);
    }
}
