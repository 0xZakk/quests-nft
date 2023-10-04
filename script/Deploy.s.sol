// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Script} from 'forge-std/Script.sol';
import { QuestFactory } from "../src/Factory.sol";
import { Quest } from "../src/Quest.sol";

contract Deploy is Script {
  address[] public admins = [
    0xC3268DDB8E38302763fFdC9191FCEbD4C948fe1b,
    0x97cd197c0aAA41564B55F3b13A8b2a6204DE99ab
  ];

  function run() external {
    uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
    vm.startBroadcast(deployerPrivateKey);

    address quest = address( new Quest("generic quest", "GQ") );
    QuestFactory questFactory = new QuestFactory(quest, admins);

    vm.stopBroadcast();
  }
}
