// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SmartTicketing is Ownable, ReentrancyGuard {

    uint public ticketCount;

    struct Ticket {
        uint id;
        string eventName;
        address owner;
        uint price;
        bool isUsed;
        bool isExpired;
        bool isSold;
        bool isDeleted; // tambahan untuk soft delete
    }

    mapping(uint => Ticket) public tickets;
    mapping(address => uint[]) public userTickets;

    event TicketCreated(uint id, string eventName, uint price);
    event TicketBought(uint id, address buyer);
    event TicketUsed(uint id);
    event TicketTransferred(uint id, address from, address to);
    event TicketDeleted(uint id);

    constructor() Ownable(msg.sender) {}

    //  CREATE
    function createTicket(string memory _eventName, uint _price) public onlyOwner {
        require(_price > 0, "Harga harus > 0");

        ticketCount++;

        tickets[ticketCount] = Ticket({
            id: ticketCount,
            eventName: _eventName,
            owner: owner(),
            price: _price,
            isUsed: false,
            isExpired: false,
            isSold: false,
            isDeleted: false
        });

        emit TicketCreated(ticketCount, _eventName, _price);
    }

    // BUY
    function buyTicket(uint _ticketId) public payable nonReentrant {
        Ticket storage t = tickets[_ticketId];

        require(_ticketId > 0 && _ticketId <= ticketCount, "Tiket tidak valid");
        require(!t.isDeleted, "Tiket dihapus");
        require(!t.isSold, "Sudah terjual");
        require(!t.isUsed, "Sudah digunakan");
        require(!t.isExpired, "Sudah expired");
        require(msg.value >= t.price, "Uang kurang");
        require(userTickets[msg.sender].length < 2, "Maks 2 tiket");

        t.owner = msg.sender;
        t.isSold = true;
        userTickets[msg.sender].push(_ticketId);

        // refund kelebihan
        if (msg.value > t.price) {
            (bool success, ) = payable(msg.sender).call{value: msg.value - t.price}("");
            require(success, "Refund gagal");
        }

        emit TicketBought(_ticketId, msg.sender);
    }

    // TRANSFER
    function transferTicket(uint _ticketId, address _to) public {
        Ticket storage t = tickets[_ticketId];

        require(msg.sender == t.owner, "Bukan owner");
        require(!t.isUsed, "Sudah digunakan");
        require(!t.isDeleted, "Tiket dihapus");
        require(_to != address(0), "Alamat invalid");

        _removeTicketFromUser(msg.sender, _ticketId);

        t.owner = _to;
        userTickets[_to].push(_ticketId);

        emit TicketTransferred(_ticketId, msg.sender, _to);
    }

    function _removeTicketFromUser(address _user, uint _ticketId) internal {
        uint[] storage list = userTickets[_user];

        for (uint i = 0; i < list.length; i++) {
            if (list[i] == _ticketId) {
                list[i] = list[list.length - 1];
                list.pop();
                break;
            }
        }
    }

    // VALIDATE
   function useTicket(uint _ticketId) public onlyOwner {
        Ticket storage t = tickets[_ticketId];

        require(!t.isDeleted, "Tiket dihapus");
        require(t.isSold, "Belum terjual");
        require(!t.isUsed, "Sudah digunakan");
        require(!t.isExpired, "Sudah expired");

        // 1. Tandai tiket sebagai sudah digunakan
        t.isUsed = true;

        // 2. TAMBAHKAN INI: Hapus ID tiket dari daftar aktif user
        // Ini akan mengurangi length array userTickets[t.owner], sehingga user bisa beli lagi
        _removeTicketFromUser(t.owner, _ticketId);

        emit TicketUsed(_ticketId);
    }

    //  EXPIRE
    function expireTicket(uint _ticketId) public onlyOwner {
        Ticket storage t = tickets[_ticketId];
        require(!t.isDeleted, "Tiket dihapus");

        t.isExpired = true;
    }

    //  DELETE (SOFT DELETE)
    function deleteTicket(uint _ticketId) public onlyOwner {
        Ticket storage t = tickets[_ticketId];

        require(!t.isSold, "Sudah terjual tidak bisa dihapus");
        require(!t.isDeleted, "Sudah dihapus");

        t.isDeleted = true;

        emit TicketDeleted(_ticketId);
    }

    //  READ
    function getTicket(uint _ticketId) public view returns (Ticket memory) {
        require(_ticketId > 0 && _ticketId <= ticketCount, "Tidak ditemukan");
        return tickets[_ticketId];
    }

    function getMyTickets() public view returns (uint[] memory) {
        return userTickets[msg.sender];
    }

    //  WITHDRAW
    function withdrawBalance() public onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "Saldo kosong");

        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdraw gagal");
    }
}