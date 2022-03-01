// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol";
import "./rattoken.sol";

contract RatDeposit is Context, RatReceivingContract
{
    address internal _factory;

    constructor (address factory)
    {
        _factory = factory;
    }

    function tokenFallback(address, uint256 amount) public override
    {
        IERC20(_msgSender()).transfer(_factory, amount);
    }
}
