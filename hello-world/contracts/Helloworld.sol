// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract name can be different from filename...
contract HelloWorld {
    // this is public
    string public message;
    // this is internal
    uint callCounter;
    // constructor doesn't need visibility, always public
    // memeory and storage for constructor
    constructor (string memory _message) {
        message = _message;
        callCounter = 0;
    }
    // functions require visbility and mutability. Return is optional
    function setMessage(string memory _message) public {
        message = _message;
        callCounter++;
    }
    /// returns internal variable's value
    function getCounter() public view returns(uint) {
        return callCounter;
    }
}