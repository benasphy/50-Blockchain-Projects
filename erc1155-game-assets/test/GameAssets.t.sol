// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameAssets.sol";

contract GameAssetsTest is Test {

    GameAssets assets;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        assets = new GameAssets("ipfs://game-metadata/");
    }

    function testMint() public {

        assets.mint(alice, 1, 100);

        assertEq(assets.balanceOf(alice, 1), 100);
    }

    function testTransfer() public {

        assets.mint(alice, 1, 100);

        vm.prank(alice);
        assets.safeTransferFrom(alice, bob, 1, 20);

        assertEq(assets.balanceOf(bob, 1), 20);
    }

    function testBatchTransfer() public {

        assets.mint(alice, 1, 100);
        assets.mint(alice, 2, 50);

        uint256;
        ids[0] = 1;
        ids[1] = 2;

        uint256;
        amounts[0] = 20;
        amounts[1] = 10;

        vm.prank(alice);
        assets.safeBatchTransferFrom(alice, bob, ids, amounts);

        assertEq(assets.balanceOf(bob, 1), 20);
        assertEq(assets.balanceOf(bob, 2), 10);
    }
}