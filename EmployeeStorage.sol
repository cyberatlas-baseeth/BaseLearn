// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EmployeeStorage {
    // Çalışan verilerini saklamak için özel durum değişkenleri tanımlayın
    uint16 private shares; // Çalışanın sahip olduğu hisse sayısı (sözleşmeye özel)
    uint32 private salary; // Çalışanın aylık maaşı (sözleşmeye özel)
    uint256 public idNumber; // Çalışanın benzersiz kimlik numarası (herkese açık)
    string public name; // Çalışanın adı (herkese açık)

    // Sözleşme dağıtıldığında çalışan verilerini başlatmak için yapıcı fonksiyon
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber) {
        shares = _shares; // Hisse sayısını başlat
        name = _name; // Adı başlat
        salary = _salary; // Maaşı başlat
        idNumber = _idNumber; // Kimlik numarasını başlat
    }

    // Çalışanın sahip olduğu hisse sayısını almak için görüntüleme fonksiyonu
    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    // Çalışanın aylık maaşını almak için görüntüleme fonksiyonu
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    // Özel hata bildirimi
    error TooManyShares(uint16 _shares);
    
    // Çalışana ek hisse vermek için fonksiyon
    function grantShares(uint16 _newShares) public {
        // Talep edilen hisse sayısının limiti aşıp aşmadığını kontrol et
        if (_newShares > 5000) {
            revert("Çok fazla hisse"); // Hata mesajıyla işlemi geri al
        } else if (shares + _newShares > 5000) {
            revert TooManyShares(shares + _newShares); // Özel hata mesajıyla işlemi geri al
        }
        shares += _newShares; // Yeni hisseleri ver
    }

    // Depolama değişkenlerinin paketlenmesini test etmek için kullanılan fonksiyon (ana işlevsellikle ilgili değil)
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    // Hata ayıklama amacıyla hisseleri sıfırlama fonksiyonu (ana işlevsellikle ilgili değil)
    function debugResetShares() public {
        shares = 1000; // Hisseleri 1000'e sıfırla
    }
}
