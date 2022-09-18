// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
w

    function testContractSetup() public {
        uint256 value = counter.getCounter();
        assertEq(startCount, value);
        emit log_named_uint("Contract initialized with :", startCount);
    }

    function testGetCounter() public {
        uint256 value = counter.getCounter();
        assertEq(value, 10);
        emit log_named_uint("Counter value is :", value);
    }

    function testIncrementCounter() public {
      uint256 prevValue = counter.getCounter();
      counter.incrementCounter();
      uint256 newValue = counter.getCounter();
      assertEq(newValue, 11);
      assertLt(prevValue, newValue);
      emit log_named_uint("Counter value was :", prevValue);
      emit log_named_uint("Counter value is :", newValue);
    }

    function testDecrementCounter() public {
      uint256 prevValue = counter.getCounter();
      counter.decrementCounter();
      uint256 newValue = counter.getCounter();
      assertEq(newValue, 9);
      assertLt(newValue, prevValue);
      emit log_named_uint("Counter value was :", prevValue);
      emit log_named_uint("Counter value is :", newValue);
    }
}
