// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import './interfaces/IERC721Metadata.sol';
import './ERC165.sol';

// ERC721 optional metadata extension
contract ERC721Metadata is IERC721Metadata, ERC165 {
  string private _name;
  string private _symbol;
  mapping (uint => string) private _tokenURI;

  constructor(string memory __name, string memory __symbol) {
    _name = __name;
    _symbol = __symbol;

    // TODO: adds supported interface id. 
    // This way of doing it is deprected. Learning exercise only
    registerInterface(bytes4(
            keccak256('name(bytes4)') 
            ^ keccak256('symbol(bytes4)')
            ^ keccak256('tokenURI(bytes4)')
            ));
  }

  function name() external view returns (string memory) {
    return _name;
  }

  function symbol() external view returns (string memory) {
    return _symbol;
  }

  // TODO: redo proper implementaion 
  function tokenURI(uint _tokenId) external view returns (string memory) {
    return _tokenURI[_tokenId];
  }
}
