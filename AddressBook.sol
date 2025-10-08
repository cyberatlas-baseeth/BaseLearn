// SPDX-License-Identifier: GPL-3.0
// Sözleşmenin lisans türünü belirtir: GNU General Public License v3.0.

pragma solidity ^0.8.8;
// Solidity derleyici sürümünü belirtir. Sözleşme, 0.8.8 veya daha yeni bir sürümle derlenmelidir.

import "@openzeppelin/contracts/access/Ownable.sol";
// OpenZeppelin kütüphanesinden Ownable sözleşmesini içeri aktarır. Bu, yalnızca sözleşme sahibinin belirli işlevleri çağırabilmesini sağlayan bir erişim kontrol mekanizmasıdır.

contract AddressBook is Ownable {
    // AddressBook adında bir akıllı sözleşme tanımlar ve Ownable'dan miras alır, böylece yalnızca sözleşme sahibi (owner) belirli işlemleri gerçekleştirebilir.

    // Özel bir "salt" (tuz) değeri tanımlar. Bu değer dahili kullanım içindir ve şu anda kullanılmamaktadır.
    string private salt = "value";

    // Bir kişiyi temsil eden bir veri yapısı (struct) tanımlar.
    struct Contact {
        uint id; // Kişinin benzersiz kimlik numarası
        string firstName; // Kişinin adı
        string lastName; // Kişinin soyadı
        uint[] phoneNumbers; // Kişinin birden fazla telefon numarasını saklayan dizi
    }

    // Tüm kişileri saklamak için bir dizi tanımlar. Bu dizi özel (private) olup yalnızca sözleşme içinden erişilebilir.
    Contact[] private contacts;

    // Her bir kişinin kimliğini (ID) dizideki indeksine eşleyen bir harita (mapping).
    mapping(uint => uint) private idToIndex;

    // Bir sonraki kişi için kullanılacak kimlik numarasını takip eden değişken.
    uint private nextId = 1;

    // Kişi bulunamadığında kullanılacak özel bir hata mesajı tanımlar.
    error ContactNotFound(uint id);

    // 🔧 DÜZELTME: Yapıcı (constructor) fonksiyon eklendi. Ownable sözleşmesi için gerekli.
    // Sözleşme oluşturulurken msg.sender (sözleşmeyi dağıtan adres) sahibi olarak atanır.
    constructor() Ownable(msg.sender) {}

    // Yeni bir kişi eklemek için fonksiyon. Yalnızca sözleşme sahibi çağırabilir.
    function addContact(string calldata firstName, string calldata lastName, uint[] calldata phoneNumbers) external onlyOwner {
        // Sağlanan bilgilerle yeni bir kişi oluşturur ve contacts dizisine ekler.
        contacts.push(Contact(nextId, firstName, lastName, phoneNumbers));
        // Yeni kişinin kimliğini dizideki indeksine eşler.
        idToIndex[nextId] = contacts.length - 1;
        // Bir sonraki kişi için kimlik numarasını artırır.
        nextId++;
    }

    // Belirtilen kimlik numarasına sahip bir kişiyi silmek için fonksiyon. Yalnızca sözleşme sahibi çağırabilir.
    function deleteContact(uint id) external onlyOwner {
        // Silinecek kişinin dizideki indeksini alır.
        uint index = idToIndex[id];
        // İndeksin geçerli olup olmadığını ve kişinin var olup olmadığını kontrol eder.
        if (index >= contacts.length || contacts[index].id != id) revert ContactNotFound(id);
        // Silinecek kişiyi dizinin son elemanıyla değiştirir.
        contacts[index] = contacts[contacts.length - 1];
        // Taşınan kişinin indeksini günceller.
        idToIndex[contacts[index].id] = index;
        // Dizinin son elemanını kaldırır.
        contacts.pop();
        // Silinen kişinin kimlik-indeks eşlemesini kaldırır.
        delete idToIndex[id];
    }

    // Belirtilen kimlik numarasına sahip bir kişinin bilgilerini döndüren fonksiyon.
    function getContact(uint id) external view returns (Contact memory) {
        // Kişinin dizideki indeksini alır.
        uint index = idToIndex[id];
        // İndeksin geçerli olup olmadığını ve kişinin var olup olmadığını kontrol eder.
        if (index >= contacts.length || contacts[index].id != id) revert ContactNotFound(id);
        // Kişinin bilgilerini döndürür.
        return contacts[index];
    }

    // Tüm kişileri döndüren fonksiyon.
    function getAllContacts() external view returns (Contact[] memory) {
        // Tüm kişiler dizisini döndürür.
        return contacts;
    }
}
