// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
  // list of all tokens 
  uint[] private _totalSupply;
  // mapping of token ids to indices in _totalSupply list 
  mapping (uint => uint) private _tokenIndex;
  // mapping of owner to list of all tokens owned by owner 
  mapping (address => uint[]) private _ownedTokens;
  // mapping from token id to index of the owner token list
  mapping (uint => uint) private _ownedTokensIndex;

  constructor() {
    // TODO: adds supported interface id. 
    // This way of doing it is deprected. Learning exercise only
    registerInterface(bytes4(
        keccak256('totalSupply(bytes4)') 
        ^ keccak256('tokenByIndex(bytes4)')
        ^ keccak256('tokenOfOwnerByIndex(bytes4)')
        ));
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply.length;
  }

  function tokenByIndex(uint256 _index) external view returns (uint256) {
    require(_index < totalSupply(), 'ERC721Enumerable: index out of bound');
    // return the token id at index'th position of total supply array
    return _totalSupply[_index];
  }

  function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
    require(_index < balanceOf(_owner), 'ERC721Enumerable: index out of bound');
    // return the token id at index'th position in owned token list
    return _ownedTokens[_owner][_index];
  }

  function _updateTokenEnumerations(uint _tokenId) private {
    // update total supply 
    _totalSupply.push(_tokenId); 
    // update token id to index mapping 
    _tokenIndex[_tokenId] = _totalSupply.length - 1; 
  }

  function _updateOwnerEnumerations(address _owner, uint _tokenId) private {
    // update token list of owner 
    _ownedTokens[_owner].push(_tokenId); 
    // update token to index mapping of owner list 
    _ownedTokensIndex[_tokenId] = _ownedTokens[_owner].length - 1; 
  }

  function _mint (address _to, uint _tokenId) internal override(ERC721) {
    // mint token
    super._mint(_to, _tokenId);
    // update enumerations 
    _updateTokenEnumerations(_tokenId);
    _updateOwnerEnumerations(_to, _tokenId);
  }

  function _burn(uint _tokenId) internal override(ERC721) {
    // burn token 
    super._burn(_tokenId);
    // TODO: update enumerations 
  }
}