// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {onchainThrift} from "./MyPiggy.sol";
import "./IErrors.sol";

contract MyPiggyFactory is IErrors {
    address public immutable developer;
    address[] public allowedTokens;
    mapping(address => address[]) public userPiggyBanks; // Track user's piggy banks

    event PiggyBankCreated(address indexed user, address piggyBank, address token, uint256 duration);

    constructor(address _developer, address[] memory _tokens) {
        if (_developer == address(0)) revert InvalidAddress();
        if (_tokens.length == 0) revert InvalidToken();
        developer = _developer;
        allowedTokens = _tokens;
    }

    function createPiggyBank(address token, uint256 duration) external returns (address piggyBank) {
        if (!_isTokenAllowed(token)) revert InvalidToken();
        if (duration == 0) revert InvalidDuration();
        if (token == address(0)) revert InvalidAddress();

        bytes32 salt = keccak256(abi.encodePacked(msg.sender, token, block.timestamp));
        piggyBank = address(new onchainThrift{salt: salt}(msg.sender, developer, token, duration));

        userPiggyBanks[msg.sender].push(piggyBank);
        emit PiggyBankCreated(msg.sender, piggyBank, token, duration);
    }

    function getUserPiggyBanks(address user) external view returns (address[] memory) {
        return userPiggyBanks[user];
    }

    function getPiggyBankBalance(address piggyBank) external view returns (uint256) {
        if (piggyBank == address(0)) revert InvalidAddress();
        return onchainThrift(piggyBank).getUserBalance();
    }

    function _isTokenAllowed(address token) internal view returns (bool) {
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            if (allowedTokens[i] == token) return true;
        }
        return false;
    }
}
