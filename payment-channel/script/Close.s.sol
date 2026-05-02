// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PaymentChannel.sol";

contract Close is Script {
    function run() external {
        vm.startBroadcast();

        PaymentChannel channel = PaymentChannel(
            vm.envAddress("CHANNEL")
        );

        uint256 amount = vm.envUint("AMOUNT");
        bytes memory sig = vm.envBytes("SIG");

        channel.close(amount, sig);

        vm.stopBroadcast();
    }
}