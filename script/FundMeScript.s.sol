// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {Helper} from "./Helper.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //Anything before startBroadcast will be not considered as real tx
        Helper help = new Helper();
        address ethPriceFeed = help.active();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
