// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/tweet.sol";

contract tweetTest is tweet, Test{
    tweet public Tweet;
    address user1 = address(1);
    address user2 = address(2);

    function setUp() public{
        Tweet = new tweet();
    }
}