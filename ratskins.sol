// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract RatSkins is Ownable, ERC721
{
    event SkinCreated(uint256 indexed skinId, uint256 indexed ratId, string hash);

    struct Skin
    {
        uint256 ratId;
        string  hash;
    }
    mapping (uint256 => Skin) public  _skins;
    string                    public  _base;
    address                   public  _boss;

    constructor () ERC721("Hate Race", "Skins")
    {
        setBaseURI("https://haterace.com/skins/");
    }

    function setBaseURI(string memory baseURI) public onlyOwner
    {
        _base = baseURI;
    }

    function _baseURI() internal view override returns (string memory)
    {
        return _base;
    }

    function setBossAddress(address boss) public onlyOwner
    {
        _boss = boss;
    }

    function createSkin(uint256 ratId, uint256 skinId, string memory hash) public onlyOwner returns(uint256)
    {
        _safeMint(_boss == address(0) ? _msgSender() : _boss, skinId);
        _skins[skinId].ratId = ratId;
        _skins[skinId].hash = hash;
        emit SkinCreated(skinId, ratId, hash);
        return skinId;
    }
}
