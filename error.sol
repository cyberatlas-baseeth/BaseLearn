// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title ErrorTriageExercise
 * @dev Fark hesaplama, sayı değiştirici (modifier) uygulama ve dizilerle çalışma örneklerini içeren sözleşme
 */
contract ErrorTriageExercise {
    /**
     * @dev Verilen 4 sayının (a, b, c, d) birbirine komşu farklarını bulur.
     * Her iki komşu sayı arasındaki mutlak farkı alır ve bir dizi olarak döndürür.
     *
     * Örnek:
     *   a=10, b=5, c=12, d=9
     *   Sonuç: [|10-5|, |5-12|, |12-9|] → [5, 7, 3]
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        // 3 fark hesaplanacağı için uzunluğu 3 olan bir dizi tanımlanır
        uint ;

        // Her komşu sayı arasındaki mutlak fark hesaplanır
        results[0] = _a > _b ? _a - _b : _b - _a; // |a - b|
        results[1] = _b > _c ? _b - _c : _c - _b; // |b - c|
        results[2] = _c > _d ? _c - _d : _d - _c; // |c - d|

        // Sonuç dizisi döndürülür
        return results;
    }

    /**
     * @dev Verilen "_base" değerine "_modifier" ekler veya çıkarır.
     * "_base" her zaman >= 1000’dir.
     * "_modifier" -100 ile +100 arasında bir tam sayıdır (negatif veya pozitif olabilir).
     *
     * Solidity’de uint (işaretsiz) ve int (işaretli) türleri doğrudan toplanamaz.
     * Bu yüzden koşul kontrolü yapılarak tür dönüşümü yapılır.
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        if (_modifier >= 0) {
            // Modifier pozitifse uint’e çevirilip eklenir
            return _base + uint(_modifier);
        } else {
            // Modifier negatifse işaret değiştirip uint’e çevirilir ve çıkarılır
            return _base - uint(-_modifier);
        }
    }

    /**
     * @dev Sözleşme içinde tutulan "arr" adlı dinamik diziyi temsil eder.
     * Bu diziye sayılar eklenebilir, sıfırlanabilir veya eleman silinebilir.
     */
    uint[] arr;

    /**
     * @dev Dizinin son elemanını siler (pop işlemi gibi) ve silinen değeri döndürür.
     * Solidity’nin yerleşik "pop()" fonksiyonu değeri döndürmez,
     * bu fonksiyon ise sildiği değeri döndürür.
     *
     * ⚠️ Uyarı:
     * - Bu fonksiyon dizideki son değeri sıfırlar ama dizinin uzunluğunu azaltmaz.
     * - Gerçek "pop()" işlemi gibi eleman sayısını azaltmak için "arr.pop()" kullanılmalıdır.
     */
    function popWithReturn() public returns (uint) {
        uint index = arr.length - 1; // Son elemanın indeksi
        delete arr[index];           // Son eleman silinir (0’a set edilir)
        return arr[index];           // Silinen değer (artık 0) döndürülür
    }

    /**
     * @dev Diziye yeni bir sayı ekler.
     * @param _num Eklenecek sayı
     */
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    /**
     * @dev Dizi içeriğini görüntüler.
     * @return Bellekteki dizinin bir kopyası döndürülür
     */
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    /**
     * @dev Dizi içeriğini tamamen siler ve sıfırlar.
     */
    function resetArr() public {
        delete arr;
    }
}
