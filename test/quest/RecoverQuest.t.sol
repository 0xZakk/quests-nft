// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract RecoverQuestTest is TestBase {
    function setUp() public override {
        super.setUp();
    }

    // admin can recover quest nft by calling transferFrom
    function testRecoverQuest__OnlyAdminCanTransferFrom() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        uint256 questId = quest.mint( user );

        // Reverts if not called by an admin
        vm.expectRevert();
        quest.transferFrom(
            user,
            userBackupWallet,
            questId
        );

        // Admin can call transferFrom
        vm.prank(admin1);
        quest.transferFrom(
            user,
            userBackupWallet,
            questId
        );

        // user balance should be 0
        assertEq(
            quest.balanceOf(user),
            0
        );

        // userBackupWallet balance should be 1
        assertEq(
            quest.balanceOf(userBackupWallet),
            1
        );

        // owner of id should be userBackupWallet
        assertEq(
            quest.ownerOf(questId),
            userBackupWallet
        );
    }

    // only admin can recover with safeTransferFrom
    function testRecoverQuest__OnlyAdminCanSafeTransferFrom() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        uint256 questId = quest.mint( user );

        // Reverts if not called by an admin
        vm.expectRevert();
        quest.safeTransferFrom(
            user,
            userBackupWallet,
            questId
        );

        // Admin can call safeTransferFrom
        vm.prank(admin1);
        quest.safeTransferFrom(
            user,
            userBackupWallet,
            questId
        );

        // user balance should be 0
        assertEq(
            quest.balanceOf(user),
            0
        );

        // userBackupWallet balance should be 1
        assertEq(
            quest.balanceOf(userBackupWallet),
            1
        );

        // owner of id should be userBackupWallet
        assertEq(
            quest.ownerOf(questId),
            userBackupWallet
        );
    }

    // only admin can call safeTransferFrom with data
    function testRecoverQuest__OnlyAdminCanSafeTransferFromWithData() public {
        Quest quest = _createQuest();

        vm.prank(admins[0]);
        uint256 id = quest.mint( user );

        // reverts if not called by admin
        vm.expectRevert();
        quest.safeTransferFrom(
            user,
            userBackupWallet,
            id,
            ""
        );

        vm.prank(admins[0]);
        quest.safeTransferFrom(
            user,
            userBackupWallet,
            id,
            ""
        );

        assertEq(
            quest.balanceOf(user),
            0
        );
        assertEq(
            quest.balanceOf(userBackupWallet),
            1
        );
        assertEq(
            quest.ownerOf(id),
            userBackupWallet
        );
    }
}
