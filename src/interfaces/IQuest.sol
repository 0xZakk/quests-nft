pragma solidity 0.8.13;

interface IQuest {
    event Approval(address indexed owner, address indexed spender, uint256 indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    function approve(address spender, uint256 id) external;
    function balanceOf(address owner) external view returns (uint256);
    function burn(address _contributor) external;
    function getApproved(uint256) external view returns (address);
    function isApprovedForAll(address, address) external view returns (bool);
    function mint(address _contributor) external;
    function name() external view returns (string memory);
    function ownerOf(uint256 id) external view returns (address owner);
    function safeTransferFrom(address _from, address _to, uint256 _id) external;
    function safeTransferFrom(address _from, address _to, uint256 _id, bytes memory data) external;
    function setApprovalForAll(address operator, bool approved) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 id) external view returns (string memory);
    function transferFrom(address _from, address _to, uint256 _id) external;
}
