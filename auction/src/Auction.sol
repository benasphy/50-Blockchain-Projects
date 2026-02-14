// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Auction {
    address public seller;
    uint256 public auctionEndTime;

    address public highestBidder;
    uint256 public highestBid;

    bool public ended;

    mapping(address => uint256) public pendingReturns;

    event HighestBidIncreased(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    modifier onlyBeforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction ended");
        _;
    }

    modifier onlyAfterEnd() {
        require(block.timestamp >= auctionEndTime, "Auction not yet ended");
        _;
    }

    constructor(uint256 _biddingTimeInSeconds) {
        seller = msg.sender;
        auctionEndTime = block.timestamp + _biddingTimeInSeconds;
    }

    /// Place a bid
    function bid() external payable onlyBeforeEnd {
        require(msg.value > highestBid, "Bid too low");

        // Refund previous highest bidder
        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw overbid funds
    function withdraw() external returns (bool) {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingReturns[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
        return true;
    }

    /// End auction and send funds to seller
    function endAuction() external onlyAfterEnd {
        require(!ended, "Auction already ended");

        ended = true;

        payable(seller).transfer(highestBid);

        emit AuctionEnded(highestBidder, highestBid);
    }
}
