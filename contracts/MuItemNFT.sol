// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MuNFT is ERC721 {
    address public admin;
    uint256 public itemCount;
    uint256 private nonce = 0; // Variável para geração de números aleatórios
    
    string public itemName;
    string public itemAtt1;
    string public itemAtt2;
    string public itemAtt3;
    string public itemAtt4;
    string public itemAtt5;
    string public itemImageURL;
    string public itemType;

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

    mapping(uint256 => ItemAttributes) public itemAttributes;
    mapping(uint256 => uint256) public itemSerial; // Serial (DNA) for each item

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor() ERC721("Mu NFT", "MUNFT") {
        admin = msg.sender;
        itemCount = 0;
    }

     function mint(
        string memory _name,
        string memory _att1,
        string memory _att2,
        string memory _att3,
        string memory _att4,
        string memory _att5,
        string memory _imageURL,
        string memory _type
    ) external {
        require(msg.sender == admin || itemCount > 0, "Only admin can mint new tier 1 NFTs or mint from breeding");
        itemCount++;
        _mint(msg.sender, itemCount);
        _setAttributes(_name, _att1, _att2, _att3, _att4, _att5, _imageURL, _type);
    }

    function _setAttributes(
        string memory _name,
        string memory _att1,
        string memory _att2,
        string memory _att3,
        string memory _att4,
        string memory _att5,
        string memory _imageURL,
        string memory _type
    ) internal {
        itemName = _name;
        itemAtt1 = _att1;
        itemAtt2 = _att2;
        itemAtt3 = _att3;
        itemAtt4 = _att4;
        itemAtt5 = _att5;
        itemImageURL = _imageURL;
        itemType = _type;
    }

    // Função para calcular o n-ésimo termo da sequência de Fibonacci
    function fibonacci(uint256 n) internal pure returns (uint256) {
        if (n == 0) return 0;
        if (n == 1) return 1;
        uint256 a = 0;
        uint256 b = 1;
        for (uint256 i = 2; i <= n; i++) {
            uint256 temp = b;
            b = a + b;
            a = temp;
        }
        return b;
    }    

    function breed(uint256 tokenId1, uint256 tokenId2) external {
        require(ownerOf(tokenId1) == msg.sender && ownerOf(tokenId2) == msg.sender, "You must own both NFTs to breed them");
        // Verifica se os atributos typeItem e tier dos dois NFTs são iguais
        require(keccak256(abi.encodePacked(itemAttributes[tokenId1].typeItem)) == keccak256(abi.encodePacked(itemAttributes[tokenId2].typeItem)) 
            && itemAttributes[tokenId1].tier == itemAttributes[tokenId2].tier, "NFTs must be of the same type and tier to breed");


        ItemAttributes memory parentAttributes;
        if (_random() % 2 == 0) {
            parentAttributes = itemAttributes[tokenId1]; // Herda atributos do pai (tokenId1)
        } else {
            parentAttributes = itemAttributes[tokenId2]; // Herda atributos da mãe (tokenId2)
        }
        ItemAttributes memory newAttributes = ItemAttributes(parentAttributes.name, parentAttributes.att1, parentAttributes.att2, parentAttributes.att3,
             parentAttributes.att4, parentAttributes.att5, parentAttributes.imageURL, parentAttributes.typeItem, parentAttributes.tier + 1);

        // Excluindo os antigos NFTs
        delete itemAttributes[tokenId1];
        delete itemAttributes[tokenId2];
        _burn(tokenId1);
        _burn(tokenId2);

        // Criando novo NFT com tier aumentado e atributos herdados do pai ou da mãe
        itemCount++;
        _mint(msg.sender, itemCount);
        itemAttributes[itemCount] = newAttributes;
    }

    // Função para geração de número aleatório
    function _random() internal returns (uint256) {
        nonce++;
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 1000;
    }
}
