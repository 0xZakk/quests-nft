// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract FactoryAdminTest is TestBase {

    function setUp() public override {
        super.setUp();
    }

    // sets owner on deployment
    function testAdmin__OwnerSetOnDeployment() public {
        assertEq(
            factory.owner(),
            owner
        );
    }

    // addresses provided in constructor are given admin priviliges
    function testAdmin__AdminAddressesSetOnDeployment() public {
        for (uint256 i = 0; i < admins.length; i++) {
            assertEq(
                factory.isAdmin(admins[i]),
                true
            );
        }
    }

    // automatically give the owner th eadmin role
    function testAdmin__OwnerHasAdminRole() public {
        assertEq(
            factory.isAdmin(owner),
            true
        );
    }

    // owner can add admins
    function testAdmin__OwnerCanAddAdmin() public {
        address newAdmin = address(0x100);

        // reverts if not called by owner
        vm.expectRevert();
        factory.setAdmin(newAdmin);

        vm.prank(owner);
        factory.setAdmin(newAdmin);
        assertEq(
            factory.isAdmin(newAdmin),
            true
        );
    }

    // owner can remove admins
    function testAdmin__OwnerCanRemoveAdmin() public {
        address admin = admins[0];

        // reverts if not called by owner
        vm.expectRevert();
        factory.revokeAdmin(admin);

        vm.prank(owner);
        factory.revokeAdmin(admin);
        assertEq(
            factory.isAdmin(admin),
            false
        );
    }

    // only admin can call createQuest
    function testAdmin__OnlyAdminCanCreateQuest() public {
        // reverts if not called by admin
        vm.expectRevert();
        factory.createQuest(
            questName,
            questSymbol,
            questContributors,
            questTokenURI,
            questContractURI
        );

        vm.prank(admins[0]);
        factory.createQuest(
            questName,
            questSymbol,
            questContributors,
            questTokenURI,
            questContractURI
        );
    }

    // only admin can call mint
    function testAdmin__OnlyAdminCanMint() public {
        Quest quest = _createQuest();

        // reverts if not called by admin
        vm.expectRevert();
        quest.mint(
            user
        );

        vm.prank(admins[0]);
        quest.mint(
            user
        );

        assertEq(
            quest.balanceOf(user),
            1
        );
    }

    // // only admin can call burn
    // function testAdmin__OnlyAdminCanBurn() public {
    //     Quest quest = _createQuest();
    //
    //     vm.prank(admins[0]);
    //     uint256 id = quest.mint(
    //         user
    //     );
    //
    //     // reverts if not called by admin
    //     vm.expectRevert();
    //     quest.burn(
    //         id
    //     );
    //
    //     vm.prank(admins[0]);
    //     quest.burn(
    //         id
    //     );
    //
    //     assertEq(
    //         quest.balanceOf(user),
    //         0
    //     );
    // }
    // // only admin can call transferFrom
    // function testAdmin__OnlyAdminCanTransferFrom() public {
    //     Quest quest = _createQuest();
    //
    //     vm.prank(admins[0]);
    //     uint256 id = quest.mint(
    //         user
    //     );
    //
    //     assertEq(
    //         quest.ownerOf(id),
    //         user
    //     );
    //
    //     // reverts if not called by admin
    //     vm.expectRevert();
    //     quest.transferFrom(
    //         user,
    //         userBackupWallet,
    //         id
    //     );
    //
    //     vm.prank(admins[0]);
    //     quest.transferFrom(
    //         user,
    //         userBackupWallet,
    //         id
    //     );
    //
    //     assertEq(
    //         quest.balanceOf(user),
    //         0
    //     );
    //     assertEq(
    //         quest.balanceOf(userBackupWallet),
    //         1
    //     );
    //     assertEq(
    //         quest.ownerOf(id),
    //         userBackupWallet
    //     );
    // }
    //
    // // only admin can call safeTransferFrom
    // function testAdmin__OnlyAdminCanSafeTransferFrom() public {
    //     Quest quest = _createQuest();
    //
    //     vm.prank(admins[0]);
    //     uint256 id = quest.mint(
    //         user
    //     );
    //
    //     assertEq(
    //         quest.ownerOf(id),
    //         user
    //     );
    //
    //     // reverts if not called by admin
    //     vm.expectRevert();
    //     quest.safeTransferFrom(
    //         user,
    //         userBackupWallet,
    //         id
    //     );
    //
    //     vm.prank(admins[0]);
    //     quest.safeTransferFrom(
    //         user,
    //         userBackupWallet,
    //         id
    //     );
    //
    //     assertEq(
    //         quest.balanceOf(user),
    //         0
    //     );
    //     assertEq(
    //         quest.balanceOf(userBackupWallet),
    //         1
    //     );
    //     assertEq(
    //         quest.ownerOf(id),
    //         userBackupWallet
    //     );
    // }
    //
    // // only admin can call safeTransferFrom with data
    // function testAdmin__OnlyAdminCanSafeTransferFromWithData() public {
    //     Quest quest = _createQuest();
    //     vm.prank(admins[0]);
    //     uint256 id = quest.mint(
    //         user
    //     );
    //
    //     assertEq(
    //         quest.ownerOf(id),
    //         user
    //     );
    //
    //     // reverts if not called by admin
    //     vm.expectRevert();
    //     quest.safeTransferFrom(
    //         user,
    //         userBackupWallet,
    //         id,
    //         ""
    //     );
    //
    //     vm.prank(admins[0]);
    //     quest.safeTransferFrom(
    //         user,
    //         userBackupWallet,
    //         id,
    //         ""
    //     );
    //
    //     assertEq(
    //         quest.balanceOf(user),
    //         0
    //     );
    //     assertEq(
    //         quest.balanceOf(userBackupWallet),
    //         1
    //     );
    //     assertEq(
    //         quest.ownerOf(id),
    //         userBackupWallet
    //     );
    // }
}
