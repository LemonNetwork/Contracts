// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
}

// Solidity Smart Contract for 🍋 Initial Coin Offering

contract LMN_ICO {
    using SafeMath for uint256;
    ERC20 public token;

    uint256 public startTime;
    uint256 public startPrice;
    uint256 public finalPrice;

    uint256 public weiRaised;
    uint256 public tokensSold;

    uint256 public phaseOneSupply;
    uint256 public phaseTwoSupply;
    uint256 public phaseThreeSupply;

    uint256 public phaseOneTimeLock;
    uint256 public phaseTwoTimeLock;
    uint256 public phaseThreeTimeLock;
    uint256 public idleTime;

    struct Investments {
        address payable buyer;
        uint256 weiAmount;
        uint256 tokensAmount;
    }

    struct Investors {
        uint256[] investmentList;
        uint256 investmentCount;
        mapping(uint256 => Investments) investments;
    }

    mapping(address => Investors) public investors;

    address payable public governance;

    event TokenPurchase(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    constructor(address payable _governance, ERC20 _token) public {
        governance = _governance;
        token = _token;

        startPrice = 40;
        finalPrice = 10;

        startTime = 1636930800; //Mon Nov 15 2021 00:00:00 GMT+0100 (Central Europe)
        idleTime = SafeMath.add(idleTime, 2880 minutes);

        phaseOneTimeLock = SafeMath.add(startTime, 8640 minutes);
        phaseTwoTimeLock = SafeMath.add(phaseOneTimeLock, 8640 minutes);
        phaseThreeTimeLock = SafeMath.add(phaseTwoTimeLock, 11520 minutes);

        phaseOneSupply = SafeMath.mul(2002500, 10**(18)); // . 2,002,500 🍋 (26.7%)
        phaseTwoSupply = SafeMath.mul(2497500, 10**(18)); // . 2,497,500 🍋 (33.3%)
        phaseThreeSupply = SafeMath.mul(3000000, 10**(18)); // 3,000,000 🍋 (40.0%)
    }

    receive() external payable {
        buyTokens(msg.sender);
    }

    function _calculateTokens(uint256 _weiAmount)
        internal
        returns (uint256 _tokens)
    {
        uint256 _now = now;
        uint256 _tokensAmount = 0;

        _tokens = SafeMath.add(_tokensAmount, _weiAmount.mul(getCurrentRate()));

        if (_now <= (phaseOneTimeLock - (idleTime))) {
            if ((phaseOneSupply - _tokens) >= 0) {
                require(
                    (phaseOneSupply - _tokens) >= 0,
                    "phase one supply ended !"
                );
                phaseOneSupply = phaseOneSupply.sub(_tokens);
            } else {
                _tokens = 0;
            }
        } else if (
            _now > (phaseOneTimeLock - (idleTime)) && _now < phaseOneTimeLock
        ) {
            _tokens = 0;
            require(0 != 0, "IDLE TIME 1 !");
            phaseTwoSupply = phaseTwoSupply.sub(_tokens);
        } else if (
            _now > phaseOneTimeLock && _now < (phaseTwoTimeLock - (idleTime))
        ) {
            if ((phaseTwoSupply - _tokens) >= 0) {
                require(
                    (phaseTwoSupply - _tokens) >= 0,
                    "phase two supply ended !"
                );
                phaseTwoSupply = phaseTwoSupply.sub(_tokens);
            } else {
                _tokens = 0;
            }
        } else if (
            _now > (phaseTwoTimeLock - (idleTime)) && _now < phaseTwoTimeLock
        ) {
            _tokens = 0;
            require(0 != 0, "IDLE TIME 2 !");
            phaseTwoSupply = phaseTwoSupply - _tokens;
        } else if (_now > phaseTwoTimeLock && _now < (phaseThreeTimeLock)) {
            if (phaseThreeSupply - _tokens >= 0) {
                require(
                    (phaseThreeSupply - _tokens) >= 0,
                    "phase three supply ended !"
                );
                phaseThreeSupply = phaseThreeSupply.sub(_tokens);
            } else {
                _tokens = 0;
            }
        }
        return _tokens;
    }

    function buyTokens(address payable beneficiary) public payable {
        uint256 weiAmount = msg.value;

        require(
            weiAmount >= 0.001 ether,
            "investment should be more than 0.001 EWT"
        );
        require(now <= phaseThreeTimeLock, "sale is closed !");
        require(now >= startTime, "ICO is not open yet!");
        Investors storage investor = investors[beneficiary];

        uint256 tokens = 0;

        tokens = _calculateTokens(weiAmount);
        require(tokens > 0, "Nein");
        weiRaised = weiRaised.add(weiAmount);

        investor.investmentCount = investor.investmentCount + 1;
        investor.investments[investor.investmentCount];
        investor.investments[investor.investmentCount].buyer = beneficiary;
        investor.investments[investor.investmentCount].weiAmount = weiAmount;
        investor.investments[investor.investmentCount].tokensAmount = tokens;

        tokensSold = tokensSold.add(tokens);

        // Eth amount is going to owner
        governance.transfer(weiAmount);

        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    }

    function withdrawTokens() public returns (bool success) {
        Investors storage investor = investors[msg.sender];
        address buyer = investor.investments[investor.investmentCount].buyer;

        require(msg.sender == buyer, "not a valid investor to withdraw !");
        require(now >= phaseThreeTimeLock, "tokens cannot be withdrawn yet !");

        for (uint256 i = 1; i <= investor.investmentCount; i++) {
            require(
                token.transfer(buyer, investor.investments[i].tokensAmount),
                "Transfer not successful"
            );
            investor.investments[i].tokensAmount = 0;
        }
        return true;
    }

    function getTokenCount() public view returns (uint256) {
        Investors storage investor = investors[msg.sender];
        address buyer = investor.investments[investor.investmentCount].buyer;

        uint256 tokensAmount = 0;
        for (uint256 i = 1; i < investor.investmentCount; i++) {
            tokensAmount =
                tokensAmount +
                (investor.investments[i].tokensAmount);
        }

        return tokensAmount;
    }

    function withdrawUnsoldTokens(uint256 _tokens)
        public
        returns (bool success)
    {
        require(msg.sender == governance, "!governance");
        require(now > phaseThreeTimeLock, "ICO not finished");

        require(token.transfer(governance, _tokens), "Transfer not successful");

        return true;
    }

    function setGovernance(address payable _governance)
        public
        returns (bool success)
    {
        require(msg.sender == governance, "!governance");

        governance = _governance;

        return true;
    }

    function withdrawEthers(uint256 _weiAmount) public returns (bool success) {
        require(msg.sender == governance, "Only authorized method !");

        governance.transfer(_weiAmount);

        return true;
    }

    function getInvestmentsByIndex(uint256 index)
        public
        view
        returns (uint256 weiAmount, uint256 tokensAmount)
    {
        Investors storage investor = investors[msg.sender];

        return (
            investor.investments[index].weiAmount,
            investor.investments[index].tokensAmount
        );
    }

    function getCurrentRate() public view returns (uint256) {
        if (now > phaseThreeTimeLock) {
            return 0;
        }
        if (now < startTime) {
            return 40;
        }
        uint256 elapsedTime = block.timestamp.sub(startTime);
        uint256 timeRange = phaseThreeTimeLock.add(idleTime).sub(startTime);
        uint256 rateRange = startPrice.sub(finalPrice);
        return startPrice.sub(elapsedTime.mul(rateRange).div(timeRange));
    }
}
