// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeStorage {
    // --- State Variables ---
    // Combine storage slots / packing için optimal düzenleme yapılmalı

    // shares ve salary’yi aynı slotta paketlemek mümkün olabilir
    // Çünkü salary 0..1_000_000 aralığında => ~20 bit’lik değer yeterli
    // shares ise büyük değerler alabilir (uint256), ama burada optimize etmeye çalışacağız

    uint256 private shares;    // 256 bit — tam genişlik kullandık
    uint32 private salary;     // 32 bit, 1.000.000 < 2^20 olduğundan 32 bit yeterli

    string public name;
    uint256 public idNumber;

    // Custom error
    error TooManyShares(uint256 wouldBeShares);

    // --- Constructor ---
    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50000;
        idNumber = 112358132134;
    }

    // --- View Functions ---
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    function viewShares() public view returns (uint256) {
        return shares;
    }

    // --- Grant Shares ---
    function grantShares(uint256 _newShares) public {
        // Eğer _newShares > 5000, revert ile string mesaj
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        uint256 newTotal = shares + _newShares;
        if (newTotal > 5000) {
            revert TooManyShares(newTotal);
        }
        shares = newTotal;
    }

    // --- Fonksiyonlar test için verildiği şekilde ---
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}
