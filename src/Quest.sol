// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { ERC721 } from "solmate/tokens/ERC721.sol";
import { Initializable } from "oz/proxy/utils/Initializable.sol";
import "solmate/utils/LibString.sol";
import { QuestFactory } from "./Factory.sol";

contract Quest is ERC721, Initializable {
    using LibString for uint256;

    ///////////////////////////////
    ////////// Variables //////////
    ///////////////////////////////

    /// @notice Tracking the factory so we can call back to it
    QuestFactory factory; 

    /// @notice Token ID for the next token to be minted
    uint256 nextTokenID;

    /// @notice Base token URI for the ERC721
    string public baseTokenURI;

    /// @notice Contract URI for marketplace metadata
    string public contractURI;

    /// @notice Reverse mapping of owners to token ID
    mapping(address => uint256) public tokenOf;

    ////////////////////////////
    ////////// Events //////////
    ////////////////////////////

    /// @notice Emitted when the baseTokenURI is updated
    event UpdateTokenURI(string _oldBaseTokenURI, string _newBaseTokenURI);

    /// @notice Emittedwhen the contractURI is updated
    event UpdateContractURI(string _oldContractURI, string _newContractURI);

    ////////////////////////////
    ////////// Errors //////////
    ////////////////////////////

    /// @notice Thrown when a method is called on a token that does not exist
    error NonExistentToken();

    /// @notice Thrown when the caller is not authorized to perform an action
    error NotAuthorized();

    /// @notice Thrown when an account already holds this Quest NFT
    error AlreadyHolding();

    /// @notice Thrown when a recipient is invalid
    error InvalidRecipient();

    /// @notice Thrown when a from address is invalid
    error InvalidFrom();

    ///////////////////////////////
    ////////// Modifiers //////////
    ///////////////////////////////

    /// @notice Used to gate methods that can only be called by an admin
    modifier onlyAdmin() {
        // check on Factory if msg.sender has ADMIN role
        if (factory.isAdmin(msg.sender)) {
            _;
        } else {
            revert NotAuthorized();
        }
    }

    /////////////////////////////////
    ////////// Constructor //////////
    /////////////////////////////////

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        _disableInitializers();
    }

    // @notice Initialize the contract after it has been deployed
    /// @param _name Name of the Quest NFT
    /// @param _symbol Symbol for the Quest NFT
    /// @param _contributors List of addresses to pre-mint to
    /// @param _baseTokenUri URI for the token
    /// @param _contractURI Contract metadata URI (for NFT marketplaces)
    function initialize(
        string memory _name,
        string memory _symbol,
        address[] memory _contributors,
        string memory _baseTokenUri,
        string memory _contractURI
    ) initializer() external {
        // set factory address
        factory = QuestFactory(msg.sender);

        // accept and set baseTokenUri
        baseTokenURI = _baseTokenUri;
        contractURI = _contractURI;

        // update name and symbol
        name = _name;
        symbol = _symbol;

        nextTokenID = 1;

        for (uint256 i = 0; i < _contributors.length;) {
            _mint(_contributors[i]);

            unchecked {
                ++i;
            }
        }
    }

    function _mint(address _to) internal returns (uint256) {
        if(balanceOf(_to) > 0) revert AlreadyHolding();

        uint256 _id = nextTokenID;

        super._mint(_to, _id);
        tokenOf[_to] = _id;

        ++nextTokenID;

        return _id;
    }

    /////////////////////////////
    ////////// Methods //////////
    /////////////////////////////

    /// @notice Adds a contributor to this quest
    /// @dev Mints the account a token to represent their contribution to the quest
    /// @param _to The account that will receive the token
    function mint(address _to) external onlyAdmin returns (uint256) {
        uint256 _id = _mint(_to);

        return _id;
    }

    /// @notice Remove a contributor from a quest
    /// @dev Burning a token represents removing a contributor from a quest
    /// @param _id The token ID to burn
    function burn(uint256 _id) external {
        // msg.sender must be an admin or the owner of the token
        if (msg.sender != ownerOf(_id) && !factory.isAdmin(msg.sender)) {
            revert NotAuthorized();
        }

        address owner = ownerOf(_id);
        _burn(_id);
        delete tokenOf[owner];
    }

    /// @notice Recover a user's Quests
    /// @dev Admins can transfer tokens from one account to another, should someone lose access to their wallet. This is a shadow implementation of transferFrom from solmate that skips the approval check.
    /// @param _from Address to transfer the ID from
    /// @param _to Address to transfer the ID to
    /// @param _id Token ID to transfer
    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) public override onlyAdmin {
        if(_from != _ownerOf[_id]) revert InvalidFrom();

        if(_to == address(0)) revert InvalidRecipient();

        if(balanceOf(_to) > 0) revert AlreadyHolding();

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            _balanceOf[_from]--;

            _balanceOf[_to]++;
        }

        _ownerOf[_id] = _to;
        delete tokenOf[_from];
        tokenOf[_to] = _id;

        delete getApproved[_id];

        emit Transfer(_from, _to, _id);
    }

    /// @notice Recover a user's Quests
    /// @dev Admins can transfer tokens from one account to another, should someone lose access to their wallet
    /// @param _from Address to transfer the ID from
    /// @param _to Address to transfer the ID to
    /// @param _id Token ID to transfer
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id
    ) public override onlyAdmin {
        transferFrom(_from, _to, _id);
    }

    /// @notice Recover a user's Quests
    /// @dev Admins can transfer tokens from one account to another, should someone lose access to their wallet
    /// @param _from Address to transfer the ID from
    /// @param _to Address to transfer the ID to
    /// @param _id Token ID to transfer
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        bytes calldata
    ) public override onlyAdmin {
        transferFrom(_from, _to, _id);
    }

    /// @notice No op method for approve
    /// @dev Quests can't be transferred, other than by admins, so we don't need to implement approve.
    /// @param _spender Address to approve
    /// @param _id Token ID to approve
    function approve(address _spender, uint256 _id) public pure override {
        revert NotAuthorized();
    }

    /// @notice No op method for setApprovalForAll
    /// @dev Quests can't be transferred, other than by admins, so we don't need to implement setApprovalForAll.
    /// @param _operator Address to approve
    /// @param _approved Whether to approve or not
    function setApprovalForAll(address _operator, bool _approved)
        public
        pure
        override
    {
        revert NotAuthorized();
    }

    /// @notice Token URI to find metadata for each _id
    /// @dev The metadata will be a variation on the metadata of the underlying token
    /// @param _id Token ID to look up metadata for
    function tokenURI(uint256 _id)
        public
        view
        override
        returns (string memory)
    {
        if (ownerOf(_id) == address(0)) revert NonExistentToken();
        return string.concat(baseTokenURI, LibString.toString(_id), ".json");
    }

    /// @notice Setter method for updating the baseTokenURI
    /// @dev Only admins can update the baseTokenURI
    /// @param _newBaseTokenURI The new baseTokenURI
    function setTokenURI(string memory _newBaseTokenURI) external onlyAdmin {
        string memory _oldBaseTokenURI = baseTokenURI;
        baseTokenURI = _newBaseTokenURI;
        emit UpdateTokenURI(_oldBaseTokenURI, _newBaseTokenURI);
    }

    /// @notice Setter method for updating the contractURI
    /// @dev Only admins can update the contractURI
    /// @param _newContractURI The new contractURI
    function setContractURI(string memory _newContractURI) external onlyAdmin {
        string memory _oldContractURI = contractURI;
        contractURI = _newContractURI;
        emit UpdateContractURI(_oldContractURI, _newContractURI);
    }
}
