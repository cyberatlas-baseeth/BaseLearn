// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StorageV2 {
    // --- State Variables ---
    // Daha iyi packing / okunabilirlik için ordering’e dikkat ettim

    // Employee bilgileri
    string public name;
    uint256 public idNumber;

    // shares ve salary, aynı slot’a sıkıştırılabilir (packing)
    uint32 private salary;     // 4 byte
    uint224 private shares;    // 28 byte → toplam 32 byte

    // Diğer durumlar için hata
    error TooManyShares(uint256 wouldBeShares);

    // --- Constructor ---
    constructor(
        string memory _name,
        uint256 _id,
        uint224 _initialShares,
        uint32 _initialSalary
    ) {
        name = _name;
        idNumber = _id;
        shares = _initialShares;
        salary = _initialSalary;
    }

    // --- View Fonksiyonları ---
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    function viewShares() public view returns (uint224) {
        return shares;
    }

    // --- Share verme / alma işlemi ---
    function grantShares(uint224 _newShares) public {
        // Basit sınır kontrolü
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        uint256 newTotal = uint256(shares) + uint256(_newShares);
        if (newTotal > 5000) {
            revert TooManyShares(newTotal);
        }
        shares = uint224(newTotal);
    }

    function reduceShares(uint224 _removeShares) public {
        if (_removeShares > shares) {
            revert("Cannot remove more than existing");
        }
        shares = shares - _removeShares;
    }

    // --- Debug / yardımcı fonksiyonlar ---
    /// @notice Storage slot içeriğini düşük seviyeli okumak için (örneğin inspect amaçlı)
    function checkSlot(uint256 slot) public view returns (bytes32 data) {
        assembly {
            data := sload(slot)
        }
    }

    /// @notice Shares değerini sıfırlayıp başlangıç değerine çekmek için
    function resetShares(uint224 _to) public {
        shares = _to;
    }
}
