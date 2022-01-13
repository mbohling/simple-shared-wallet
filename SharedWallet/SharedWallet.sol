//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Allowance.sol";

/**
 * @dev Main shared wallet contract
 */
contract SharedWallet is Allowance {

    /**
     * @dev Events for sending and receiving money.
     */
    event MoneySent(address indexed _toWhom, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    /**
     * @dev Withdraw amount to payable wallet address depending on allowance.  Checks if funds are available for non-owners.
     *      Otherwise transfers the amount requested to user.
     */
    function withdrawFunds(address payable _to, uint _amount) public enoughAllowance(_amount) {
        require(_amount <= address(this).balance, "Insufficient contract funds. Aborting...");

        if(!isOwner())
            reduceAllowance(_to, _amount);

        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    /**
     * @dev Without ownership this wallet would be unusable.  Override the renounceOwnership() function so that this reverts.
     */
    function renounceOwnership() public view override onlyOwner {
        revert("Cannot renounce ownership! Reverting...");
    }

    /**
     * @dev SharedWallet may receive deposits of any amount from any address.
     */
    receive() external payable { 
        emit MoneyReceived(msg.sender, msg.value);
    }
}