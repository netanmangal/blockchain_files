pragma solidity ^0.5.6;

contract ICO {
    string public name;
    string public symbol;
    uint public icoStarts;
    uint public icoEnds;
    uint public bonusEnds;
    uint public totalContributors;
    uint public allTokens;
    
    bool public isICORunning;
    
    address payable admin;
    
    mapping (address => uint) public balances;
    
    constructor() public {
        name = "TokenName";
        symbol = "TIT";
        icoStarts = now;
        icoEnds = now + 4 weeks;
        bonusEnds = now + 1 weeks;
        totalContributors = 1;
        allTokens = 100;
        isICORunning = true;
        admin = msg.sender;
        balances[admin] = allTokens;
    }
    
    function buyTokens() public payable {
        require(isICORunning);
        uint tokens = msg.value;
        if (balances[msg.sender] == 0) totalContributors++;
        balances[msg.sender] += tokens;
        allTokens += tokens;
    }
    
    function getAdminAdress() view public returns(address) {
        return admin;
    }
    
    function myAddress() public view returns (address) {
        return msg.sender;
    }
    
    function myBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function endSale() public payable {
        require(msg.sender == admin && isICORunning);
        isICORunning = false;
        admin.transfer(address(this).balance);
    }
}
