// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";

contract Flashloaner is ReentrancyGuard {
    ERC20 public immutable damnValuableToken;
    uint256 public poolBalance;

    error Flashloaner__TokenAddressCannotBeZero();
    error Flashloaner__MustDepositOneTokenMinimum();

    constructor(address tokenAddress) {
        if (tokenAddress == address(0))
            revert Flashloaner__TokenAddressCannotBeZero();
        damnValuableToken = ERC20(tokenAddress);
    }

    function depositTokens(uint256 amount) external nonReentrant {
        if(amount == 0) revert Flashloaner__MustDepositOneTokenMinimum();
        damnValuableToken.transferFrom(msg.sender, address(this), amount);
        poolBalance = poolBalance + amount;
    }
}
