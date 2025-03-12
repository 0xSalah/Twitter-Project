// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/tweet.sol";

contract tweetTest is Test {
    register Register;
    tweet Tweet;
    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        Register = new register();
        Tweet = new tweet(address(Register));
    }

    function testIndexTweetsIsRight() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchain");
        assertEq(Tweet.getTweet(0), "Hello Blockchain");

        vm.stopPrank();
    }

    function test_RevertWhen_LengthIsMoreThan250() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        string memory longTweet = string(abi.encodePacked(new string(251)));
        vm.expectRevert("Tweet exceeds 250");
        Tweet.Tweet(longTweet);

        vm.stopPrank();
    }

    function test_RevertWhen_YouDoNotHaveAccount() public {
        vm.startPrank(user1);
        vm.expectRevert("You do not have an account");
        Tweet.Tweet("Hello Blockchain");
        vm.stopPrank();
    }

    function testLike() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");
        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("do7mi");
        Tweet.like(0);
        assertEq(Tweet.getLike(0), 1);

        vm.stopPrank();
    }

    function testAreYouLikeThisTweet() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");
        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("do7mi");
        Tweet.like(0);
        assertEq(Tweet.youLikeThisTweet(0), true);

        vm.stopPrank();
    }

    function test_RevertWhen_DuplicateLike() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");
        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("do7mi");
        Tweet.like(0);

        vm.expectRevert("You alredy liked this tweet");
        Tweet.like(0);
        vm.stopPrank();
    }

    function test_RevertWhen_LikeMissingTweet() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");

        vm.stopPrank();

        vm.startPrank(user2);

        Register.registerUsername("do7mi");
        vm.expectRevert("There is nothing tweet");
        Tweet.like(1);

        vm.stopPrank();
    }

    function testUnlike() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");

        vm.stopPrank();

        vm.startPrank(user2);

        Register.registerUsername("do7mi");
        Tweet.like(0);
        Tweet.unLike(0);

        assertEq(Tweet.getLike(0), 0);

        vm.stopPrank();
    }

    function test_RevertWhen_YouDidNotLikeThisTweetToDoUnlike() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");

        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("do7mi");
        vm.expectRevert("You did not like the tweet");
        Tweet.unLike(0);

        vm.stopPrank();
    }

    function testLikesAfterUnlike() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");

        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("do7mi");
        Tweet.like(0);
        Tweet.unLike(0);

        assertEq(Tweet.getLike(0), 0);

        vm.stopPrank();
    }

    function testAreYouLikeThisTweetAfterUnlike() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");
        Tweet.Tweet("Hello Blockchin");
        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("do7mi");
        Tweet.like(0);
        Tweet.unLike(0);
        assertEq(Tweet.youLikeThisTweet(0), false);

        vm.stopPrank();
    }
}
