// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Persona 1 (Owner) ->    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// Persona 2 (Receptor) -> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// Persona 3 (Operador) -> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

contract JamToken {
    // Declaraciones
    string public name = "JAM Token";
    string public symbol = "JAM";
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



