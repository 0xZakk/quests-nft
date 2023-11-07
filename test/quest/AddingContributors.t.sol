// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { TestBase } from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract AddingContributorsTest is TestBase {
    function setUp() public override {
        super.setUp();
    }

    // only admin can call mint
    function testAdmin__OnlyAdminCanMint() public {
        Quest quest = _createQuest();

        // reverts if not called by admin
        vm.expectRevert();
        quest.mint(
            user,
            "tokenUrl"
        );

        vm.prank(admins[0]);
        quest.mint(
            user,
            "tokenUrl"
        );

        assertEq(
            quest.balanceOf(user),
            1
        );

        vm.prank(admins[0]);
        quest.mint(
            user2,
            "tokenUrl"
        );

        assertEq(
            quest.balanceOf(user2),
            1
        );


        assertEq(
            quest.tokenOf(user2),
            4
        );
    }

      // only admin can call mint
    function testAdmin__ErroWhenGettingTokenOfNonHolder() public {
        Quest quest = _createQuest();

        // reverts if user has no token
        vm.expectRevert();
        quest.tokenOf(
            user
        );

        vm.prank(admins[0]);
        quest.mint(
            user,
            "tokenUrl"
        );

        assertEq(
            quest.tokenOf(user),
            3
        );
    }

    // a user can't be added to a quest more than once
    function testAdmin__CantBeAddedMoreThanOnce() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        quest.mint(
            user,
            "tokenUrl"
        );

        vm.expectRevert();
        quest.mint(
            user,
            "tokenUrl"
        );
    }
}


