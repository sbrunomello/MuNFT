# MuNFT – Advanced NFT System with Breeding & Tier Mechanics

This project contains a complete smart contract system for creating, managing, and evolving NFTs based on item attributes, RPG-style progression, and genetic-style breeding. It also includes a custom ERC20 token (CZEN) with dynamic burn/restore logic.

---

## 🧬 MuNFT – Tier-Based NFT Contract

`MuNFT.sol` is an ERC-721 NFT contract inspired by games like *Mu Online*. It allows for the minting of equipment NFTs, each with detailed attributes, and enables **breeding** of two NFTs into a more powerful one (higher tier).

### ✨ Features

- Custom minting with 5 flexible attributes + image and type
- Tier system with breeding mechanics (only same-tier and same-type NFTs)
- Burning of parent NFTs when breeding
- On-chain attribute storage for each token ID
- Randomized attribute inheritance
- Admin-restricted tier 1 minting

### 🧪 Sample Structure

```solidity
struct ItemAttributes {
    string name;
    string att1;
    string att2;
    string att3;
    string att4;
    string att5;
    string imageURL;
    string typeItem;
    uint8 tier;
}
```

---

## 🔥 CZENToken – Elastic Supply Token with Burn & Restore Logic

`CZENToken.sol` is a custom ERC20 token that automatically **burns tokens** above a certain supply threshold and **restores tokens** when supply is too low.

### 📊 Features

- Total supply: 100,000,000 CZEN
- Burn threshold: 50% of supply → triggers deflation
- Restore threshold: 90% of supply → triggers inflation
- Dynamic 2% burn (when above threshold)
- 1.2% token restore (when below threshold)
- Burned tokens are sent to the `0xdead` wallet
- 20% of supply allocated to developers on deployment

---

## 🧱 Technologies Used

- Solidity ^0.8.0
- OpenZeppelin Contracts (ERC721 & ERC20)
- Chainlink-style random via internal nonce
- Compatible with Web3.js or Ethers.js frontends

---

## 🌐 Frontend Integration

This contract is actively used in the companion Web3 marketplace:  
👉 [`NFTMarketplace`](https://github.com/sbrunomello/NFTMarketplace)

It provides minting, querying, selling and buying NFTs directly on the blockchain via Metamask.

---

## 📂 Project Structure

```
MuNFT.sol        → ERC721 NFT contract with breeding/tier logic
CZENToken.sol    → ERC20 with burn/restore supply mechanics
```

---

## ✅ How to Deploy

1. Clone the repo and open in [Remix](https://remix.ethereum.org/)
2. Deploy `CZENToken` by passing a developer wallet address.
3. Deploy `MuNFT` – no constructor parameters needed.
4. Interact directly or via external frontend (see link above).

---

## 🤝 Contributions

Pull requests and ideas are welcome! You can fork and extend:

- More attributes
- Elemental types
- Equipment fusion
- Integration with games or 3D assets

---

## 📬 Contact

- [GitHub](https://github.com/sbrunomello)  
Developed with ⚔️ by Mello
