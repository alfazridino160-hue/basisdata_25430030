-- p05_latihan_e_kopma_25430030.sql
-- Latihan E Modul 5 (Kopma). JALANKAN SATU BAGIAN PER SATU KALI KIRIM, bukan sekaligus,
-- karena beberapa perintah memang harus ditolak dan perlu difoto galatnya.
-- Prasyarat: tabel dan data uji dari Tahap 1-2 sudah ada (petugas id 1, barang id 1).

USE kopma_030;

-- =========================================================
-- E1: CHECK agar stok_min_barang tidak negatif
-- =========================================================

-- 1a. Tambahkan constraint (harus berhasil)
ALTER TABLE barang
  ADD CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0);

-- 1b. Bukti ditolak (harus galat #4025 ... ck_barang_stok_min failed)
UPDATE barang SET stok_min_barang = -1 WHERE id_barang = 1;

-- =========================================================
-- E2: fk_penjualan_anggota dengan ON DELETE SET NULL
-- =========================================================

-- 2a. Siapkan data: satu anggota dan satu nota milik anggota itu
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota)
VALUES ('A-0003', '2301010003', 'Sari', 'Informatika', CURDATE());

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2610-0002', NOW(), 1,
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0003'), 8000);

-- 2b. SEBELUM perubahan: menghapus anggota harus ditolak (galat #1451)
DELETE FROM anggota WHERE no_anggota = 'A-0003';

-- 2c. Ubah aksi hapus pada kunci tamu
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;

ALTER TABLE penjualan
  ADD CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota) ON DELETE SET NULL;

-- 2d. SESUDAH perubahan: hapus anggota harus berhasil
DELETE FROM anggota WHERE no_anggota = 'A-0003';

-- 2e. Bukti: id_anggota pada nota menjadi NULL, notanya tetap ada
SELECT no_nota_penjualan, id_anggota
FROM penjualan
WHERE no_nota_penjualan = 'PJ-2610-0002';

-- 2f. (Opsional) bukti definisi kunci tamu
SHOW CREATE TABLE penjualan;
