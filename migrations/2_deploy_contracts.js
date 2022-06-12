const Token = artifacts.require("Token");
const Exchange = artifacts.require("Exchange");

module.exports = async function(deployer) {
  // array of all the accounts
  const accounts = await web3.eth.getAccounts();

  await deployer.deploy(Token);

  const feeAccount = accounts[0];
  const feePercent = 10;
  // wehn deploying the exchange, also send the arguments for the constructor
  await deployer.deploy(Exchange, feeAccount, feePercent);
};
// it always costs gas to deploy a contract to the blockchain, because you're creating a transaction
// truffle migrate: deploys smart contract to the blockchain
// truffle migrate --reset: exisiting copy of smart contract already exists, deploys a new copy onto the blockchain since there's no way to update. It deploys a new copy with a new address