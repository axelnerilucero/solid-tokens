// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StellartToken {
    // Declaraciones
    string public name = "Stellart Token";
    string public symbol = "STE";
    uint256 public totalSupply = 100000000000000000000000; // 1 millon de tokens
    uint8 public decimals = 10;

    // Evento para la transferencia de tokens de un usuario    event
    event Transfer (
        address indexed _from,
        address indexed _to, 
        uint256  _value
    );

    // eEvento para la aprobacion de un operador
    event Approval (
        address indexed _owner,
        address indexed _spender, 
        uint256  value
    );

    // Estructurass de datos
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // Constructor
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    //Transferencia de tokens de un usuario
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value,"No hay fondos suficientes");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Aprobacidad de una cantidad para ser gastada por un operador
    function approve (address _spender, uint256 _value) public returns(bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Tranferencia de tokens especificando el emisor
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value <= balanceOf[_from],"No hay fondos suficientes");
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from]-= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true; 
    }
}



