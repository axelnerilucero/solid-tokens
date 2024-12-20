// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./JamToken.sol";
import "./StellartToken.sol";

contract TokenFarm {
    
    // Declaraciones iniciales
    string public name = "Stellart Token Farm";
    address public owner;
    JamToken public jamToken;
    StellartToken public stellartToken;

    // Estructuras de datos 
    address [] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    // Constructor
    constructor(StellartToken _stellartToken, JamToken _jamToken) {
        stellartToken = _stellartToken;
        jamToken = _jamToken;
        owner = msg.sender;
    }

    // Stake de tokens

    function stakeTokens(uint _amount) public {
        // Se requiere una cantidad superior a 0 
        require(_amount > 0, "El valor debe ser mayor que 0");
        // Transferir tokens JAM al Smart Contract
        jamToken.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] += _amount;
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        } 
        // Actuallizar el estado del staking
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // quitar el staking de los tokens
    function unstakeTokens() public {
        // Saldo del staking de un usuario
        uint balance = stakingBalance[msg.sender];
        // se requiere de una cantidad superior a 0
        require (balance > 0, "el balance del staking es 0");
        // Transferencia de los tokens al usuario
        jamToken.transfer(msg.sender, balance);
        // Resetea el balance de staking del usuario
        stakingBalance[msg.sender] = 0;
        // Actualizar el estado del staking
        isStaking[msg.sender] = false;
    }    

    // Emision de las recompensas
    function issueToken() public {
        // Unicamente ejecutable por el owner 
        require(msg.sender == owner, "No eres el owner");
        // Emitir tokens a todos los staker actuales
        for (uint i = 0; i < stakers.length; i++) 
        {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0){
                stellartToken.transfer(recipient, balance);
            }
       }
    }
}



