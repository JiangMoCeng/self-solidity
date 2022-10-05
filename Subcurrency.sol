// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    // 关键字“public”让这些变量可以从外部读取
    address public minter;
    mapping (address => uint) public balances; 
    //address => uint 该类型将address映射为无符号整数。

    // 轻客户端可以通过事件针对变化作出高效的反应
    //监听事件，在send函数的最后一行被发出
    event Sent(address from, address to, uint amount);

    // 这是构造函数，只有当合约创建时运行
    constructor() {
        minter = msg.sender;
    }

    //mint 函数用来新发行一定数量的币到一个地址
    function mint(address receiver, uint amount) public {
        // require 用来检查某些条件，如果不满足这些条件就会回推所有的状态变化
        //在这个例子中, require(msg.sender == minter); 确保只有合约的创建者可以调用 mint
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Errors allow you to provide information about
    // why an operation failed. They are returned
    // to the caller of the function.
    error InsufficientBalance(uint requested, uint available);


    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}