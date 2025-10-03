// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArraysExercise {
    // Başlangıç array’i 1–10 ile tanımlı
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    // Yeni state değişkenleri: senders ve timestamps
    address[] public senders;
    uint[] public timestamps;

    /// @notice Tüm `numbers` array’ini döndürür
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    /// @notice `numbers` array’ini baştaki haline döndürür (1–10)
    function resetNumbers() public {
        // Daha gaz verimli bir yöntem: tüm elemanları silip yeniden atama
        // delete numbers;  // bu, tüm elemanları sıfırlar
        // sonra yeniden kurarız:
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    /// @notice `_toAppend` array’ini `numbers` array’inin sonuna ekler
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    /// @notice Çağıranın adresini ve verilen timestamp’i kaydeder
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    /// @notice Y2K sonrası (≥ 946702800) timestamp’leri ve karşılık gelen adresleri döndürür
    /// @return filteredTimestamps Filtrelenmiş timestamp listesi
    /// @return filteredSenders Bu timestamp’lere karşılık gelen adresler
    function afterY2K() public view returns (uint[] memory filteredTimestamps, address[] memory filteredSenders) {
        uint cutoff = 946702800;

        // Önce kaç tane eleman uygun olacak sayısını bul
        uint count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > cutoff) {
                count++;
            }
        }

        // Yeni array’leri uygun uzunlukta oluştur
        filteredTimestamps = new uint[](count);
        filteredSenders = new address[](count);

        // Uygun elemanları doldur
        uint idx = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > cutoff) {
                filteredTimestamps[idx] = timestamps[i];
                filteredSenders[idx] = senders[i];
                idx++;
            }
        }
    }

    /// @notice `senders` array’ini temizler
    function resetSenders() public {
        delete senders;
    }

    /// @notice `timestamps` array’ini temizler
    function resetTimestamps() public {
        delete timestamps;
    }
}
