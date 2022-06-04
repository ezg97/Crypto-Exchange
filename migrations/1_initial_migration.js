// Migrations changges the blockchains state. Or migrating the blockchains state, similar to database migrations (e.g. adding columns, table, etc.)
const Migrations = artifacts.require("Migrations");
// this file deploys contracts/Migrations.sol
module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
