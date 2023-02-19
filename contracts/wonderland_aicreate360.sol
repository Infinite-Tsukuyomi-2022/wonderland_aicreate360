// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


//  ██╗    ██╗ ██████╗ ███╗   ██╗██████╗ ███████╗██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
//  ██║    ██║██╔═══██╗████╗  ██║██╔══██╗██╔════╝██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
//  ██║ █╗ ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
//  ██║███╗██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
//  ╚███╔███╔╝╚██████╔╝██║ ╚████║██████╔╝███████╗██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
//   ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝                                                                


contract wonderland_aicreate360 is Ownable, EIP712, ERC721A {
    using SafeMath for uint256;
    using Strings for uint256;

    // Sales variables
    // ------------------------------------------------------------------------
    uint256 public MAX_NFT = 2999;
    uint256 public WL_STAGE_LIMIT = 657; // 300 + 358, Whitelist + fans airdrop
    uint256 public PS_STAGE_LIMIT = 2999; // 600 Public Sale
    uint256 public MAX_PS_ADDRESS_TOKEN = 1;
    // uint256 public PRICE = 0.0 ether;
    uint256 public whitelistSaleTimestamp = 1647198840;
    uint256 public publicSaleTimestamp = 1647198840;
    bool public hasWhitelistSaleStarted = false;
    bool public hasPublicSaleStarted = false;
    bool public hasBurnStarted = false;
    string private _baseTokenURI = "http://wonderland.aicreate360.com/Metadata/";
    address public treasury = 0x711A9ba89A8dA7c84f4805B989F67af038e023a6;
    address public signer = 0x711A9ba89A8dA7c84f4805B989F67af038e023a6;

    mapping(address => uint256) public hasPSMinted;
    mapping(address => uint256) public hasWLMinted;

    // Events
    // ------------------------------------------------------------------------
    event mintEvent(address owner, uint256 quantity, uint256 totalSupply);

    // Constructor
    // ------------------------------------------------------------------------
    constructor() 
	EIP712("wonderland.aicreate360", "1.0.0") 
	ERC721A("wonderland.aicreate360", "Wonderland") {
        _safeMint(treasury, 50);
    }

    // Modifiers
    // ------------------------------------------------------------------------
    modifier onlyWhitelistSale() {
        require(hasWhitelistSaleStarted == true, "WHITELIST_NOT_ACTIVE");
        require(block.timestamp >= whitelistSaleTimestamp, "NOT_IN_WHITELIST_TIME");
        _;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "CALLER_IS_CONTRACT");
        _;
    }

    // Verify functions
    // ------------------------------------------------------------------------
    function verify(uint256 maxQuantity, bytes memory SIGNATURE) public view returns (bool){
        address recoveredAddr = ECDSA.recover(
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "NFT(address addressForClaim,uint256 maxQuantity)"
                        ),
                        _msgSender(),
                        maxQuantity
                    )
                )
            ),
            SIGNATURE
        );

        return signer == recoveredAddr;
    }

    // Airdrop functions
    // ------------------------------------------------------------------------
    function airdrop(address[] calldata _to, uint256[] calldata quantity) public onlyOwner{
        uint256 count = _to.length;
		uint256 airdropQuantity = 0;

		for (uint256 i = 0; i < count; i++) {
			airdropQuantity += quantity[i];
		}

		require(totalSupply() + airdropQuantity <= MAX_NFT, "EXCEEDS_MAX_NFT");

        for (uint256 i = 0; i < count; i++) {
            _safeMint(_to[i], quantity[i]);
            emit mintEvent(_to[i], quantity[i], totalSupply());
        }
    }

    // Whitelist functions
    // ------------------------------------------------------------------------
    function mintWhitelist(uint256 quantity, uint256 maxQuantity, bytes memory SIGNATURE) external /*payable*/ onlyWhitelistSale {
        require(totalSupply().add(quantity) <= WL_STAGE_LIMIT, "WL_STAGE_SOLD_OUT");
        require(verify(maxQuantity, SIGNATURE), "NOT_ELIGIBLE_FOT_WHITELIST");
        require(quantity > 0 && hasWLMinted[msg.sender].add(quantity) <= maxQuantity, "EXCEEDS_MAX_WL_QUANTITY");
        // require(msg.value >= PRICE.mul(quantity), "ETHER_VALUE_NOT_ENOUGH");

        hasWLMinted[msg.sender] = hasWLMinted[msg.sender].add(quantity);
        _safeMint(msg.sender, quantity);

        emit mintEvent(msg.sender, quantity, totalSupply());
    }

    // Public Sale functions
    // ------------------------------------------------------------------------
    function mintNFT(uint256 quantity) external /*payable*/ callerIsUser {
        require(hasPublicSaleStarted == true, "SALE_NOT_ACTIVE");
        require(block.timestamp >= publicSaleTimestamp, "NOT_IN_SALE_TIME");
        // require(msg.value >= PRICE.mul(quantity), "ETHER_VALUE_NOT_ENOUGH");
        require(totalSupply().add(quantity) <= PS_STAGE_LIMIT, "PS_STAGE_SOLD_OUT");
        require(totalSupply().add(quantity) <= MAX_NFT, "EXCEEDS_MAX_NFT");
        require(quantity > 0 && hasPSMinted[msg.sender].add(quantity) <= MAX_PS_ADDRESS_TOKEN, "EXCEEDS_MAX_PS_QUANTITY");

        hasPSMinted[msg.sender] = hasPSMinted[msg.sender].add(quantity);
        _safeMint(msg.sender, quantity);

        emit mintEvent(msg.sender, quantity, totalSupply());
    }

    // Burn Functions
    // ------------------------------------------------------------------------
    function burn(address account, uint256 id) public virtual {
        require(hasBurnStarted == true, "BURN_NOT_ACTIVE");
        require(account == tx.origin || isApprovedForAll(account, _msgSender()), "CALLER_NOT_OWNER_NOR_APPROVED");
        require(ownerOf(id) == account, "ADDRESS_NOT_TOKENID_OWNER");

        _burn(id);
    }

    // Base URI Functions
    // ------------------------------------------------------------------------
    function tokenURI(uint256 tokenId) public view override returns (string memory){
        require(_exists(tokenId), "TOKEN_NOT_EXISTS");

        return string(abi.encodePacked(_baseTokenURI, tokenId.toString()));
    }

    // setting functions
    // ------------------------------------------------------------------------
    function setURI(string calldata _tokenURI) public onlyOwner {
        _baseTokenURI = _tokenURI;
    }

    function setMAX_NFT(
        uint256 _MAX_num,
        uint256 _WL_STAGE_LIMIT,
        uint256 _PS_STAGE_LIMIT,
        uint256 _MAX_PS_ADDRESS_TOKEN
    ) public onlyOwner {
        MAX_NFT = _MAX_num;
        WL_STAGE_LIMIT = _WL_STAGE_LIMIT;
        PS_STAGE_LIMIT = _PS_STAGE_LIMIT;
        MAX_PS_ADDRESS_TOKEN = _MAX_PS_ADDRESS_TOKEN;
    }

    // function set_PRICE(uint256 _price) public onlyOwner {
    //     PRICE = _price;
    // }

    function setSwitch(
        bool _hasWhitelistSaleStarted,
        uint256 _whitelistSaleTimestamp,
        bool _hasPublicSaleStarted,
        uint256 _publicSaleTimestamp,
        bool _hasBurnStarted
    ) public onlyOwner {
        hasWhitelistSaleStarted = _hasWhitelistSaleStarted;
        whitelistSaleTimestamp = _whitelistSaleTimestamp;
        hasPublicSaleStarted = _hasPublicSaleStarted;
        publicSaleTimestamp = _publicSaleTimestamp;
        hasBurnStarted = _hasBurnStarted;
    }

    function setSigner(address _signer) public onlyOwner {
        require(_signer != address(0), "SETTING_ZERO_ADDRESS");
        signer = _signer;
    }

    // Withdrawal functions
    // ------------------------------------------------------------------------
    function setTreasury(address _treasury) public onlyOwner {
        require(treasury != address(0), "SETTING_ZERO_ADDRESS");
        treasury = _treasury;
    }

    // function withdrawAll() public payable onlyOwner {
    //     require(payable(treasury).send(address(this).balance));
    // }
}
