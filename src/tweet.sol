// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./register.sol";

contract tweet is register {
    register Register;

    constructor(address _register) {
        Register = register(_register);
    }

    struct S_Tweet {
        address add;
        string username;
        string _twet;
        uint256 _time;
        uint256 like;
    }

    mapping(uint256 => mapping(address => bool)) likedBy;

    S_Tweet[] tweets;

    event TweetEvent(string username, string tweet, uint256 time);
    event LikeTweet(uint256 indexed indexTweet, string username);

    modifier onlyHaveAccount() {
        require(bytes(Register.username(msg.sender)).length > 0, "You do not have an account");
        _;
    }

    modifier TweetIsThere(uint256 index) {
        require(index < tweets.length, "There is nothing tweet");
        _;
    }

    function Tweet(string memory _twit) public onlyHaveAccount {
        require(bytes(_twit).length <= 250, "Tweet exceeds 250");
        string memory username = Register.username(msg.sender);
        S_Tweet memory _tweet =
            S_Tweet({add: msg.sender, username: username, _twet: _twit, _time: block.timestamp, like: 0});
        tweets.push(_tweet);
        emit TweetEvent(username, _twit, block.timestamp);
    }

    function like(uint256 _indexTweet) public onlyHaveAccount TweetIsThere(_indexTweet) {
        require(!likedBy[_indexTweet][msg.sender], "You alredy liked this tweet");

        likedBy[_indexTweet][msg.sender] = true;
        tweets[_indexTweet].like++;

        emit LikeTweet(_indexTweet, Register.username(msg.sender));
    }

    function getLike(uint256 _indexTweet) public view TweetIsThere(_indexTweet) returns (uint256) {
        return tweets[_indexTweet].like;
    }

    function unLike(uint256 _indexTweet) public onlyHaveAccount {
        require(likedBy[_indexTweet][msg.sender], "You did not like the tweet");

        tweets[_indexTweet].like--;
        likedBy[_indexTweet][msg.sender] = false;
    }

    function getTweet(uint256 _indexTweet) public view onlyHaveAccount returns (string memory) {
        return tweets[_indexTweet]._twet;
    }

    function youLikeThisTweet(uint256 _indexTweet) public view returns (bool) {
        return likedBy[_indexTweet][msg.sender];
    }
}
