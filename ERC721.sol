// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OpenZeppelin ERC721 sözleşmesini içe aktarma
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

// Bir gönderim sözleşmesiyle etkileşim için arayüz
interface ISubmission {
    // Bir haikuyu temsil eden yapı
    struct Haiku {
        address author; // Haiku yazarının adresi
        string line1; // Haikunun ilk satırı
        string line2; // Haikunun ikinci satırı
        string line3; // Haikunun üçüncü satırı
    }

    // Yeni bir haiku basma fonksiyonu
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external;

    // Toplam haiku sayısını alma fonksiyonu
    function counter() external view returns (uint256);

    // Bir haikuyu başka bir adresle paylaşma fonksiyonu
    function shareHaiku(uint256 _id, address _to) external;

    // Kullanıcı ile paylaşılan haikuları alma fonksiyonu
    function getMySharedHaikus() external view returns (Haiku[] memory);
}

// Haiuku nftlerini yönetmek için sözleşme
contract HaikuNFT is ERC721, ISubmission {
    Haiku[] public haikus; // Array to store haikus
    mapping(address => mapping(uint256 => bool)) public sharedHaikus; // Mapping to track shared haikus
    uint256 public haikuCounter; // Counter for total haikus minted

    // ERC721 sözleşmesini başlatmak için constructor
    constructor() ERC721("HaikuNFT", "HAIKU") {
        haikuCounter = 1; // Haiku sayacını başlat
    }

    string salt = "value"; // Özel bir string değişkeni

    // Toplam haiku sayısını alma fonksiyonu
    function counter() external view override returns (uint256) {
        return haikuCounter;
    }

    // Yeni bir haiku basma fonksiyonu
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external override {
        // Haikunun benzersiz olup olmadığını kontrol et
        string[3] memory haikusStrings = [_line1, _line2, _line3];
        for (uint256 li = 0; li < haikusStrings.length; li++) {
            string memory newLine = haikusStrings[li];
            for (uint256 i = 0; i < haikus.length; i++) {
                Haiku memory existingHaiku = haikus[i];
                string[3] memory existingHaikuStrings = [
                    existingHaiku.line1,
                    existingHaiku.line2,
                    existingHaiku.line3
                ];
                for (uint256 eHsi = 0; eHsi < 3; eHsi++) {
                    string memory existingHaikuString = existingHaikuStrings[
                        eHsi
                    ];
                    if (
                        keccak256(abi.encodePacked(existingHaikuString)) ==
                        keccak256(abi.encodePacked(newLine))
                    ) {
                        revert HaikuNotUnique();
                    }
                }
            }
        }

        // Mint haiku NFT
        _safeMint(msg.sender, haikuCounter);
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        haikuCounter++;
    }

    // Bir haikuyu başka bir adresle paylaşma fonksiyonu
    function shareHaiku(uint256 _id, address _to) external override {
        require(_id > 0 && _id <= haikuCounter, "Invalid haiku ID");

        Haiku memory haikuToShare = haikus[_id - 1];
        require(haikuToShare.author == msg.sender, "NotYourHaiku");

        sharedHaikus[_to][_id] = true;
    }

    // Kullanıcıyla paylaşılan haikuları alma fonksiyonu
    function getMySharedHaikus()
        external
        view
        override
        returns (Haiku[] memory)
    {
        uint256 sharedHaikuCount;
        for (uint256 i = 0; i < haikus.length; i++) {
            if (sharedHaikus[msg.sender][i + 1]) {
                sharedHaikuCount++;
            }
        }

        Haiku[] memory result = new Haiku[](sharedHaikuCount);
        uint256 currentIndex;
        for (uint256 i = 0; i < haikus.length; i++) {
            if (sharedHaikus[msg.sender][i + 1]) {
                result[currentIndex] = haikus[i];
                currentIndex++;
            }
        }

        if (sharedHaikuCount == 0) {
            revert NoHaikusShared();
        }

        return result;
    }

    // Özel hatalar
    error HaikuNotUnique(); // // Benzersiz olmayan bir haiku basma girişimi için hata
    error NotYourHaiku(); // Arayanın sahip olmadığı bir haikuyu paylaşma girişimi için hata
    error NoHaikusShared(); // Arayanla paylaşılmış haiku bulunmaması için hata
}
