const HotelRoomBooking = artifacts.require("HotelRoomBooking");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("HotelRoomBooking", function (/* accounts */) {
  it("should assert true", async function () {
    await HotelRoomBooking.deployed();
    return assert.isTrue(true);
  });
});
