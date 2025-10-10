// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// OpenZeppelin sözleşmelerini ERC20 ve EnumerableSet işlevsellikleri için içe aktarma
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

// ERC20 token kullanarak ağırlıklı oylama için sözleşme
contract WeightedVoting is ERC20 {
    string private salt = "value"; // A private string variable
    using EnumerableSet for EnumerableSet.AddressSet; // Importing EnumerableSet for address set functionality

    // Özel hatalar
    error TokensClaimed(); // Tekrar token talep etmeye çalışma hatası
    error AllTokensClaimed(); // Tüm tokenlar zaten talep edilmişken token talep etmeye çalışma hatası
    error NoTokensHeld(); // Token sahibi olmadan bir işlem yapmaya çalışma hatası
    error QuorumTooHigh(); // Nisabı toplam arzın üzerinde ayarlama hatası
    error AlreadyVoted(); // Birden fazla oy verme hatası
    error VotingClosed(); // Kapalı bir konuda oy kullanmaya çalışma hatası

    // Bir konuyu temsil eden yapı
    struct Issue {
        EnumerableSet.AddressSet voters; // // Oy verenlerin kümesi
        string issueDesc; // Konunun açıklaması
        uint256 quorum; // Konunun kapanması için gereken nisap
        uint256 totalVotes; // Kullanılan toplam oy sayısı
        uint256 votesFor; // Lehte kullanılan toplam oy sayısı
        uint256 votesAgainst; // Aleyhte kullanılan toplam oy sayısı
        uint256 votesAbstain; // Çekimser kullanılan toplam oy sayısı
        bool passed; // Konunun geçip geçmediğini gösteren bayrak
        bool closed; // Konunun kapalı olup olmadığını gösteren bayrak
    }

    // Serileştirilmiş bir konuyu temsil eden yapı
    struct SerializedIssue {
        address[] voters; // Oy verenlerin dizisi
        string issueDesc; // Konunun açıklaması
        uint256 quorum; // Konunun kapanması için gereken nisap
        uint256 totalVotes; // Kullanılan toplam oy sayısı
        uint256 votesFor; // Lehte kullanılan toplam oy sayısı
        uint256 votesAgainst; // Aleyhte kullanılan toplam oy sayısı
        uint256 votesAbstain; // Çekimser kullanılan toplam oy sayısı
        bool passed; // Konunun geçip geçmediğini gösteren bayrak
        bool closed; // Konunun kapalı olup olmadığını gösteren bayrak
    }

    // Farklı oy seçeneklerini temsil eden enum
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    // Tüm konuları saklamak için dizi
    Issue[] internal issues;

    // Bir adresin tokenları talep edip etmediğini izlemek için eşleme
    mapping(address => bool) public tokensClaimed;

    uint256 public maxSupply = 1000000; // Tokenların maksimum arzı
    uint256 public claimAmount = 100; // Talep edilen Token

    string saltt = "any"; // Başka bir string değişkeni

    // ERC20 tokenini bir isim ve sembolle başlatmak için constructor
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        issues.push(); 
    }

    // Token talep etme fonksiyonu
    function claim() public {
        // Tüm tokenlerin talep edilip edilmediğini kontrol et
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }
        // Kullanıcının zaten token talep edip etmediğini kontrol et
        if (tokensClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        // Token bas
        _mint(msg.sender, claimAmount);
        tokensClaimed[msg.sender] = true; // Mark tokens as claimed
    }

    // Yeni bir oylama konusu oluşturma fonksiyonu
    function createIssue(string calldata _issueDesc, uint256 _quorum)
        external
        returns (uint256)
    {
        // Kullanıcının herhangi bir token tutup tutmadığını kontrol et
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        // Belirtilen nisabın toplam arzı aşıp aşmadığını kontrol et
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh();
        }
        // Yeni bir konu oluştur ve onun indeksini döndür
        Issue storage _issue = issues.push();
        _issue.issueDesc = _issueDesc;
        _issue.quorum = _quorum;
        return issues.length - 1;
    }

    // Bir oylama konusunun detaylarını alma fonksiyonu
    function getIssue(uint256 _issueId)
        external
        view
        returns (SerializedIssue memory)
    {
        Issue storage _issue = issues[_issueId];
        return
            SerializedIssue({
                voters: _issue.voters.values(),
                issueDesc: _issue.issueDesc,
                quorum: _issue.quorum,
                totalVotes: _issue.totalVotes,
                votesFor: _issue.votesFor,
                votesAgainst: _issue.votesAgainst,
                votesAbstain: _issue.votesAbstain,
                passed: _issue.passed,
                closed: _issue.closed
            });
    }

    // Bir oylama konusunda oy kullanma fonksiyonu
    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage _issue = issues[_issueId];

        // Konunun kapalı olup olmadığını kontrol et
        if (_issue.closed) {
            revert VotingClosed();
        }
        // Kullanıcının zaten oy kullanıp kullanmadığını kontrol et
        if (_issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 nTokens = balanceOf(msg.sender);
        // CKullanıcının herhangi bir token tutup tutmadığını kontrol et
        if (nTokens == 0) {
            revert NoTokensHeld();
        }

        // Oy seçeneğine göre oy sayılarını güncelle
        if (_vote == Vote.AGAINST) {
            _issue.votesAgainst += nTokens;
        } else if (_vote == Vote.FOR) {
            _issue.votesFor += nTokens;
        } else {
            _issue.votesAbstain += nTokens;
        }

        // Kullanıcının oy kullananlar listesine ekle ve toplam oy sayısını güncelle
        _issue.voters.add(msg.sender);
        _issue.totalVotes += nTokens;

        // Nisap sağlanmışsa konuyu kapat ve geçip geçmediğini belirle
        if (_issue.totalVotes >= _issue.quorum) {
            _issue.closed = true;
            if (_issue.votesFor > _issue.votesAgainst) {
                _issue.passed = true;
            }
        }
    }
}
