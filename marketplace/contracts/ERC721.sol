// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import './ERC165.sol';
import './interfaces/IERC721.sol';

// TODO: safeTransferFrom functions 

contract ERC721 is ERC165, IERC721 {
	// number of nfts per address
	mapping (address => uint) private _balanceOf;
	// owner address of nft
	mapping (uint => address) private _ownerOf;
	// token ids to approved addresses 
	mapping (uint => address) private _approvedFor;
	// owner to approved operators mapping 
	mapping (address => mapping (address => bool)) private _approvedForAll;

	constructor() {
		// TODO: adds supported interface id. 
		// This way of doing it is deprected. Learning exercise only
		registerInterface(bytes4
					(keccak256('balanceOf(bytes4)') 
					^ keccak256('ownerOf(bytes4)')
					// ^ keccak256('safeTransferFrom(bytes4)')
					// ^ keccak256('safeTransferFrom(bytes4)')
					^ keccak256('transferFrom(bytes4)')
					^ keccak256('approve(bytes4)')
					^ keccak256('setApprovalForAll(bytes4)')
					^ keccak256('getApproved(bytes4)')
					^ keccak256('isApprovedForAll(bytes4)')
					));
	}

	modifier _exists(uint _tokenId) {
		require(address(0) != _ownerOf[_tokenId], 'ERC721: token id does not exists');
		_;
	}

	modifier _zeroAddress (address addr) {
		require(address(0) != addr, 'ERC721: ZERO ADDRESS is not allowed');
		_;
	}

	function balanceOf(address _owner) public view _zeroAddress(_owner) returns (uint) {
		return _balanceOf[_owner];
	}

	function ownerOf(uint _tokenId) external view _exists(_tokenId) returns (address) {
		return _ownerOf[_tokenId];
	}

	function transferFrom(address _from, address _to, uint256 _tokenId) external _exists(_tokenId) _zeroAddress(_to) payable {
		// throws unless `msg.sender` is the current owner, an authorized
		// operator, or the approved address for this NFT.
		require(_isOwnerOrApproved(_tokenId), 'ERC721: only owner or approved address / operator can call');
		// throws if '_from' is not the current owner
		require(_from == _ownerOf[_tokenId], 'ERC721: invalid owner address');
		// transfer ownership
		_ownerOf[_tokenId] = _to;
		// update balances 
		_balanceOf[_from] -= 1;
		_balanceOf[_to] += 1;
		// emit transfer event 
		emit Transfer(_from, _to, _tokenId);
	}

	// TODO: can approved address transfer approval to another address?
	function approve(address _approved, uint256 _tokenId) external payable {
		// only owner or operator can approve 
		require(_isOwnerOrApproved(_tokenId), 'ERC721: only owner or approved address / operator can call');
		// approve for owner address 
		require(_approved != _ownerOf[_tokenId], 'ERC721: no need to approve for owner');
		// add approval and emit Approval event
		_approvedFor[_tokenId] = _approved;
		emit Approval(msg.sender, _approved, _tokenId);
	}

	function setApprovalForAll(address _operator, bool _approved) external {
		address owner = msg.sender;
		// approve for owner address 
		require(owner != _operator, 'ERC721: no need to approve for owner');
		_approvedForAll[owner][_operator] = _approved;
		emit ApprovalForAll(owner, _operator, _approved);
	}

	function getApproved(uint256 _tokenId) public view _exists(_tokenId) returns (address) {
		return _approvedFor[_tokenId];
	}

	function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
		return _approvedForAll[_owner][_operator];
	}

	// msg.sender is owner, or approved for this token id or an approved operator
	function _isOwnerOrApproved(uint _tokenId) internal view returns (bool) {
		address owner = _ownerOf[_tokenId];
		address sender = msg.sender;
		return (owner == sender || isApprovedForAll(owner, sender) || sender == getApproved(_tokenId));
	}

	function _mint(address _to, uint _tokenId) internal _zeroAddress(_to) virtual {
		// token id does not exist 
		require(address(0) == _ownerOf[_tokenId], 'ERC721: token id already minted');
		// set owner address
		_ownerOf[_tokenId] = _to;
		// update owner balance
		_balanceOf[_to] += 1;
		// emit transfer event
		emit Transfer(address(0), _to, _tokenId);
	}

	function _burn(uint _tokenId) internal _exists(_tokenId) virtual {
		address owner = _ownerOf[_tokenId];
		// sender is owner 
		require(msg.sender == owner, 'ERC721: only owner can call');
		// set to address zero
		_ownerOf[_tokenId] = address(0);
		// udpate owner balance
		_balanceOf[owner] -= 1;
		// emit transfer event 
		emit Transfer(owner, address(0), _tokenId);
	}
}
