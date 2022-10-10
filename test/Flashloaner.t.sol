// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/test/utils/mocks/MockERC20.sol";
import "../src/Flashloaner.sol";

contract TokenReturner {
    uint256 return_amount;

    function receiveTokens(
        address tokenAddress,
        uint256 /* amount */
    ) external {
        ERC20(tokenAddress).transfer(msg.sender, return_amount);
    }
}

// forge test --match-contract FlashloanerTest -vvvv
contract FlashloanerTest is Test, TokenReturner {
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
        vm.expectRevert(
            Flashloaner.Flashloaner__TokenAddressCannotBeZero.selector
        );
        new Flashloaner(zeroAddress); // address(0) == address(0x0)
    }

    function test_poolBalance() public {
        token.approve(address(loaner), 1);
        loaner.depositTokens(1);
        assertEq(loaner.poolBalance(), 101);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    // run only this test: forge test -vvvvv -m test_DepositNonZeroAndRevert
    function test_DepositNonZeroAndRevert() public {
        vm.expectRevert(
            Flashloaner.Flashloaner__MustDepositOneTokenMinimum.selector
        );
        loaner.depositTokens(0);
    }

    function test_BorrowZeroRevert() public {
        vm.expectRevert(
            Flashloaner.Flashloaner__MustBorrowOneTokenMinimum.selector
        );
        loaner.flashLoan(0);
    }

    function test_BorrowMoreRevert() public {
        vm.expectRevert(
            Flashloaner.Flashloaner__NotEnoughTokensInPool.selector
        );
        loaner.flashLoan(2**250); // definitely not enough in the pool !
    }

    function test_ReturnAmountRevert() public {
        vm.expectRevert(
            Flashloaner.Flashloaner__FlashLoanHasNotBeenPaidBack.selector
        );
        return_amount = 0; // ref to contract TokenReturner
        loaner.flashLoan(100);
    }

    function test_flashLoan() public {
        return_amount = 100;
        loaner.flashLoan(100);
        assertEq(loaner.poolBalance(), 100);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    function test_OnlyOwnerRevert() public {
        vm.startPrank(player1);
        vm.expectRevert("not owner");
        loaner.updateOwner(player1);
        loaner.echoSender();
        vm.stopPrank();
    }

    function testFuzz_deposit(uint256 amount) public {
        vm.assume(type(uint256).max - amount >= token.totalSupply());
        vm.assume(amount > 0);

        token.mint(address(this), amount);
        token.approve(address(loaner), amount);

        uint256 preBalance = token.balanceOf(address(loaner));
        loaner.depositTokens(amount);

        assertEq(loaner.poolBalance(), preBalance + amount);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }
}
