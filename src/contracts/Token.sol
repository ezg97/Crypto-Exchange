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
    event Approval(address indexed owner, address indexed spender, uint256 value);
    // track balances. mapping is like a key-value-pair hash, dictionary
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

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
        require(balanceOf[msg.sender] >= _value);
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0));
        // decrease sender's balance
        balanceOf[_from] = balanceOf[_from].sub(_value);
        // increase sender's balance
        balanceOf[_to] = balanceOf[_to].add(_value);

        emit Transfer(_from, _to, _value);

    }

    // Approve tokens
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    // Transfer from
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        
        return true;
    }

}