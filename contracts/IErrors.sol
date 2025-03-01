// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IErrors {
    error InvalidAddress();
    error InvalidToken();
    error InvalidAmount();
    error InvalidDuration();
    error OnlyOwner();
    error WithdrawalTooEarly();
    error AlreadyWithdrawn();
    error TransferFailed();
} 