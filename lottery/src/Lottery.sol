// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lottery {
    address public manager;
    address[] public players;

    event Entered(address indexed player);
    event WinnerPicked(address indexed winner, uint256 amount);

    modifier onlyManager(){
        require(msg.sender == manager, "Not manager");
        _;
    }
    constructor() {
        manager = msg.sender;
    }

    /// ENTER LOTTERY (minimum 0.01 ETH)
    function enter() external payable {
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH");
        players.push(msg.sender);

        emit Entered(msg.sender);
    }

    /// PICK WINNER (manager only)
    function pickWinner() external {
        require(msg.sender == manager, "Only manager");
        require(players.length > 0, "No players");

        uint256 randomIndex = _random() % players.length;
        address winner = players[randomIndex];

        uint256 prize = address(this).balance;
        payable(winner).transfer(prize);

        emit WinnerPicked(winner, prize);

        // reset lottery
        delete players;
    }

    /// INTERNAL PSEUDO-RANDOMNESS
    function _random() internal view returns (uint256) {
        return uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    players.length
                )
            )
        );
    }

    function getPlayers() external view returns (address[] memory) {
        return players;
    }
}
