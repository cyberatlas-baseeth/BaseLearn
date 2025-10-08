// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Employee
 * @dev Çalışanlara ait ortak özellikleri ve davranışları tanımlayan soyut (abstract) sözleşme.
 */
abstract contract Employee {
    uint public idNumber;   // Çalışanın benzersiz kimlik numarası
    uint public managerId;  // Çalışanı yöneten yöneticinin kimlik numarası

    /**
     * @dev Kurucu fonksiyon (constructor), idNumber ve managerId değerlerini başlatır.
     * @param _idNumber Çalışanın benzersiz kimlik numarası.
     * @param _managerId Çalışanı yöneten yöneticinin kimlik numarası.
     */
    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    /**
     * @dev Alt sözleşmeler tarafından uygulanması gereken soyut fonksiyon.
     * Çalışanın yıllık maliyetini döndürür.
     * @return Çalışanın yıllık maliyeti.
     */
    function getAnnualCost() public virtual returns (uint);
}

/**
 * @title Salaried
 * @dev Yıllık maaş ile çalışan çalışanları temsil eden sözleşme.
 */
contract Salaried is Employee {
    uint public annualSalary; // Çalışanın yıllık maaşı

    /**
     * @dev Kurucu fonksiyon, Salaried sözleşmesini başlatır.
     * @param _idNumber Çalışanın benzersiz kimlik numarası.
     * @param _managerId Çalışanı yöneten yöneticinin kimlik numarası.
     * @param _annualSalary Çalışanın yıllık maaşı.
     */
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    /**
     * @dev getAnnualCost fonksiyonunu override ederek çalışanın yıllık maaşını döndürür.
     * @return Çalışanın yıllık maaşı.
     */
    function getAnnualCost() public override view returns (uint) {
        return annualSalary;
    }
}

/**
 * @title Hourly
 * @dev Saatlik ücret ile çalışan çalışanları temsil eden sözleşme.
 */
contract Hourly is Employee {
    uint public hourlyRate; // Çalışanın saatlik ücreti

    /**
     * @dev Kurucu fonksiyon, Hourly sözleşmesini başlatır.
     * @param _idNumber Çalışanın benzersiz kimlik numarası.
     * @param _managerId Çalışanı yöneten yöneticinin kimlik numarası.
     * @param _hourlyRate Çalışanın saatlik ücreti.
     */
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    /**
     * @dev getAnnualCost fonksiyonunu override eder.
     * Saatlik ücret üzerinden yıllık maliyeti hesaplar.
     * (Tam zamanlı çalışanın yılda 2080 saat çalıştığı varsayılır.)
     * @return Çalışanın yıllık maliyeti.
     */
    function getAnnualCost() public override view returns (uint) {
        return hourlyRate * 2080;
    }
}

/**
 * @title Manager
 * @dev Yöneticilerin yönettiği çalışan kimliklerini tutan sözleşme.
 */
contract Manager {
    uint[] public employeeIds; // Yöneticinin raporladığı çalışanların kimlik numaraları listesi

    /**
     * @dev Yeni bir çalışan kimliğini listeye ekler.
     * @param _reportId Eklenecek çalışanın kimlik numarası.
     */
    function addReport(uint _reportId) public {
        employeeIds.push(_reportId);
    }

    /**
     * @dev Çalışan kimlikleri listesini sıfırlar (boşaltır).
     */
    function resetReports() public {
        delete employeeIds;
    }
}

/**
 * @title Salesperson
 * @dev Saatlik ücretle çalışan satış personelini temsil eden sözleşme.
 */
contract Salesperson is Hourly {
    /**
     * @dev Salesperson sözleşmesini başlatır.
     * @param _idNumber Çalışanın benzersiz kimlik numarası.
     * @param _managerId Çalışanı yöneten yöneticinin kimlik numarası.
     * @param _hourlyRate Çalışanın saatlik ücreti.
     */
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
        Hourly(_idNumber, _managerId, _hourlyRate) {}
}

/**
 * @title EngineeringManager
 * @dev Maaşlı çalışan olup aynı zamanda yönetici olan mühendislik yöneticisini temsil eden sözleşme.
 */
contract EngineeringManager is Salaried, Manager {
    /**
     * @dev EngineeringManager sözleşmesini başlatır.
     * @param _idNumber Çalışanın benzersiz kimlik numarası.
     * @param _managerId Çalışanı yöneten yöneticinin kimlik numarası.
     * @param _annualSalary Çalışanın yıllık maaşı.
     */
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
        Salaried(_idNumber, _managerId, _annualSalary) {}
}

/**
 * @title InheritanceSubmission
 * @dev Salesperson ve EngineeringManager sözleşmelerinin örneklerini tutan sözleşme.
 */
contract InheritanceSubmission {
    address public salesPerson;         // Dağıtılan Salesperson sözleşmesinin adresi
    address public engineeringManager;  // Dağıtılan EngineeringManager sözleşmesinin adresi

    /**
     * @dev InheritanceSubmission sözleşmesini başlatır.
     * @param _salesPerson Dağıtılmış Salesperson sözleşmesinin adresi.
     * @param _engineeringManager Dağıtılmış EngineeringManager sözleşmesinin adresi.
     */
    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
