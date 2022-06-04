const Token = artifacts.require("Token");

module.exports = function (deployer) {
  deployer.deploy(Token);
};
// it always costs gas to deploy a contract to the blockchain, because you're creating a transaction
