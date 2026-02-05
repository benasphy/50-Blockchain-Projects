// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Voting.sol";

contract VotingScript is Script {
    function run() external {
        // Load private key from env (Anvil default key works too)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy contract
        Voting voting = new Voting();
        console.log("Voting contract deployed at:", address(voting));

        // Add candidates (owner only)
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");
        voting.addCandidate("Charlie");

        // Cast a vote (deployer votes)
        voting.vote(1); // votes for Bob

        vm.stopBroadcast();
    }
}
