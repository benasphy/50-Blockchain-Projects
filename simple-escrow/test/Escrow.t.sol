// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow escrow;

    address buyer = address(1);
    address seller = address(2);
    address arbiter = address(3);

    function setUp() public {
        vm.deal(buyer, 10 ether);

        vm.prank(buyer);
        escrow = new Escrow{value: 1 ether}(seller, arbiter);
    }

    function testInitialState() public {
        assertEq(escrow.buyer(), buyer);
        assertEq(escrow.seller(), seller);
        assertEq(escrow.arbiter(), arbiter);
        assertEq(address(escrow).balance, 1 ether);
    }

    function testReleaseToSeller() public {
        uint256 sellerBalanceBefore = seller.balance;

        vm.prank(buyer);
        escrow.releaseToSeller();

        assertTrue(escrow.isReleased());
        assertEq(seller.balance, sellerBalanceBefore + 1 ether);
    }

    function testRefundToBuyer() public {
        uint256 buyerBalanceBefore = buyer.balance;

        vm.prank(arbiter);
        escrow.refundToBuyer();

        assertTrue(escrow.isRefunded());
        assertEq(buyer.balance, buyerBalanceBefore + 1 ether);
    }

    function testCannotDoubleResolve() public {
        vm.prank(buyer);
        escrow.releaseToSeller();

        vm.prank(arbiter);
        vm.expectRevert();
        escrow.refundToBuyer();
    }
}
