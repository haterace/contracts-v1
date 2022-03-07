// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;

import "./ratfactory.sol";

contract RatMediator is Ownable, IERC721Receiver
{
    RatFactory                public _factoryContract;
    mapping (address => bool) public _coowners;

    modifier coowners()
    {
        require(
            _msgSender() == owner() || _coowners[_msgSender()],
            "RatMediator: coowners only are allowed to call");
        _;
    }

    function setCoowner(address c, bool status) public onlyOwner
    {
        _coowners[c] = status;
    }

    modifier wrapped()
    {
        require(address(_factoryContract) != address(0), "RatMediator: no contract has wrapped");
        _;
    }

    function wrap(address factoryContract) public onlyOwner
    {
        require(address(_factoryContract) == address(0), "RatMediator: contract has already wrapped");
        _factoryContract = RatFactory(factoryContract);
    }

    function unwrap() public onlyOwner wrapped
    {
        _factoryContract.transferOwnership(_msgSender());
        _factoryContract = RatFactory(address(0));
    }

    function onERC721Received(address /*operator*/, address /*from*/, uint256 /*tokenId*/, bytes calldata /*data*/) public pure override returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    function setBaseURI(string memory baseURI) public onlyOwner wrapped
    {
        _factoryContract.setBaseURI(baseURI);
    }

    function setJack(address jack) public onlyOwner wrapped
    {
        _factoryContract.setJack(jack);
    }

    function createRat(string memory name, string memory hash) public onlyOwner wrapped returns(uint256)
    {
        uint256 ratId = _factoryContract.createRat(name, hash);
        _factoryContract.safeTransferFrom(address(this), _msgSender(), ratId);
        return ratId;
    }

    function startRace(uint256 durationSeconds) public coowners wrapped returns(uint256)
    {
        return _factoryContract.startRace(durationSeconds);
    }

    function finishRace() public returns(uint256)
    {
        return _factoryContract.finishRace();
    }
}
