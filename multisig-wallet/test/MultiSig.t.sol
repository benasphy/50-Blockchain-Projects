// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MultiSigWallet.sol";

contract MultiSigTest is Test {

    MultiSigWallet wallet;

    address owner1 = address(1);
    address owner2 = address(2);
    address owner3 = address(3);

    function setUp() public {

        address;
        owners[0] = owner1;
        owners[1] = owner2;
        owners[2] = owner3;

        wallet = new MultiSigWallet(owners, 2);

        vm.deal(address(wallet), 10 ether);
    }

    function testSubmitConfirmExecute() public {

        vm.prank(owner1);
        wallet.submit(address(100), 1 ether, "");

        vm.prank(owner1);
        wallet.confirm(0);

        vm.prank(owner2);
        wallet.confirm(0);

        vm.prank(owner1);
        wallet.execute(0);

        assertEq(address(100).balance, 1 ether);
    }
}