// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Proxy.sol";
import "../src/BoxV1.sol";
import "../src/BoxV2.sol";

contract UUPSTest is Test {
    BoxV1 box;
    address owner = address(1);

    function setUp() public {
        vm.startPrank(owner);

        BoxV1 impl = new BoxV1();

        bytes memory data = abi.encodeWithSelector(
            BoxV1.initialize.selector,
            100
        );

        Proxy proxy = new Proxy(address(impl), data);

        box = BoxV1(address(proxy));

        vm.stopPrank();
    }

    function testInitial() public {
        assertEq(box.value(), 100);
    }

    function testUpgrade() public {
        vm.startPrank(owner);

        BoxV2 newImpl = new BoxV2();
        box.upgradeTo(address(newImpl));

        BoxV2 upgraded = BoxV2(address(box));
        upgraded.increment();

        assertEq(upgraded.value(), 101);

        vm.stopPrank();
    }
}