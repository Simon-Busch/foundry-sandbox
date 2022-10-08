// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;
import "forge-std/Test.sol";
import "solmate/test/utils/mocks/MockERC20.sol";
import "../src/Flashloaner.sol";

// forge test --match-contract FlashloanerTest -vvvv
contract FlashloanerTest is Test {
    address player1 = address(100);
    address player2 = address(102);
    address maliciousAddress = address(0);

    MockERC20 token;
    Flashloaner loaner;

    function setUp() public {
        vm.label(player1, "Simon");
        vm.label(player2, "Bob");
        vm.label(address(this), "Test contract");

        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");

        loaner = new Flashloaner(address(token));

        token.mint(address(this), 1e18);
    }

    function testExample() public {
        assertTrue(true);
    }
}
