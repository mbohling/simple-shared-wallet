//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/**
 * @dev Helper contract using OpenZeppelin Ownable.  Tracks and secures user allowances.
 */
contract Allowance is Ownable {

    /**
    * @dev Track allowances for each address
    */
    mapping(address => uint) public allowance;

    /**
    * @dev Event used to alert a change in allowance, whether this was changed by the owner or from withdrawing funds.
    */
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);

    /**
    * @dev Modifier used when withdrawing funds to ensure the non-owner has enough funds.
    */
    modifier enoughAllowance(uint _amount) {
        require(allowance[msg.sender] >= _amount || isOwner(), "You do not have enough funds. Aborting...");
        _;
    }

    /**
    * @dev Helper function to determine if the user is owner or not.
    */
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    /**
    * @dev Functions to control allowance amounts for each address. May only be used by the owner.
    */
    function addNeworChangeAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
}