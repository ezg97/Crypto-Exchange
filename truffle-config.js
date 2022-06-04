require("babel-register");
require("babel-polyfill");
require("dotenv").config();

module.exports = {

  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Ganache
     network_id: "*",       // Any network (default: none)
    },
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
