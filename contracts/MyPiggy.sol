// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./IErrors.sol";

contract onchainThrift is IErrors {
    using SafeERC20 for IERC20;

    address public owner;
    address public immutable developer;
    address public immutable token;
    uint256 public depositAmount;
    uint256 public startTime;
    uint256 public endTime;
    bool public isWithdrawn;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event EmergencyWithdrawn(address indexed user, uint256 amount, uint256 penalty);

    constructor(address _owner, address _developer, address _token, uint256 _duration) {
        if (_owner == address(0) || _developer == address(0) || _token == address(0)) 
            revert InvalidAddress();
        if (_duration == 0) revert InvalidDuration();
        
        owner = _owner;
        developer = _developer;
        token = _token;
        startTime = block.timestamp;
        endTime = startTime + _duration;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    function deposit(uint256 amount) external onlyOwner {
        if (amount == 0) revert InvalidAmount();
        if (isWithdrawn) revert AlreadyWithdrawn();

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        depositAmount += amount;

        emit Deposited(msg.sender, amount);
    }

    function withdraw() public onlyOwner {
        if (block.timestamp < endTime) revert WithdrawalTooEarly();
        if (isWithdrawn) revert AlreadyWithdrawn();
        if (depositAmount == 0) revert InvalidAmount();

        isWithdrawn = true;
        uint256 amount = depositAmount;
        depositAmount = 0;

        IERC20(token).safeTransfer(owner, amount);

        emit Withdrawn(msg.sender, amount);
        
        owner = address(0); 
    }

    function emergencyWithdraw() external onlyOwner {
        if (isWithdrawn) revert AlreadyWithdrawn();
        if (depositAmount == 0) revert InvalidAmount();

        if (block.timestamp >= endTime) {
            withdraw();
            return;
        }

        uint256 penalty = (depositAmount * 15) / 100;
        uint256 userAmount = depositAmount - penalty;

        isWithdrawn = true;
        depositAmount = 0;

        IERC20(token).safeTransfer(owner, userAmount);
        IERC20(token).safeTransfer(developer, penalty);

        emit EmergencyWithdrawn(msg.sender, userAmount, penalty);
        
        owner = address(0); 
    }

    function getUserBalance() external view returns (uint256) {
        return depositAmount;
    }

    function getPiggyDetails() external view returns (
        address _owner, 
        address _token, 
        uint256 _depositAmount, 
        uint256 _startTime, 
        uint256 _endTime, 
        bool _isWithdrawn
    ) {
        return (owner, token, depositAmount, startTime, endTime, isWithdrawn);
    }
}
