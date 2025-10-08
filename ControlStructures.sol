// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ControlStructures {
    // Custom error for after hours, include the time provided
    error AfterHours(uint256 time);

    /// @notice FizzBuzz fonksiyonu
    /// @param _number Girdi sayısı
    /// @return result “Fizz”, “Buzz”, “FizzBuzz” veya “Splat”
    function fizzBuzz(uint256 _number) public pure returns (string memory result) {
        bool div3 = (_number % 3 == 0);
        bool div5 = (_number % 5 == 0);

        if (div3 && div5) {
            return "FizzBuzz";
        } else if (div3) {
            return "Fizz";
        } else if (div5) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    /// @notice Do Not Disturb fonksiyonu
    /// @param _time Zaman değeri (örneğin 1300, 2100 vs.)
    /// @return greeting Uygun metin (Morning!, Afternoon! vs.)
    function doNotDisturb(uint256 _time) public pure returns (string memory greeting) {
        // Eğer zaman 2400 veya daha büyükse “panic” olmalı → solidity’de assert / unreacheable gibi kullanabiliriz
        // Burada revert ile panic durumuna benzetebiliriz:
        if (_time >= 2400) {
            // Bu durumu panic gibi ele almak için “assert(false)” de kullanılabilir,
            // burada explicit olarak revert ediyoruz:
            revert("Time value invalid");  // Bu bir panic değil klasik revert’dır ama semantik olarak benzetiyoruz
        }

        // Eğer saat 2200’den büyükse veya 800’den küçükse AfterHours custom error
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        // Eğer 1200 ile 1259 arasındaysa “At lunch!”
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }

        // 800–1199 → “Morning!”
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }

        // 1300–1799 → “Afternoon!”
        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }

        // 1800–2200 → “Evening!”
        if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // Eğer hiçbir koşula uymuyorsa, bu durumda fallback davranışı:
        revert("Unhandled time range");
    }
}
