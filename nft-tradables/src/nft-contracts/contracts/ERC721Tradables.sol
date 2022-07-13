// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// import metadata standard
import './ERC721Connector.sol';

contract ERC721Tradables is ERC721Connector {

  mapping (uint => bool) public tradables;

  constructor() ERC721Connector ('tradeables', 'TRDBLS') {
  }

  /// mint a new tradable nft
  function mint(uint _tokenId) public {
    // verify if token id already exists 
    require(!tradables[_tokenId], 'ERC721Tradables: token id already minted');
    // mint the token id and assign to sender
    _mint(msg.sender, _tokenId);
    // mark token as minted
    tradables[_tokenId] = true;
  }
  
  /// burn the existing token 
  function burn(uint _tokenId) public {
    // check if token id exists
    require(tradables[_tokenId], 'ERC721Tradables: token id does not exist');
    // burn the token id 
    _burn(_tokenId);
    // update mapping
    tradables[_tokenId] = false;
  }
}
