// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Counter} from "src/Counter.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast(); // start the contract
        new Counter(10);
        vm.stopBroadcast(); // stop
    }
}

// How does it work ?

// in a terminal run anvil to start local node

// in second window run :
// forge script script/Counter.s.sol --fork-url http://localhost:8545 --private-key xxxx
// if you add --broadcast at the end to deploy the contract
// -> NB: refer to vm.broadcast method
// Will return a contract address [0x5fbdb2315678afecb367f032d93f642f64180aa3]


// Then what ?
// We can make cast call
// cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "getCounter()(uint256)" methodName(params?)(return type)
// Send transactions:
// cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "incrementCounter()" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
// cast send CONTRACT_ADDRESS "METHOD" --private-key PRIVATE_KEY
