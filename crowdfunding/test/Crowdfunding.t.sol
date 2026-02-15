// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Crowdfunding.sol";

contract CrowdfundingTest is Test {
    Crowdfunding campaign;

    address creator = address(this);
    address contributor1 = address(1);
    address contributor2 = address(2);

    function setUp() public {
        campaign = new Crowdfunding(5 ether, 60);

        vm.deal(contributor1, 10 ether);
        vm.deal(contributor2, 10 ether);
    }

    function testContribution() public {
        vm.prank(contributor1);
        campaign.contribute{value: 1 ether}();

        assertEq(campaign.totalRaised(), 1 ether);
    }

    function testSuccessfulCampaign() public {
        vm.prank(contributor1);
        campaign.contribute{value: 3 ether}();

        vm.prank(contributor2);
        campaign.contribute{value: 2 ether}();

        vm.warp(block.timestamp + 61);

        campaign.withdrawFunds();

        assertTrue(campaign.fundsWithdrawn());
    }

    function testRefund() public {
        vm.prank(contributor1);
        campaign.contribute{value: 1 ether}();

        vm.warp(block.timestamp + 61);

        vm.prank(contributor1);
        campaign.claimRefund();

        assertEq(campaign.contributions(contributor1), 0);
    }
}
