// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title FavoriAlbümler
 * @dev Onaylanmış müzik albümlerini yönetmek ve kullanıcıların bunları favorilerine eklemesine izin vermek için bir sözleşme
 */
contract FavoriteRecords {
    // Bir albümün onaylı olup olmadığını saklayan mapping
    mapping(string => bool) private approvedRecords;
    // Onaylı albümlerin indeksini saklayan dizi
    string[] private approvedRecordsIndex;

    // Kullanıcıların favori albümlerini saklayan mapping
    mapping(address => mapping(string => bool)) public userFavorites;
    // Kullanıcıların favori albümlerinin indeksini saklayan mapping
    mapping(address => string[]) private userFavoritesIndex;

    // Onaylanmamış albümler için özel hata
    error NotApproved(string albumName);

    /**
     * @dev Onaylı albümler listesini başlatan yapıcı fonksiyon
     */
    constructor() {
        // Önceden tanımlanmış onaylı albümler listesi
        approvedRecordsIndex = [
            "Thriller", 
            "Back in Black", 
            "The Bodyguard", 
            "The Dark Side of the Moon", 
            "Their Greatest Hits (1971-1975)", 
            "Hotel California", 
            "Come On Over", 
            "Rumours", 
            "Saturday Night Fever"
        ];
        // Onaylı albümler mapping'ini başlat
        for (uint i = 0; i < approvedRecordsIndex.length; i++) {
            approvedRecords[approvedRecordsIndex[i]] = true;
        }
    }

    /**
     * @dev Onaylı albümler listesini döndürür
     * @return Onaylı albüm isimlerinin bir dizisi
     */
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsIndex;
    }

    /**
     * @dev Onaylı bir albümü kullanıcının favorilerine ekler
     * @param _albumName Eklenecek albümün adı
     */
    function addRecord(string memory _albumName) public {
        // Albümün onaylı olup olmadığını kontrol et
        if (!approvedRecords[_albumName]) {
            revert NotApproved({albumName: _albumName});
        }
        // Albümün kullanıcının favorileri arasında olup olmadığını kontrol et
        if (!userFavorites[msg.sender][_albumName]) {
            // Albümü kullanıcının favorilerine ekle
            userFavorites[msg.sender][_albumName] = true;
            // Albümü kullanıcının favori albümler indeksine ekle
            userFavoritesIndex[msg.sender].push(_albumName);
        }
    }

    /**
     * @dev Bir kullanıcının favori albümlerinin listesini döndürür
     * @param _address Kullanıcının adresi
     * @return Kullanıcının favori albüm isimlerinin bir dizisi
     */
    function getUserFavorites(address _address) public view returns (string[] memory) {
        return userFavoritesIndex[_address];
    }

    /**
     * @dev Çağıranın favori albümler listesini sıfırlar
     */
    function resetUserFavorites() public {
        // Kullanıcının favori albümleri arasında gezin
        for (uint i = 0; i < userFavoritesIndex[msg.sender].length; i++) {
            // Her albümü kullanıcının favoriler mapping'inden sil
            delete userFavorites[msg.sender][userFavoritesIndex[msg.sender][i]];
        }
        // Kullanıcının favori albümler indeksini sil
        delete userFavoritesIndex[msg.sender];
    }
}
