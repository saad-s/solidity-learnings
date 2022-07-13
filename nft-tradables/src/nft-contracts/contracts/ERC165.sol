// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {
  // mapping of supported interfaces hash
  mapping (bytes4 => bool) private _supportedInterfaces;
  
  constructor() {
    registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
  }

  function supportsInterface(bytes4 interfaceID) external view returns (bool) {
    return _supportedInterfaces[interfaceID];
  }

  function registerInterface(bytes4 interfaceID) internal {
    require(interfaceID != 0xffffffff, 'ERC165: invalid interfaceID');
    _supportedInterfaces[interfaceID] = true;
  }
}