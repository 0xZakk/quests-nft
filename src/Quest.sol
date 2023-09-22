// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721 } from "solmate/tokens/ERC721.sol";
import "solmate/utils/LibString.sol";
import { QuestFactory } from "./Factory.sol";

contract Quest is ERC721 {
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

    ////////////////////////////
    ////////// Events //////////
    ////////////////////////////

    /// @notice Emitted when a token is minted and a contributor is added to the quest
    event QuestMinted(address indexed _contributor, uint256 _tokenId);

    /// @notice Emited when a token is burned and a contributor is removed from a quest
    event QuestBurned(address indexed _contributor, uint256 _tokenId);

    /// @notice Emited when a token is transfer and a contributor's quests are recovered
    event QuestTransfered(address indexed _oldContributor, address indexed _newContributor, uint256 _tokenId);

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

    /// @param _name Name of the Quest NFT
    /// @param _symbol Symbol for the Quest NFT
    /// @param _contributors List of addresses to pre-mint to
    /// @param _tokenURI URI for the token
    /// @param _contractURI Contract metadata URI (for NFT marketplaces)
    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _contributors,
        string memory _tokenURI,
        string memory _contractURI
    ) ERC721(_name, _symbol) {
        // set factory address
        factory = QuestFactory(msg.sender);
        // accept and set tokenURI
        baseTokenURI = _tokenURI;
        contractURI = _contractURI;

        for (uint256 i = 0; i < _contributors.length; i++) {
            if(balanceOf(_contributors[i]) > 0) revert AlreadyHolding();
            _mint(_contributors[i], i);
        }

        nextTokenID = _contributors.length;
    }

    /////////////////////////////
    ////////// Methods //////////
    /////////////////////////////

    /// @notice Adds a contributor to this quest
    /// @dev Mints the account a token to represent their contribution to the quest
    /// @param _to The account that will receive the token
    function mint(address _to) external onlyAdmin returns (uint256) {
        if(balanceOf(_to) > 0) revert AlreadyHolding();
        uint256 _id = nextTokenID;

        _mint(_to, _id);
        ++nextTokenID;

        return _id;
    }

    /// @notice Remove a contributor from a quest
    /// @dev Burning a token represents removing a contributor from a quest
    /// @param _id The token ID to burn
    function burn(uint256 _id) external onlyAdmin {
        _burn(_id);
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
        require(_from == _ownerOf[_id], "WRONG_FROM");

        require(_to != address(0), "INVALID_RECIPIENT");

        if(balanceOf(_to) > 0) revert AlreadyHolding();

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            _balanceOf[_from]--;

            _balanceOf[_to]++;
        }

        _ownerOf[_id] = _to;

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
        super.safeTransferFrom(_from, _to, _id);
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
        bytes calldata _data
    ) public override onlyAdmin {
        super.safeTransferFrom(_from, _to, _id, _data);
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
        return baseTokenURI;
    }

    /// @notice Setter method for updating the tokenURI
    /// @dev Only admins can update the tokenURI
    /// @param _newTokenURI The new tokenURI
    function setTokenURI(string memory _newTokenURI) external onlyAdmin {
        string memory _oldTokenURI = baseTokenURI;
        baseTokenURI = _newTokenURI;
        emit UpdateTokenURI(_oldTokenURI, _newTokenURI);
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
