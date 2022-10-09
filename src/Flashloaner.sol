// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";

contract Flashloaner is ReentrancyGuard {
    ERC20 public immutable damnValuableToken;
    uint256 public poolBalance;
    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    error Flashloaner__TokenAddressCannotBeZero();
    error Flashloaner__MustDepositOneTokenMinimum();
    error Flashloaner__MustBorrowOneTokenMinimum();
    error Flashloaner__NotEnoughTokensInPool();
    error Flashloaner__FlashLoanHasNotBeenPaidBack();

    constructor(address tokenAddress) {
        if (tokenAddress == address(0))
            revert Flashloaner__TokenAddressCannotBeZero();
        damnValuableToken = ERC20(tokenAddress);
        owner = msg.sender;
    }

    function depositTokens(uint256 amount) external nonReentrant {
        if (amount == 0) revert Flashloaner__MustDepositOneTokenMinimum();
        damnValuableToken.transferFrom(msg.sender, address(this), amount);
        poolBalance = poolBalance + amount;
    }

    function flashLoan(uint256 borrowAmount) external nonReentrant {
        if (borrowAmount == 0) revert Flashloaner__MustBorrowOneTokenMinimum();

        uint256 balanceBefore = damnValuableToken.balanceOf(address(this));
        if (balanceBefore < borrowAmount)
            revert Flashloaner__NotEnoughTokensInPool();

        assert(poolBalance == balanceBefore);

        damnValuableToken.transfer(msg.sender, borrowAmount);

        IReceiver(msg.sender).receiveTokens(
            address(damnValuableToken),
            borrowAmount
        );

        uint256 balanceAfter = damnValuableToken.balanceOf(address(this));
        if (balanceAfter < balanceBefore)
            revert Flashloaner__FlashLoanHasNotBeenPaidBack();
    }

    function updateOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function echoSender() public view returns (address) {
        return msg.sender;
    }
}

interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}
