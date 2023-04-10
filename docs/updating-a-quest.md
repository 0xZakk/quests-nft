# Updating a Quest

The Quest NFT contract is updateable in some ways that deviate from normal NFTs.
The first deviation is that only admins can update a quest.

## Updateable 

| Property | Updateable |
|  --- | ---   |
| `factory`  | ❌  |
| `baseTokenURI`  | ✅ |
| `contractURI`  | ✅ |
| `mint()`  | ✅  |
| `burn()`  | ✅  |
| `transferFrom()`  | ✅  |
| `safeTransferFrom()`  | ✅  |

## Updating the Token Metadata

Token metadata is stored on IPFS as a JSON blob and the url and hash are stored
in the contract's `tokenURI`property. There is a setter method alled
`setTokenURI` which an admin can call to replace this url on the contract. This
is how you'd update the metadata for a Quest NFT.

## Updating the Contract Metadata

The contract metadata (used to display the NFT in marketplaces) is also stored
on IPFS as a JSON blob with the URL stored in the `contractURI` property. There
is a setter method for this property as well.

## Adding a contributor (minting a token ID)

Adding a contributor to a quest is implemented as minting a token ID for
a wallet address. So an admin would call the `mint` method with the receiving
address (`_to`) of the contributor.

## Removing a Contributor (burning a token ID)

Removing a contributor from a quest is implemented as burning their token ID. So
an admin would call `burn` with the token id of the user who's quest is being
burned.

## Recovering a Quest (transferring a token ID)

Recovering a quest, in the case where someone loses access to their wallet, is
implemented with as `transferFrom`, which can only be called by an admin.
