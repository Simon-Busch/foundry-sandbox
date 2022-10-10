# Package
### Install Solmate
Gas optimizer
Cmd: `forge install transmissions11/solmate`
// https://github.com/transmissions11/solmate


### Debug
`forge debug  ./test/Flashloaner.t.sol --tc FlashloanerTest --sig "test_flashLoan()"`


## Gas
`forge test --gas-report`

## Deploy
 $ forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/MyContract.sol:MyContract
