const ERC721Tradables = artifacts.require("ERC721Tradables");

module.exports = function (deployer) {
  deployer.deploy(ERC721Tradables);
};
