// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EmployeeStorage {
    // Çalışan verilerini depolamak için özel durum değişkenlerini tanımla
    uint16 private shares; // Çalışanın sahip olduğu pay sayısı (sözleşmeye özel)
    uint32 private salary; // Çalışanın aylık maaşı (sözleşmeye özel)
    uint256 public idNumber; // Çalışanın benzersiz kimlik numarası (herkese açık)
    string public name; // Çalışanın ismi (herkese açık)

    // Sözleşme dağıtıldığında çalışan verilerini başlatmak için constructor
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber) {
        shares = _shares; // Payları başlat
        name = _name; // İsmi başlat
        salary = _salary; // Maaşı başlat
        idNumber = _idNumber; // Kimlik numarasını başlat
    }

    // Çalışanın sahip olduğu pay sayısını almak için görünüm fonksiyonu
    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    // Çalışanın aylık maaşını almak için görünüm fonksiyonu
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    // Özel hata bildirimi
    error TooManyShares(uint16 _shares);
    
    // Çalışana ek paylar verme fonksiyonu
    function grantShares(uint16 _newShares) public {
        // Check if the requested shares exceed the limit
        if (_newShares > 5000) {
            revert("Too many shares"); // Revert with error message
        } else if (shares + _newShares > 5000) {
            revert TooManyShares(shares + _newShares); // Revert with custom error message
        }
        shares += _newShares; // Grant the new shares
    }

    // Depolama değişkenlerinin paketlenmesini test etmek için kullanılan fonksiyon (ana işlevsellikle ilgili değil)
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    // Hata ayıklama amaçları için payları sıfırlama fonksiyonu (ana işlevsellikle ilgili değil)
    function debugResetShares() public {
        shares = 1000; // Reset shares to 1000
    }
}
