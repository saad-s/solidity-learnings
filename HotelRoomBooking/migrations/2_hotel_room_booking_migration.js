const Ownable = artifacts.require("Ownable");
const HotelRoomBooking = artifacts.require("HotelRoomBooking");

module.exports = function (deployer) {
  deployer.deploy(Ownable).then( () => {
    return deployer.deploy(HotelRoomBooking, 10, 1);
  })
}
