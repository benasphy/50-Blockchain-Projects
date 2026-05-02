// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PaymentChannel.sol";

contract ChannelTest is Test {
    address sender = address(1);
    address receiver = address(2);

    uint256 senderPk = 0xA11CE;

    PaymentChannel channel;

    function setUp() public {
        sender = vm.addr(senderPk);

        vm.deal(sender, 10 ether);

        vm.prank(sender);
        channel = new PaymentChannel{value: 10 ether}(
            receiver,
            1 days
        );
    }

    function sign(uint256 amount) internal returns (bytes memory) {
        bytes32 hash = channel.getMessageHash(amount);
        bytes32 ethHash = channel.getEthSignedHash(hash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(senderPk, ethHash);

        return abi.encodePacked(r, s, v);
    }

    function testCloseChannel() public {
        uint256 amount = 5 ether;

        bytes memory sig = sign(amount);

        vm.prank(receiver);
        channel.close(amount, sig);

        assertEq(receiver.balance, amount);
    }

    function testCancelAfterExpiry() public {
        vm.warp(block.timestamp + 2 days);

        vm.prank(sender);
        channel.cancel();

        assertEq(sender.balance, 10 ether);
    }
}