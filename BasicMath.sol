// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {
    /// @notice Toplama işlemi, overflow kontrolü ile
    /// @param _a Birinci değer
    /// @param _b İkinci değer
    /// @return sum Toplam sonucu (overflow yoksa)
    /// @return error Overflow olursa true, değilse false
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        unchecked {
            uint c = _a + _b;
            // overflow kontrolü: c < _a olursa overflow olmuş demektir
            if (c < _a) {
                return (0, true);
            }
            return (c, false);
        }
    }

    /// @notice Çıkarma işlemi, underflow kontrolü ile
    /// @param _a Minuend (çıkan değer)
    /// @param _b Subtrahend (çıkan)
    /// @return difference Fark (underflow yoksa)
    /// @return error Underflow olursa true, değilse false
    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        // Underflow kontrolü: _b > _a olursa underflow olur
        if (_b > _a) {
            return (0, true);
        }
        uint d = _a - _b;
        return (d, false);
    }
}
