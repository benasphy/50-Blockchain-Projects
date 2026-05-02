// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PaymentChannel {
    address public sender;
    address public receiver;

    uint256 public deposited;
    uint256 public expiration;

    bool public closed;

    constructor(address _receiver, uint256 _duration) payable {
        sender = msg.sender;
        receiver = _receiver;
        deposited = msg.value;
        expiration = block.timestamp + _duration;
    }

    // hash message for signing
    function getMessageHash(uint256 amount) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), amount));
    }

    function getEthSignedHash(bytes32 msgHash) public pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash)
        );
    }

    function verify(
        uint256 amount,
        bytes memory signature
    ) public view returns (bool) {
        bytes32 msgHash = getMessageHash(amount);
        bytes32 ethHash = getEthSignedHash(msgHash);

        (bytes32 r, bytes32 s, uint8 v) = split(signature);

        return ecrecover(ethHash, v, r, s) == sender;
    }

    function split(bytes memory sig)
        internal
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "bad sig");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    // receiver closes channel with latest signed state
    function close(uint256 amount, bytes memory signature) external {
        require(msg.sender == receiver, "not receiver");
        require(!closed, "closed");
        require(verify(amount, signature), "invalid sig");

        closed = true;

        payable(receiver).transfer(amount);
        payable(sender).transfer(address(this).balance);
    }

    // sender can reclaim funds after expiration
    function cancel() external {
        require(msg.sender == sender, "not sender");
        require(block.timestamp >= expiration, "not expired");
        require(!closed, "already closed");

        closed = true;

        payable(sender).transfer(address(this).balance);
    }
}