📌 PROJECT SUMMARY
Offline-First POS System untuk Bisnis Minuman Matcha
1. Latar Belakang

Klien menjalankan bisnis minuman matcha yang beroperasi di lapangan menggunakan HP dan tablet, dengan kondisi koneksi internet yang tidak selalu stabil. Oleh karena itu, dibutuhkan sistem Point of Sales (POS) yang cepat, stabil, dan tetap berfungsi penuh tanpa koneksi internet, serta siap dikembangkan ke mode online di tahap berikutnya.

2. Tujuan Proyek

Membangun aplikasi POS berbasis Flutter yang:

100% berfungsi secara offline

Optimal untuk mobile & tablet

Mendukung transaksi cepat, manajemen menu dinamis, dan kontrol stok bahan baku

Menggunakan arsitektur yang siap dikembangkan ke mode online/sinkronisasi cloud

3. Ruang Lingkup Versi 1 (Fokus Offline)
A. POS Kasir

Input transaksi cepat

Varian produk (size, sugar, ice, topping)

Multi metode pembayaran

Diskon

Riwayat transaksi

Cetak struk Bluetooth / simpan struk digital

B. Manajemen Produk

Kategori & menu dinamis

Harga fleksibel

Aktif/nonaktif produk

Manajemen varian

C. Inventory & Resep

Master bahan baku

Resep per produk (BOM)

Stok masuk & keluar

Auto-deduct stok dari transaksi

Stock opname

Riwayat pergerakan stok

D. Laporan Lokal

Penjualan harian & periodik

Rekap metode pembayaran

Produk terlaris

Pemakaian bahan

Estimasi laba kotor

Export laporan (PDF/Excel)

4. Arsitektur Teknis

Frontend App:

Flutter (Android tablet & mobile)

Mobile-first & tablet-optimized UI

State Management:

Riverpod
Digunakan untuk mengelola:

State transaksi (cart & order)

Produk & stok

User & role

Laporan lokal

Service & repository injection

Local Database:

SQLite (direkomendasikan via Drift)
Digunakan untuk menyimpan seluruh data offline:

Produk, bahan, resep

Stok & pergerakan stok

Order & payment

Audit log

Design Principle:

Offline-first

Repository pattern

UUID-based entity

Transaction & audit logging

Struktur siap sinkronisasi online di fase lanjutan

5. Nilai Tambah Sistem

Tetap bisa transaksi walaupun internet mati

Cocok untuk operasional lapangan

Stok berbasis bahan baku (bukan hanya produk)

Performa cepat untuk kasir

Arsitektur profesional dan scalable

Siap dikembangkan ke dashboard online & multi-outlet

6. Roadmap Singkat

Phase 1: POS offline core (order, payment, produk)
Phase 2: Inventory & resep + laporan lokal
Phase 3: Hardening, testing lapangan, export & backup
Phase 4 (next): Backend, sinkronisasi online, dashboard owner

7. Ringkasan Teknologi

Flutter

Riverpod (state management)

Drift (SQLite local database)

Bluetooth printing

UUID + audit log

Clean & modular architecture