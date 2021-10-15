// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LMN is ERC20, ERC20Detailed, ERC20Capped, ERC20Pausable {
    constructor()
        public
        ERC20Detailed("LEMON", "LMN", 18)
        ERC20Capped(50000000 * (10**18))
    {
        _mint(msg.sender, 50000000 * (10**18));
    }
}
