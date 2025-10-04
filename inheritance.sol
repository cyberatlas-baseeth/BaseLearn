// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title Çalışan
 * @dev Çalışanlar için ortak özellikler ve davranışları tanımlayan soyut sözleşme.
 */
abstract contract Employee {
    uint public idNumber; // Çalışanın benzersiz tanımlayıcısı
    uint public managerId; // Çalışanı denetleyen yöneticinin tanımlayıcısı

    /**
     * @dev idNumber ve managerId'yi başlatan yapıcı fonksiyon.
     * @param _idNumber Çalışanın benzersiz tanımlayıcısı.
     * @param _managerId Çalışanı denetleyen yöneticinin tanımlayıcısı.
     */
    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    /**
     * @dev Türetilmiş sözleşmeler tarafından uygulanması gereken, çalışanın yıllık maliyetini döndüren soyut fonksiyon.
     * @return Çalışanın yıllık maliyeti.
     */
    function getAnnualCost() public virtual returns (uint);
}

/**
 * @title Maaşlı
 * @dev Yıllık maaş alan çalışanları temsil eden sözleşme.
 */
contract Salaried is Employee {
    uint public annualSalary; // Çalışanın yıllık maaşı

    /**
     * @dev Maaşlı sözleşmeyi başlatan yapıcı fonksiyon.
     * @param _idNumber Çalışanın benzersiz tanımlayıcısı.
     * @param _managerId Çalışanı denetleyen yöneticinin tanımlayıcısı.
     * @param _annualSalary Çalışanın yıllık maaşı.
     */
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    /**
     * @dev Çalışanın yıllık maaşını döndürmek için getAnnualCost fonksiyonunu geçersiz kılar.
     * @return Çalışanın yıllık maaşı.
     */
    function getAnnualCost() public override view returns (uint) {
        return annualSalary;
    }
}

/**
 * @title Saatlik
 * @dev Saatlik ücret alan çalışanları temsil eden sözleşme.
 */
contract Hourly is Employee {
    uint public hourlyRate; // Çalışanın saatlik ücreti

    /**
     * @dev Saatlik sözleşmeyi başlatan yapıcı fonksiyon.
     * @param _idNumber Çalışanın benzersiz tanımlayıcısı.
     * @param _managerId Çalışanı denetleyen yöneticinin tanımlayıcısı.
     * @param _hourlyRate Çalışanın saatlik ücreti.
     */
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    /**
     * @dev Saatlik ücrete göre yıllık maliyeti hesaplamak için getAnnualCost fonksiyonunu geçersiz kılar.
     * Yıllık tam zamanlı çalışma süresi 2080 saat olarak varsayılır.
     * @return Çalışanın yıllık maliyeti.
     */
    function getAnnualCost() public override view returns (uint) {
        return hourlyRate * 2080;
    }
}

/**
 * @title Yönetici
 * @dev Çalışan kimliklerinin bir listesini yöneten sözleşme.
 */
contract Manager {
    uint[] public employeeIds; // Çalışan kimliklerinin listesi

    /**
     * @dev Yeni bir çalışan kimliğini listeye ekleyen fonksiyon.
     * @param _reportId Eklenecek çalışanın kimliği.
     */
    function addReport(uint _reportId) public {
        employeeIds.push(_reportId);
    }

    /**
     * @dev Çalışan kimlikleri listesini sıfırlayan fonksiyon.
     */
    function resetReports() public {
        delete employeeIds;
    }
}

/**
 * @title SatışTemsilcisi
 * @dev Saatlik ücret alan satış temsilcilerini temsil eden sözleşme.
 */
contract Salesperson is Hourly {
    /**
     * @dev SatışTemsilcisi sözleşmesini başlatan yapıcı fonksiyon.
     * @param _idNumber Çalışanın benzersiz tanımlayıcısı.
     * @param _managerId Çalışanı denetleyen yöneticinin tanımlayıcısı.
     * @param _hourlyRate Çalışanın saatlik ücreti.
     */
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
        Hourly(_idNumber, _managerId, _hourlyRate) {}
}

/**
 * @title MühendislikYöneticisi
 * @dev Yıllık maaş alan ve yönetim sorumlulukları olan mühendislik yöneticilerini temsil eden sözleşme.
 */
contract EngineeringManager is Salaried, Manager {
    /**
     * @dev MühendislikYöneticisi sözleşmesini başlatan yapıcı fonksiyon.
     * @param _idNumber Çalışanın benzersiz tanımlayıcısı.
     * @param _managerId Çalışanı denetleyen yöneticinin tanımlayıcısı.
     * @param _annualSalary Çalışanın yıllık maaşı.
     */
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
        Salaried(_idNumber, _managerId, _annualSalary) {}
}

/**
 * @title KalıtımGönderimi
 * @dev SatışTemsilcisi ve MühendislikYöneticisi örneklerini dağıtmak için sözleşme.
 */
contract InheritanceSubmission {
    address public salesPerson; // Dağıtılmış SatışTemsilcisi örneğinin adresi
    address public engineeringManager; // Dağıtılmış MühendislikYöneticisi örneğinin adresi

    /**
     * @dev KalıtımGönderimi sözleşmesini başlatan yapıcı fonksiyon.
     * @param _salesPerson Dağıtılmış SatışTemsilcisi örneğinin adresi.
     * @param _engineeringManager Dağıtılmış MühendislikYöneticisi örneğinin adresi.
     */
    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
