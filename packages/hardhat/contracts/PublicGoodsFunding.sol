// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CF {
    address payable public organizer;
    uint public goalAmount;
    uint public deadline;
    mapping(address => uint) public contributions;

    event ContributionMade(address contributor, uint amount);
    event GoalReached(uint totalAmountRaised);

    constructor(uint _goalAmount, uint _durationDays) {
        organizer = payable(msg.sender);
        goalAmount = _goalAmount * 1 ether; // Convert to wei
        deadline = block.timestamp + _durationDays * 1 days;
    }

    function contribute() external payable {
        require(block.timestamp < deadline, "Crowdfunding deadline has passed");
        require(msg.value > 0, "Contribution amount must be greater than 0");
        
        contributions[msg.sender] += msg.value;
        emit ContributionMade(msg.sender, msg.value);
    }

    function checkGoalReached() external {
        require(block.timestamp >= deadline, "Crowdfunding deadline has not passed yet");
        require(address(this).balance >= goalAmount, "Goal amount not reached");

        emit GoalReached(address(this).balance);
        organizer.transfer(address(this).balance);
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }

    function getContribution(address contributor) external view returns (uint) {
        return contributions[contributor];
    }


}
