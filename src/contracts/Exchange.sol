pragma solidity ^0.5.0;
import "./Token.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


// Deposit & Withdraw Funds
// Manage Orders - Make or Cancel
// Handle Trades - Charge Fees

// TODO
// [X] Set the Fee Account

// [X] Deposit Tokens
// [X] Withdraw Tokens
// [X] Deposit Ether
// [X] Withdraw Ether

// [X] Check Balances
// [X] Make Order
// [X] Cancel Order
// [ ] Fill Order

// [ ] Charge Fees


contract Exchange {
    using SafeMath for uint;

    // Vars
    address public feeAccount; // account that receives exchange fees
    uint256 public feePercent;
    address constant ETHER = address(0); // store Ether in tokens mapping with blank address
    // Second key: address of user who deposited tokens themselves
    // Final value is the number of tokens held by the user
    /* token address: {
        0x0: balances
    }*/
    mapping(address => mapping(address => uint256)) public tokens;
    mapping(uint256 => _Order) public orders; // key: id, value: order struct
    uint256 public orderCount;
    mapping(uint256 => bool) public orderCancelled; // key: id, value: order struct

    // Events
    event Deposit(address token, address user, uint256 amount, uint256 balance);
    event Withdraw(address token, address user, uint amount, uint balance);
    event Order(
        uint id,
        address user,
        address tokenGet,
        uint amountGet,
        address tokenGive,
        uint amountGive,
        uint timestamp
    );
    event Cancel(
        uint id,
        address user,
        address tokenGet,
        uint amountGet,
        address tokenGive,
        uint amountGive,
        uint timestamp
    );

    // Structs
    struct _Order {
        uint id;
        address user;
        address tokenGet;
        uint amountGet;
        address tokenGive;
        uint amountGive;
        uint timestamp;
    }

    // a way to store the order

    // add the order to storage

    constructor(address _feeAccount, uint256 _feePercent) public {
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }

    // Fallback: reverts if Ether is sent to this smart contract by mistake
    function() external {
        revert();
    }

    // Solidity allows you to send ether with any function call, but the function must have the "payable" modifier
    function depositEther() payable public {
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value);
        emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
    }

    function withdrawEther(uint _amount) public {
        // Exit if they're trying to withdraw more ether than they have
        require(tokens[ETHER][msg.sender] >= _amount);
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
        // sends back ether
        msg.sender.transfer(_amount);
        emit Withdraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);
    }

    // The exchange will move tokens to itself
    function depositToken(address _token, uint _amount) public {
        // TODO: Don't allow ether deposits
        require(_token != ETHER);

        // send tokens to this contract. "this" represents the exchange contract and will be an address
        require(Token(_token).transferFrom(msg.sender, address(this), _amount));

        //Manage depost - update balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
        
        // emit event
        emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    function withdrawToken(address _token, uint256 _amount) public {
        // Make sure that it's not the ether address & they have enough tokens to withdraw
        require(_token != ETHER);
        require(tokens[_token][msg.sender] >= _amount);

        // subtract from the current balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);

        // transfer
        require(Token(_token).transfer(msg.sender, _amount));

        // emit
        emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    // view means its external and will return a value
    function balanceOf(address _token, address _user) public view returns (uint256) {
        return tokens[_token][_user];
    }

    function makeOrder(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) public {
        orderCount = orderCount.add(1);
        orders[orderCount] = _Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, now);
        emit Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, now);
    }

    function cancelOrder(uint256 _id) public {
        // Fetch order from mapping
        _Order storage _order = orders[_id];
        // Must be my order
        require(address(_order.user) == msg.sender);
        // Must be a valid order
        require(_order.id == _id);

        orderCancelled[_id] = true;
        emit Cancel(_order.id, msg.sender, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive, now);

    }

}
