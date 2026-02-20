// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/FaucetToken.sol";
import "../src/ERC20Faucet.sol";

contract DeployFaucet is Script {
    function run() external {
        vm.startBroadcast();

        FaucetToken token = new FaucetToken();
        ERC20Faucet faucet = new ERC20Faucet(address(token));

        token.setFaucet(address(faucet));

        vm.stopBroadcast();
    }
}