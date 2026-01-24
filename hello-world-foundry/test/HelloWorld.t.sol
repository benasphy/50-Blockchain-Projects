// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

contract HelloWorldTest is Test{
    HelloWorld hello;

    function setUp() public{
        hello = new HelloWorld("Hello World");
    }

    function testInitialMessage() public{
        string memory msgValue = hello.getMessage();
        assertEq(msgValue, "Hello World");
    }

    function testUpdateMessage() public{
        hello.setMessage("Hello Eduera");
        assertEq(hello.getMessage(), "Hello Eduera");
    }

    function test_Revert_When_UpdateMessage_Simple() public {
        hello.setMessage("Right");
        assertEq(hello.getMessage(), "Wrong");
    }
}
