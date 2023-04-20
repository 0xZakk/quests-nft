// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {TestBase} from "../bases/TestBase.sol";
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

    // a user can't be added to a quest more than once
    function testAdmin__CantBeAddedMoreThanOnce() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        quest.mint(
        user
        );

        vm.expectRevert();
        quest.mint(
        user
        );
    }
}


