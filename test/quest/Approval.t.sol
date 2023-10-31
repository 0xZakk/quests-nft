// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract ApproveQuest is TestBase {
    function setUp() public override {
        super.setUp();
    }

    function testApproval__ApproveReverts() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        uint256 id = quest.mint(
            user,
            "tokenUrl"
        );

        vm.startPrank(user);

        vm.expectRevert();
        quest.approve(
            makeAddr("spender"),
            id
        );

        vm.stopPrank();
    }

    function testApproval__ApproveAllReverts() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        quest.mint(
            user,
            "tokenUrl"
        );

        vm.startPrank(user);

        vm.expectRevert();
        quest.setApprovalForAll(
            makeAddr("operator"),
            true
        );

        vm.stopPrank();
    }
}
