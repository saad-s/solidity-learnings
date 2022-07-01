// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Ownable {
  address payable public owner;
  
  constructor () {
    owner = payable (msg.sender);
  }
}

contract HotelRoomBooking is Ownable {
  // room can be vacant or booked, 
  // ignoring other states for now 
  enum Status {
    Vacant,
    Booked
  }
  // struct to keep room details 
  struct RoomStatus {
    Status status;
    // guest address, TODO: is there an optinal like type?
    address guest;
  }
  // total rooms in hotel
  uint public totalRooms;
  // booking price, TODO: use ether unit for this 
  uint public price;
  // mapping for room number and details
  mapping (uint => RoomStatus) public Rooms;
  
  constructor(uint _totalRooms, uint _price) {
    totalRooms = _totalRooms;
    price = _price;
    for(uint i = 0; i < totalRooms; i++) {
      // TODO: needed? default is already 0
      Rooms[i].status = Status.Vacant;
    }
    // init ownable constructor
    super;
  }

  modifier isVacant(uint _number) {
    require(Rooms[_number].status == Status.Vacant, "Already Booked");
    _;
  }

  modifier pricePaid() {
    require(msg.value >= price, "Not enough ether sent");
    _;
  }

  /// returns room details, given room number
  function getRoomDetails(uint _number) public view returns (RoomStatus memory) {
    RoomStatus memory room = Rooms[_number]; 
    return room;
  }
  /// book a room 
  function bookRoom(uint _number) public payable isVacant(_number) pricePaid {
    // transfer amount and set booking details 
    Rooms[_number].status = Status.Booked;
    // TODO: should I use msg.sender or tx.origin in general?
    Rooms[_number].guest = msg.sender;
    owner.transfer(price);
  }
}
