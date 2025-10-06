// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        // Farklılıkları depolamak için results array'i tanımlanır
        uint[] memory results = new uint[](3);

        // HATA: "results" değişkeni tanımlanmamıştı (Undeclared identifier).
        // ÇÖZÜM: results adlı bir memory array tanımlayıp uzunluğunu 3 yapıyoruz.
        // Ayrıca uint'lar arasında çıkarma negatif sonuç verebileceği için (underflow)
        // mutlak fark alıyoruz (büyük olan - küçük olan).
        results[0] = _a > _b ? _a - _b : _b - _a;
        results[1] = _b > _c ? _b - _c : _c - _b;
        results[2] = _c > _d ? _c - _d : _d - _c;

        return results;
    }

    /**
     * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
     * between positive and negative 100;
     *
     * ⚠️ HATA:
     *   Solidity'de uint (işaretsiz) ile int (işaretli) türleri doğrudan toplanamaz.
     *   Yani "_base + _modifier" ifadesi "TypeError: Built-in binary operator + cannot be applied to types uint256 and int256"
     *   hatası üretir.
     *
     * ✅ ÇÖZÜM:
     *   _modifier pozitifse uint'e çevirip ekliyoruz.
     *   _modifier negatifse işaretini değiştirip uint'e çeviriyor ve çıkarıyoruz.
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        if (_modifier >= 0) {
            // Pozitif modifier için direkt toplama
            return _base + uint(_modifier);
        } else {
            // Negatif modifier için çıkarma işlemi
            return _base - uint(-_modifier);
        }
    }

    /**
     * Pop the last element from the supplied array, and return the popped
     * value (unlike the built-in function)
     */
    uint[] arr;

    function popWithReturn() public returns (uint) {
        uint index = arr.length - 1;
        delete arr[index];
        return arr[index];
    }

    // The utility functions below are working as expected
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
