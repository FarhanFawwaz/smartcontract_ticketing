🎟️ Smart Ticketing DApp
Decentralized Event Ticketing Platform with Smart Contracts

📌 Deskripsi Proyek
Smart Ticketing DApp adalah sistem manajemen tiket acara berbasis Blockchain Ethereum yang dirancang untuk mengatasi masalah pemalsuan tiket dan praktik calo (scalping). Dengan memanfaatkan Smart Contract, setiap transaksi bersifat transparan, aman, dan tidak dapat dimanipulasi (immutable).
Aplikasi ini mengintegrasikan logika bisnis di sisi backend (Blockchain) dengan antarmuka pengguna di sisi frontend (Web) secara real-time.
________________________________________

🚀 Fitur Utama
👨‍💼 Dashboard Admin (Privileged)
•	Event Creation: Membuat tiket baru dengan parameter nama acara dan harga (dalam ETH).
•	Ticket Validation: Melakukan verifikasi check-in pengunjung di lokasi acara.
•	Lifecycle Management: Mengatur status tiket menjadi expired atau melakukan soft delete untuk pembatalan tiket.
•	Finance Management: Menarik akumulasi dana hasil penjualan dari contract ke dompet pribadi admin.
👤 Portal Pengguna
•	Secure Purchase: Membeli tiket langsung dari contract dengan jaminan refund otomatis jika pembayaran berlebih.
•	Inventory Tracking: Melihat daftar koleksi tiket yang dimiliki secara real-time.
•	P2P Transfer: Mengirimkan tiket kepada pengguna lain secara aman melalui jaringan blockchain.
•	Status Verification: Mengecek detail dan validitas tiket berdasarkan ID unik.
________________________________________

🔐 Keamanan & Logika Sistem
Sistem ini mengimplementasikan standar keamanan industri untuk memastikan integritas data:
1.	Role-Based Access Control (RBAC): Menggunakan library Ownable dari OpenZeppelin. Fungsi krusial seperti pembuatan dan validasi tiket dilindungi oleh modifier onlyOwner.
2.	Reentrancy Protection: Menggunakan ReentrancyGuard untuk mencegah serangan reentrancy pada fungsi pemindahan dana dan aset.
3.	Anti-Scalper Logic: Batasan kepemilikan maksimal 2 tiket per wallet untuk mencegah monopoli tiket oleh pihak ketiga (calo).
4.	Dynamic Quota Allocation: Sistem secara otomatis membersihkan daftar kepemilikan aktif saat tiket telah digunakan (check-in), sehingga kuota pembelian pengguna kembali tersedia.
5.	Soft Delete Mechanism: Penghapusan tiket yang tetap menjaga integritas riwayat transaksi di blockchain tanpa merusak mapping data.
________________________________________

🧠 Teknologi yang Digunakan
Komponen	Teknologi
Smart Contract:	Solidity ^0.8.20
Security: Library	OpenZeppelin (Ownable, ReentrancyGuard)
Development: IDE	Remix IDE
Web Gateway:	MetaMask
Network:	Sepolia Ethereum Testnet
Frontend: Library	Ethers.js (v5.7.2)
Web Interface:	HTML5, CSS3 (Outfit Font), JavaScript (ES6)
________________________________________

⚙️ Arsitektur Integrasi
1. Tahap Deployment
•	Kontrak di-compile menggunakan compiler Solidity 0.8.20.
•	Deploy dilakukan pada jaringan Sepolia Testnet melalui provider Injected MetaMask.
2. Koneksi Frontend
•	Website terhubung ke Blockchain menggunakan library Ethers.js.
•	Interaksi memerlukan Contract Address dan ABI (Application Binary Interface) yang dihasilkan saat proses deployment.
________________________________________

💰 Alur Transaksi & Gas Fee
1.	State Change: Aksi seperti membeli, membuat, atau mentransfer tiket memerlukan biaya Gas Fee (dalam SepoliaETH) karena mengubah data di ledger blockchain.
2.	Value Transfer: Saat pembelian, ETH dikirim dari wallet User ke saldo Smart Contract.
3.	Withdrawal: Admin dapat menarik total saldo kontrak menggunakan metode .call yang lebih aman terhadap limit gas.
________________________________________

👨‍🎓 Tim Pengembang
Farhan Muamar Fawwaz
NIM: 103032300076
S1 Teknologi Informasi - Universitas Telkom

