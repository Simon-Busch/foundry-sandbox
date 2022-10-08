// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;
import "forge-std/Test.sol";
import "solmate/test/utils/mocks/MockERC20.sol";
import "../src/Flashloaner.sol";

// forge test --match-contract FlashloanerTest -vvvv
contract FlashloanerTest is Test {
    address player1 = address(100);
    address player2 = address(102);
    address zeroAddress = address(0);

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
        token.approve(address(loaner), 100);
        loaner.depositTokens(100);
    }

    function test_ConstructorNonZeroTokenRevert() public {
        // vm.expectRevert(abi.encodeWithSelector(
        //   Flashloaner.Flashloaner__TokenAddressCannotBeZero.selector
        // ));
        vm.expectRevert(Flashloaner.Flashloaner__TokenAddressCannotBeZero.selector);
        new Flashloaner(zeroAddress); // address(0) == address(0x0)
    }

    function test_poolBalance() public {
      token.approve(address(loaner), 1);
      loaner.depositTokens(1);
      assertEq(loaner.poolBalance(), 101);
      assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    function test_DepositNonZeroAndRevert() public {
      vm.expectRevert(Flashloaner.Flashloaner__MustDepositOneTokenMinimum.selector);
      loaner.depositTokens(0);
    }
}
