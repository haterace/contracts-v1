// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol";


abstract contract RatReceivingContract
{
    function tokenFallback(address sender, uint256 amount) public virtual;
}

contract RatToken is ERC20
{
    using Address for address;

    constructor () ERC20("Hate Race", "HATE")
    {
        _mint(_msgSender(), 21000000 * (10 ** decimals()));
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override
    {
        super._transfer(sender, recipient, amount);
        if (recipient.isContract())
        {
            try RatReceivingContract(recipient).tokenFallback(_msgSender(), amount) {} catch {}
        }
    }

    function burn(uint256 amount) public
    {
        _burn(_msgSender(), amount);
    }
}
