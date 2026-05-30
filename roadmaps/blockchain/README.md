---
title: Blockchain
roadmap: blockchain
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, blockchain]
---

# Blockchain

> roadmap.sh: https://roadmap.sh/blockchain

Track for the **Blockchain** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Fundamentals
- [ ] What is a blockchain
- [ ] Distributed ledger technology
- [ ] Centralized vs decentralized vs distributed
- [ ] Blocks, chains & hashing
- [ ] Merkle trees
- [ ] Public vs private vs consortium blockchains
- [ ] Nodes & the peer-to-peer network
- [ ] Immutability & transparency
- [ ] History of blockchain (Bitcoin, Ethereum)

### Cryptography
- [ ] Hash functions (SHA-256, Keccak)
- [ ] Public-key cryptography
- [ ] Digital signatures (ECDSA)
- [ ] Asymmetric encryption
- [ ] Wallets, keys & addresses
- [ ] Mnemonic seed phrases (BIP-39)
- [ ] HD wallets (BIP-32 / BIP-44)

### Consensus mechanisms
- [ ] Proof of Work
- [ ] Proof of Stake
- [ ] Delegated Proof of Stake
- [ ] Proof of Authority
- [ ] Byzantine Fault Tolerance (PBFT)
- [ ] Mining & validators
- [ ] Forks (hard vs soft)
- [ ] The blockchain trilemma

### Bitcoin
- [ ] How Bitcoin works
- [ ] UTXO model
- [ ] Bitcoin Script
- [ ] Halving & monetary policy
- [ ] Lightning Network

### Ethereum
- [ ] Accounts model (EOA vs contract)
- [ ] Ethereum Virtual Machine (EVM)
- [ ] Gas & gas fees
- [ ] Transactions & nonces
- [ ] Ether & wei
- [ ] The Merge & Ethereum roadmap
- [ ] Layer 2 scaling (rollups, optimistic, ZK)

### Smart contracts
- [ ] What is a smart contract
- [ ] Solidity language
- [ ] Vyper language
- [ ] Contract structure & data types
- [ ] Functions, modifiers & events
- [ ] Storage vs memory vs calldata
- [ ] Inheritance & interfaces
- [ ] Token standards (ERC-20, ERC-721, ERC-1155)
- [ ] Upgradeable contracts & proxies
- [ ] Oracles (Chainlink)

### Development tools
- [ ] Remix IDE
- [ ] Hardhat
- [ ] Foundry
- [ ] Truffle
- [ ] Ganache
- [ ] ethers.js / web3.js
- [ ] Wallets (MetaMask)
- [ ] Testnets & faucets
- [ ] Block explorers (Etherscan)
- [ ] IPFS & decentralized storage

### dApps & Web3
- [ ] What is a dApp
- [ ] Connecting a frontend to the blockchain
- [ ] Web3 libraries & providers
- [ ] Reading & writing contract state
- [ ] Listening to events
- [ ] The Graph (indexing)
- [ ] Wallet connection (WalletConnect)

### DeFi & ecosystem
- [ ] Decentralized finance (DeFi)
- [ ] DEXs & automated market makers
- [ ] Lending & borrowing protocols
- [ ] Stablecoins
- [ ] Yield farming & liquidity pools
- [ ] NFTs
- [ ] DAOs
- [ ] Bridges & cross-chain

### Security
- [ ] Reentrancy attacks
- [ ] Integer overflow / underflow
- [ ] Front-running & MEV
- [ ] Access control flaws
- [ ] Flash loan attacks
- [ ] Auditing & testing contracts
- [ ] OpenZeppelin libraries
- [ ] Common vulnerability checklists (SWC)

### Other platforms & advanced
- [ ] Solana
- [ ] Polkadot
- [ ] Cosmos
- [ ] Hyperledger Fabric
- [ ] Zero-knowledge proofs (zk-SNARKs / zk-STARKs)
- [ ] Tokenomics
- [ ] Regulation & compliance

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Write, test and deploy an ERC-20 token to a testnet using Foundry or Hardhat, then verify it on Etherscan.
- Build a minimal NFT minting dApp: an ERC-721 contract plus a React frontend connected via ethers.js and MetaMask.
- Implement a simple blockchain in Python or TypeScript from scratch (blocks, hashing, proof-of-work, chain validation) to internalize the data structure.
