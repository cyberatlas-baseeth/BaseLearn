// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// OpenZeppelin ERC721 sözleşmesini içe aktarma
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
// Göçmen sözleşmesiyle etkileşim için arayüz
interface ISubmission {
    // Haiku'yu temsil eden yapı
    struct Haiku {
        address author; // Haiku'nun yazarı adresi
        string line1; // Haiku'nun ilk satırı
        string line2; // Haiku'nun ikinci satırı
        string line3; // Haiku'nun üçüncü satırı
    }
    // Yeni bir haiku basma fonksiyonu
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external;
    // Toplam haiku sayısını alma fonksiyonu
    function counter() external view returns (uint256);
    // Bir haiku'yu başka bir adresle paylaşma fonksiyonu
    function shareHaiku(uint256 _id, address _to) external;
    // Çağıranla paylaşılan haikuları alma fonksiyonu
    function getMySharedHaikus() external view returns (Haiku[] memory);
}
// Haiku NFT'lerini yönetmek için sözleşme
contract HaikuNFT is ERC721, ISubmission {
    Haiku[] public haikus; // Haikuları saklamak için dizi
    mapping(address => mapping(uint256 => bool)) public sharedHaikus; // Paylaşılan haikuları takip etmek için eşleme
    uint256 public haikuCounter; // Basılan toplam haiku sayacı
    // ERC721 sözleşmesini başlatmak için yapıcı
    constructor() ERC721("HaikuNFT", "HAIKU") {
        haikuCounter = 1; // Haiku sayacını başlat
    }
    string salt = "value"; // Özel bir dize değişkeni
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
        // Haiku'nun benzersiz olup olmadığını kontrol et
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
        // Haiku NFT'sini bas
        _safeMint(msg.sender, haikuCounter);
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        haikuCounter++;
    }
    // Bir haiku'yu başka bir adresle paylaşma fonksiyonu
    function shareHaiku(uint256 _id, address _to) external override {
        require(_id > 0 && _id <= haikuCounter, "Geçersiz haiku kimliği");
        Haiku memory haikuToShare = haikus[_id - 1];
        require(haikuToShare.author == msg.sender, "Bu sizin haiku'nuz değil");
        sharedHaikus[_to][_id] = true;
    }
    // Çağıranla paylaşılan haikuları alma fonksiyonu
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
    // Özel hata mesajları
    error HaikuNotUnique(); // Benzersiz olmayan bir haiku basmaya çalışırken hata
    error NotYourHaiku(); // Çağıranın sahip olmadığı bir haiku'yu paylaşmaya çalışırken hata
    error NoHaikusShared(); // Çağıranla paylaşılmış haiku bulunmadığında hata
}
