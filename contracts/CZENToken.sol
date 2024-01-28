// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CZENToken is ERC20 {
    using SafeMath for uint256;

    address public constant DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
    address public developersWallet;
    uint256 public constant TOTAL_SUPPLY = 100_000_000; // Total supply: 100,000,000 CZEN
    uint256 public constant DEVELOPERS_PERCENTAGE = 20; // 20% dos tokens serão enviados para a carteira dos desenvolvedores
    uint256 public constant BURN_THRESHOLD = TOTAL_SUPPLY / 2; // 50% do fornecimento inicial
    uint256 public constant RESTORE_THRESHOLD = TOTAL_SUPPLY * 9 / 10; // 90% do fornecimento inicial
    uint256 public constant BURN_PERCENTAGE = 200; // Taxa de queima inicial: 2%
    uint256 public constant RESTORE_PERCENTAGE = 120; // Taxa de criação quando abaixo do limiar de queima: 1.2%

    constructor(address _developersWallet) ERC20("Crypto Zen", "CZEN") {
        require(_developersWallet != address(0), "Invalid developers wallet address");
        developersWallet = _developersWallet;
        _mint(developersWallet, TOTAL_SUPPLY * DEVELOPERS_PERCENTAGE / 100);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _updateTokenSupply(amount, msg.sender);
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _updateTokenSupply(amount, sender);
        return super.transferFrom(sender, recipient, amount);
    }

    function _updateTokenSupply(uint256 amount, address sender) internal {
        uint256 burnAmount;
        uint256 transferAmount;

        if (totalSupply() <= BURN_THRESHOLD) {
            burnAmount = amount.mul(RESTORE_PERCENTAGE).div(100); // 1.2% de tokens serão criados
            transferAmount = amount.add(burnAmount);
        } else {
            burnAmount = amount.mul(BURN_PERCENTAGE).div(10000); // 2% de tokens serão queimados
            transferAmount = amount.sub(burnAmount);
        }

        if (totalSupply() <= BURN_THRESHOLD) {
            // Transferência de tokens criados para a carteira do remetente
            super._transfer(DEAD_WALLET, sender, burnAmount);
        } else {
            // Queima de tokens
            _burn(sender, burnAmount);
            // Transferência de tokens queimados para a carteira morta (dead wallet)
            super._transfer(sender, DEAD_WALLET, burnAmount);
        }
    }
}
