// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract ErrorTriageExercise {

    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        // Farkları saklamak için bir dizi başlat
        uint[] memory results = new uint[](3);

        // Her bir tamsayı çifti arasındaki mutlak farkı hesapla ve sonucu results dizisinde sakla
        results[0] = _a > _b ? _a - _b : _b - _a;
        results[1] = _b > _c ? _b - _c : _c - _b;
        results[2] = _c > _d ? _c - _d : _d - _c;
        
        
        return results;
    }


 //@dev Temel değeri, değiştirici değerine göre değiştirir. Temel değer her zaman 1000 veya daha büyük olmalıdır. 
 //Değiştiriciler, pozitif veya negatif 100 arasında olabilir.
 //@param _base Değiştirilecek temel değer.
 //@param _modifier Temel değeri değiştirecek olan değer.
 
 //@return returnValue Temel değerin değiştirilmiş hali.

    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint returnValue) {
        
        if(_modifier > 0) {
            return _base + uint(_modifier);
        }
        return _base - uint(-_modifier);
    }


    uint[] arr;

    function popWithReturn() public returns (uint returnNum) {
        if(arr.length > 0) {
            uint result = arr[arr.length - 1];
            arr.pop();
            return result;
        }
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
