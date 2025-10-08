// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
// AddressBook sözleşmesiyle etkileşim kurmak için içe aktar
import "./AddressBook.sol";
// Yeni AddressBook örnekleri oluşturmak için sözleşme
contract AddressBookFactory {
    // Dahili kullanım için özel bir tuz değeri tanımla
    string private salt = "value";
    // Yeni bir AddressBook örneği dağıtmak için fonksiyon
    function deploy() external returns (AddressBook) {
        // Yeni bir AddressBook örneği oluştur
        AddressBook newAddressBook = new AddressBook();
        // Yeni AddressBook sözleşmesinin sahipliğini bu fonksiyonu çağıran kişiye devret
        newAddressBook.transferOwnership(msg.sender);
        // Yeni oluşturulan AddressBook sözleşmesini döndür
        return newAddressBook;
    }
}
