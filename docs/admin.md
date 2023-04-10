# Admin

The `QuestFactory` contract includes an `ADMIN_ROLE` that is used throughout the
system to gate certain methods. This document explain the purpose of this role,
what it can do, and how it is intended to be used.

## Role Overview

The `ADMIN_ROLE` is intended to be held by a bot wallet address that is owned
and controlled by the Quests team. To begin with, this could be a set of trusted
EOAs where the private keys are held by members of the team. But eventually
these addresses will become bots running on a Quests server.

Most actions in the NFT system (factory and individual NFT contracts) are
restricted to wallets that hold the `ADMIN_ROLE` on the factory contract. The
role is managed on the factory only, though the Quest NFT contract uses it to
gate certain actions too.

### `QuestFactory`:

The following methods of the `QuestFactory` can only be called by a wallet with
the `ADMIN_ROLE`:

- `createQuest` - creating a new Quest NFT

### `Quest`:

The following methods of the `Quest` NFT contract can only be called by a wallet
with the `ADMIN_ROLE`:

- `mint` (Adding someone to a quest) - minting a new token ID to an address
- `burn` (Removing someone from a quest) - burning a token ID
- `transferFrom` (Recovering a quest NFT) - transferring a token ID from one wallet to another
- `safeTransferFrom` (Recovering a quest NFT) - transferring a token ID from one wallet to another

## Managing Admins

The `ADMIN_ROLE` is managed on the `QuestFactory` contract, which includes
methods for granting and revoking this role.

### How to set an Admin

There are two ways to grant the `ADMIN_ROLE` to an address. First, when the
contract is deployed, a list of addresses to be set as the initial list of
admins is passed into the constructor. Second, the `QuestFactory` includes
a `setAdmin` method that can be called by the contract owner.

### How to revoke an Admin

There is only one way to revoke the `ADMIN_ROLE` from an address. The owner can
call the `revokeAdmin` method on the `QuestFactory` contract

