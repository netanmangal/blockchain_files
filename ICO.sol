pragma solidity ^0.5.6;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a * b;
    require(a == 0 || c / a == b);
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
    require(b > 0);
    c = a / b;
  }
  
  function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
    require(b <= a);
    c = a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    require(c >= a);
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}


contract ERC20Interface {
  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function transfer(address to, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function approve(address spender, uint tokens) public returns (bool success);
 
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}





contract ICO is ERC20Interface {
    
    using SafeMath for uint256;
    
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public icoStarts;
    uint256 public icoEnds;
    uint256 public bonusEnds;
    uint256 public totalContributors;
    uint256 public allTokens;
    
    bool public isICORunning;
    
    address payable admin;
    
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) private allowed;
    
    constructor() public {
        name = "TokenName";
        symbol = "TIT";
        decimals = 18;
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
    
    
    
    // --------------------------------------------------------------------------------------------------------
    
    
    function totalSupply() public view returns (uint256) {
        return allTokens.sub(balances[address(0)]);
    }

    function balanceOf(address tokenOwner) public view returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    
    // --------------------------------------------------------------------------------------------------------
    
    
    
    function getAdminAdress() view public returns(address) {
        return admin;
    }
    
    function myAddress() public view returns (address) {
        return msg.sender;
    }
    
    function endSale() public payable {
        require(msg.sender == admin && isICORunning);
        isICORunning = false;
        admin.transfer(address(this).balance);
    }
}
