pragma solidity ^0.5.0;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Token {
    using SafeMath for uint;

    // Variables
    // public generates a function to make this visible outside of this file
    string public name = "Mountain Token";
    string public symbol = "MTN";
    // unsigned integer w/ 256 bytes
    uint256 public decimals = 18;
    uint256 public totalSupply;

    // Events
    event Transfer(address from, address to, uint256 value);

    // track balances. mapping is like a key-value-pair hash, dictionary
    mapping(address => uint256) public balanceOf;

    // Send tokens

    // constructors must be public in order to work
    constructor() public {
        // everything is stored in decimals
        totalSupply = 1000000 * (10 ** decimals);

        // assign all tokens to the one who deploys the contract
        // msg.sender is the one who deploys the contract
        balanceOf[msg.sender] = totalSupply;
    }

    /*
        1: Decrease the senders balance by how much they're sending
        2: Increase the receivers balance by how much the sender is sending
        3: Return true if success or false if failure
    */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        //require a valid address and for the sender to have the tokens which they are sending
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);

        // decrease sender's balance
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        // increase sender's balance
        balanceOf[_to] = balanceOf[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    

}