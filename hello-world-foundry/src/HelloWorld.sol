// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract HelloWorld{
    string private message;

    event MessageUpdated(string oldMessage, string newMessage);

    constructor(string memory _message){
        message = _message;
    }

    function getMessage() external view returns(string memory){
        return message;
    }

    function setMessage(string calldata _newMessage) external{
        string memory old = message;
        message = _newMessage;
        emit MessageUpdated(old, _newMessage);
    }
}
