// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title GarageManager
 * @dev Her kullanıcının kendine ait araba garajını yönetmesini sağlayan sözleşme
 */
contract GarageManager {
    // Her kullanıcı için bir araba listesi (garaj) tutan mapping
    mapping(address => Car[]) private garages;

    // Araba bilgilerini temsil eden yapı (struct)
    struct Car {
        string make; // Arabanın markası (örnek: Toyota)
        string model; // Arabanın modeli (örnek: Corolla)
        string color; // Arabanın rengi (örnek: Kırmızı)
        uint numberOfDoors; // Arabanın kapı sayısı
    }

    // Geçersiz araba indeksleri için özel hata türü
    error BadCarIndex(uint256 index);

    /**
     * @dev Çağıran kullanıcının garajına yeni bir araba ekler
     * @param _make Arabanın markası
     * @param _model Arabanın modeli
     * @param _color Arabanın rengi
     * @param _numberOfDoors Arabanın kapı sayısı
     */
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        // Yeni araba bilgilerini kullanıcının garajına ekler
        garages[msg.sender].push(Car(_make, _model, _color, _numberOfDoors));
    }

    /**
     * @dev Çağıran kullanıcının sahip olduğu arabaları getirir
     * @return Kullanıcının sahip olduğu `Car` struct dizisini döner
     */
    function getMyCars() external view returns (Car[] memory) {
        // Kullanıcının garajındaki arabaları döndürür
        return garages[msg.sender];
    }

    /**
