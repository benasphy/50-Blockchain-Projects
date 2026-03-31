// script/Deploy.s.sol
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Token.sol";
import "../src/FlashLoanPool.sol";
import "../src/FlashBorrower.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        Token token = new Token("FlashToken", "FLT", 1_000_000 ether);

        FlashLoanPool pool = new FlashLoanPool(address(token));

        FlashBorrower borrower =
            new FlashBorrower(address(token), address(pool));

        // Fund pool
        token.transfer(address(pool), 500_000 ether);

        vm.stopBroadcast();
    }
}