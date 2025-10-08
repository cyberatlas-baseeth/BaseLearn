// SPDX-License-Identifier: MIT
// Kodun lisansını belirtir. Bu sözleşme MIT lisansı altında yayınlanmıştır ve açık kaynak olarak kullanılabilir.

pragma solidity ^0.8.17;
// Solidity derleyicisinin sürümünü belirtir. Bu kod, 0.8.17 veya daha yeni bir sürümle derlenmelidir.

contract EmployeeStorage {
    // Çalışan verilerini saklamak için bir akıllı sözleşme tanımlar.

    // Özel (private) durum değişkenleri, çalışan verilerini saklar
    uint16 private shares; // Çalışanın sahip olduğu hisse sayısı (sadece sözleşme içinde erişilebilir)
    uint32 private salary; // Çalışanın aylık maaşı (sadece sözleşme içinde erişilebilir)
    uint256 public idNumber; // Çalışanın benzersiz kimlik numarası (herkese açık, dışarıdan erişilebilir)
    string public name; // Çalışanın adı (herkese açık, dışarıdan erişilebilir)

    // Sözleşme dağıtıldığında çalışan verilerini başlatmak için kullanılan yapıcı (constructor) fonksiyon
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber) {
        shares = _shares; // Hisse sayısını başlatır
        name = _name; // Çalışan adını başlatır
        salary = _salary; // Maaşı başlatır
        idNumber = _idNumber; // Kimlik numarasını başlatır
    }

    // Çalışanın hisse sayısını döndüren bir görüntüleme (view) fonksiyonu
    function viewShares() public view returns (uint16) {
        return shares; // Çalışanın sahip olduğu hisse sayısını döndürür
    }
    
    // Çalışanın aylık maaşını döndüren bir görüntüleme (view) fonksiyonu
    function viewSalary() public view returns (uint32) {
        return salary; // Çalışanın maaşını döndürür
    }

    // Özel hata tanımı
    error TooManyShares(uint16 _shares);
    // Çok fazla hisse verilmeye çalışıldığında kullanılacak bir hata mesajı tanımlar
    
    // Çalışana ek hisse veren fonksiyon
    function grantShares(uint16 _newShares) public {
        // İstenen hisse sayısının limitleri aşıp aşmadığını kontrol eder
        if (_newShares > 5000) {
            revert("Cok fazla hisse"); // Eğer yeni hisse sayısı 5000'den fazlaysa hata döndürür
        } else if (shares + _newShares > 5000) {
            revert TooManyShares(shares + _newShares); // Toplam hisse 5000'i aşarsa özel hata mesajı döndürür
        }
        shares += _newShares; // Yeni hisseleri çalışanın mevcut hisselerine ekler
    }

    // Depolama değişkenlerinin paketlenmesini test etmek için kullanılan fonksiyon (ana işlevsellikle ilgili değil)
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot) // Belirtilen depolama yuvasındaki (slot) veriyi okur
        }
    }

    // Hata ayıklama (debug) amacıyla hisse sayısını sıfırlayan fonksiyon (ana işlevsellikle ilgili değil)
    function debugResetShares() public {
        shares = 1000; // Hisse sayısını 1000 olarak sıfırlar
    }
}
