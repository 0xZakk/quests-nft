# Ownership

This document outlines how ownership of the `QuestFactory` works, including:

- Who is the owner?
- How is the owner different from the admin?
- How would you transfer ownership?

## Overview

The `QuestFactory` contract has an `owner` role that is granted certain
privileges on the contract. Namely, the `owner` can create new quests, add and
remove admins, and transfer ownership of the factory to another address.

## Owner v. Admin

The `owner` and `ADMIN_ROLE` have shared and different capabilities:

| Task | Admin | Owner |
| ---  | ---  | ---  |
| `createQuest` | ✅ | ✅ |
| `setAdmin` | ❌ | ✅ |
| `revokeAdmin` | ❌ | ✅ |

## Transferring Ownership

You can transfer ownership of the factory from the current owner to
a new one.

The Factory uses [`Ownable2Step`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) for ownership, including transferring ownership. To transfer ownership of the contract to a new address:

- the current owner should call the `transferOwnership` method with the address
    of the new owner. This will set the new address as the `_pendingOwner`.
- the new owner should call the `acceptOwnership` method. This will transfer
    ownership from the previous owner to the new one.

