// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Rent{

    event ObjectCreated(uint256 id, address data);
    event ObjectsLinked(uint256 tokenId,address tenant, address nextAddress);
    event ObjectRemoved(uint256 id,address tenant);
    event NewHead(uint256 id);

    struct RentData{
        address tenant;
        bool isRent;
        address next;
    }

    mapping (uint256 => address) private head;
    mapping (uint256 => mapping(address => bool)) public isTenant;
    mapping (uint256 => mapping(address => address)) private tokenAddressToNext;
    
    function rentNFT(uint256 tokenId, address tenant) public {
        require(isTenant[tokenId][tenant] == false, "NFT is already rented to this address");
        isTenant[tokenId][tenant] = true;
        if(head[tokenId] == address(0))
            {
                head[tokenId] = tenant;
            }else{
                address tempHead = head[tokenId];
                while (tokenAddressToNext[tokenId][tempHead]!=address(0)) {
                tempHead = tokenAddressToNext[tokenId][tempHead];
                }
                tokenAddressToNext[tokenId][tempHead] = tenant;
            }
        emit ObjectCreated(
            tokenId,
            tenant
        );
    }
    function removeTenant(uint256 tokenId, address tenant)
        public
        virtual
    {
        require(isTenant[tokenId][tenant] == true, "NFT is not rented to this address");
            isTenant[tokenId][tenant] = false;
            if (head[tokenId] == tenant) {
                head[tokenId] = tokenAddressToNext[tokenId][tenant];
            }
            else {
                address prevAddress = findPrevId(tokenId, tenant);    
                tokenAddressToNext[tokenId][prevAddress] = tokenAddressToNext[tokenId][tenant];
                isTenant[tokenId][tenant] = false;
            }
            delete isTenant[tokenId][tenant];
            emit ObjectRemoved(tokenId,tenant);
    }   

    function findPrevId(uint256 tokenId, address tenant)
        internal
        virtual
        view
        returns (address)
    {
        address tempHead;
        if (tenant == head[tokenId]) return address(0);
        else{
                tempHead = head[tokenId];
                while (tokenAddressToNext[tokenId][tempHead] != tenant) {
                    tempHead = tokenAddressToNext[tokenId][tempHead];
                }
            }
        return tempHead;
    }

}

contract MyNFT is ERC721URIStorage, Ownable, Pausable, Rent{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    mapping(uint256=> mapping(address=> bool)) tokenRent;



    constructor() ERC721("HypeuNFT", "HNT") {}

    function mintNFT(address recipient, string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}