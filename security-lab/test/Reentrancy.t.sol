// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/Attacker.sol";

contract ReentrancyTest is Test {
    Vault vault;
    Attacker attacker;

    function setUp() public {
        vault = new Vault();

        // fund vault
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 10 ether}();

        attacker = new Attacker(address(vault));
    }

    function testAttack() public {
        vm.deal(address(attacker), 1 ether);

        vm.prank(address(attacker));
        attacker.attack{value: 1 ether}();

        assertGt(address(attacker).balance, 1 ether);
    }
}