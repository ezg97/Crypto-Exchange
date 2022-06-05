export const EVM_REVERT = "VM Exception while processing transaction: revert";

export const ETHER_ADDRESS = '0x0000000000000000000000000000000000000000';

export const ether = (n) => {
    // converts normal numbers to Wei (18 trailing zeros)
    return new web3.utils.BN(
        web3.utils.toWei(n, 'ether')
    );
}

// same as ether
export const tokens = (n) => ether(n);