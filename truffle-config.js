require("babel-register");
require("babel-polyfill");
require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
const privateKeys = process.env.PRIVATE_KEYS || "";

const fs = require('fs');
const mnemonic = fs.readFileSync('.secret').toString().trim();

module.exports = {

  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Ganache
     network_id: "*",       // Any network (default: none)
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(
          // Private key
          // privateKeys.split(","), // Array account of private keys
          mnemonic,
          // URL to Ethereum node
          `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`
        )
      },
      gas: 5000000,
      gasPrice: 25000000000,
      // main net is 1
      network_id: 42,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },
  contracts_directory: './src/contracts',
  contracts_build_directory: './src/abis/',

  // Configure your compilers
  compilers: {
    solc: {
       optimizer: {
         enabled: false,
         runs: 200
       },

    }
  },


};
