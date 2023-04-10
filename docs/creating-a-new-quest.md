# Creating a New Quest

Quests are created through the `QuestFactory` contract by calling the
`createQuest` method. When this method is invoked, the following parameters
should be passed in:

1. `_name` - The name of the NFT contract (likely the name of the Quest).
2. `_symbol` - The token symbol for the NFT contract (a 3 or 4 character symbol to represent the quest).
3. `_contributors` - An address of wallet addresses that the token should be minted to on creation (the initial contributors to a quest).
4. `_tokenURI` - the URI for the token's metadata. This should be an IPFS address to a JSON metadata file. [Read more](https://docs.opensea.io/docs/metadata-standards)
5. `_contractURI` - the URI for the contract's metadata. This should be an IPFS address to a JSON metadata file. [Read more](https://docs.opensea.io/docs/contract-level-metadata)

> Only the contract's owner or a wallet with the `ADMIN_ROLE` can invoke the
`createQuest` method.
