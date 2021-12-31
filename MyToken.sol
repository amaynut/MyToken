// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0<0.9.0;

contract MyToken {
    address public minter;
    mapping(address=>uint) public balances;

    constructor () {
        minter = msg.sender;
    }
    event sent(address from, address to, uint amount);

    function mint(address receiver, uint amount) public {
       require(msg.sender == minter);
       balances[receiver] += amount;
    }

    error InsufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        if (balances[msg.sender] < amount)
        revert InsufficientBalance(
            {
                requested: amount, 
                available: balances[msg.sender]
            }
            );

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit sent(msg.sender, receiver, amount);
    }

    modifier onlyOwner {
        require(msg.sender == minter, "Only the owner can call this function");
        _;
    }

    event burned (address wallet, uint amount);

    function burn(address wallet, uint amount) public onlyOwner {
        if(balances[wallet] < amount) {
           revert InsufficientBalance (
            {
                requested: amount,
                available: balances[wallet]
            }
           );
        }

        balances[wallet] -= amount;
        emit burned (wallet, amount);
    }

}