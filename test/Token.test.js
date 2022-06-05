import { tokens, EVM_REVERT } from './helpers';

const Token = artifacts.require("./Token");

require('chai')
    .use(require('chai-as-promised'))
    .should();

contract('Token ', ([deployer, sender, receiver]) => {
    let token;
    const name = "Mountain Token";
    const symbol = "MTN";
    const decimals = '18';
    const totalSupply = tokens('1000000').toString();

    beforeEach(async () => {
        //fetch token from blockchain
        token = await Token.new();
    })

    describe('deployment', () => {
        it('tracks the name', async () => {
            //Read Token name
            const result = await token.name();
            // check the token name is "Crypto Exchange"
            result.should.equal(name);
        });

        it('tracks the symbol', async () => {
            const result = await token.symbol();
            result.should.equal(symbol);

        });

        it('tracks the decimals', async () => {
            const result = await token.decimals();
            result.toString().should.equal(decimals);
        });

        it('tracks the total supply', async () => {
            const result = await token.totalSupply();
            result.toString().should.equal(totalSupply);
        });

        it('assigns the total supply to the deployer', async () => {
            const result = await token.balanceOf(deployer);
            result.toString().should.equal(totalSupply);
        });
    });

    describe('Sending Tokens', () => {
        let amount;
        let result;

        describe('success', async () => {
            beforeEach(async () => {
                amount = tokens('100');
                result = await token.transfer(receiver, amount, { from: deployer });
            });
    
            it('transfers token balances', async () => {
                let balanceOf
    
                balanceOf = await token.balanceOf(deployer);
                balanceOf.toString().should.equal(tokens("999900").toString());
    
                balanceOf = await token.balanceOf(receiver);
                balanceOf.toString().should.equal(tokens("100").toString());
            });
    
            it('emits a transfer event', async () => {
                const log = result.logs[0];
                log.event.should.eq('Transfer');
    
                const event = log.args;
                event.from.toString().should.equal(deployer, 'from is correct');
                event.to.should.equal(receiver, 'to is correct');
                event.value.toString().should.equal(amount.toString(), 'value is correct');
            });
        });

        describe('failure', async () => {

            it('rejects insufficient balances - sender doesn\'t have enough tokens', async () => {
                let invalidAmount;
                invalidAmount = tokens('100000000'); // 100 millino greater than total supply
                await token.transfer(receiver, invalidAmount.toString(), { from: deployer }).should.be.rejectedWith(EVM_REVERT);
            });

            it('rejects insufficient balances - sender has no tokens', async () => {
                let invalidAmount;
                invalidAmount = tokens("10");
                await token.transfer(deployer, invalidAmount.toString(), { from: sender }).should.be.rejectedWith(EVM_REVERT);
            });

            it('rejects invalid recipients', async () => {
                let invalidAddress = '0x0000000000000000000000000000000000000000'
                await token.transfer(invalidAddress, amount.toString(), { from: deployer }).should.be.rejectedWith(EVM_REVERT);
            });
        });


        
    })
})