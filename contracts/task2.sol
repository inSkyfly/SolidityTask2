// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
作业2：在测试网上发行一个图文并茂的 NFT
任务目标
使用 Solidity 编写一个符合 ERC721 标准的 NFT 合约。
将图文数据上传到 IPFS，生成元数据链接。
将合约部署到以太坊测试网（如 Goerli 或 Sepolia）。
铸造 NFT 并在测试网环境中查看
 */

contract MyNFT is ERC721URIStorage {
    uint256 private _nextTokenId;

    // string constant tokenURI = "ipfs://bafkreiebprr3zuim2nmrtnqnyeazc7rpdk6kpgikyfk3riaejfywv67npq";

    constructor() ERC721("MYNFT", "NF") {}

    function safeMint(
        address to,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }
}
