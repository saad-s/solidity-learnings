const erc721_tradables = artifacts.require("ERC721Tradables");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("ERC721Tradables", function (/* accounts */) {
  it("should assert true", async function () {
    await erc721_tradables.deployed();
    return assert.isTrue(true);
  });
});

