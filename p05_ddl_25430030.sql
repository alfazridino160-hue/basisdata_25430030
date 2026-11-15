-- p05_ddl_25430030.sql
-- DDL proyek Perpustakaan Cendekia AFR (Milestone Modul 5), MariaDB 10.4.
-- Dapat dijalankan ulang dari basis data kosong.
-- Penamaan constraint: pk_, fk_, uq_, ck_ + nama tabel.
--
-- DRAF: periksa setiap baris terhadap dokumen kebutuhan data dan ERD milikmu.
--   [PERIKSA ...] = cocokkan dengan dokumenmu (kode AB, panjang kolom, nilai ENUM).
--   [PUTUSKAN ...] = keputusan yang harus kamu ambil sendiri.
-- Komentar AB-xx harus merujuk dokumen kebutuhan data MILIKMU. Hapus catatan ini
-- setelah semuanya kamu periksa.

USE perpus_030;

-- 1. Hapus tabel dari anak ke induk (kebalikan urutan pembuatan)
DROP TABLE IF EXISTS denda;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS judul_buku;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- 2. Tabel induk (tanpa kunci tamu)

CREATE TABLE petugas (
  id_petugas   SMALLINT     NOT NULL AUTO_INCREMENT,
  kode_petugas CHAR(4)      NOT NULL,                 -- [PERIKSA panjang sesuai format kodemu]
  nama_petugas VARCHAR(100) NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota    INT          NOT NULL AUTO_INCREMENT,
  no_anggota    VARCHAR(10)  NOT NULL,                -- [PERIKSA panjang sesuai format nomor anggotamu]
  nama_anggota  VARCHAR(100) NOT NULL,
  jenis_anggota ENUM('mahasiswa','dosen') NOT NULL,   -- AB-07 [PERIKSA kode AB]
  no_hp_anggota VARCHAR(15)  NULL,                    -- data pribadi, boleh kosong
  status_aktif  ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',  -- AB-04 [PERIKSA kode AB]
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no UNIQUE (no_anggota)        -- AB-07 [PERIKSA kode AB]
) ENGINE=InnoDB;

CREATE TABLE judul_buku (
  id_judul      INT          NOT NULL AUTO_INCREMENT,
  kode_judul    VARCHAR(10)  NOT NULL,
  judul_buku    VARCHAR(200) NOT NULL,
  pengarang     VARCHAR(100) NOT NULL,
  penerbit      VARCHAR(100) NULL,
  kategori_buku VARCHAR(30)  NOT NULL,                -- [PUTUSKAN: ENUM berisi kategorimu atau VARCHAR]
  CONSTRAINT pk_judul_buku PRIMARY KEY (id_judul),
  CONSTRAINT uq_judul_buku_kode UNIQUE (kode_judul)
) ENGINE=InnoDB;

-- 3. Tabel yang memakai kunci tamu

CREATE TABLE eksemplar (
  id_eksemplar      INT         NOT NULL AUTO_INCREMENT,
  id_judul          INT         NOT NULL,
  no_eksemplar      VARCHAR(15) NOT NULL,
  kondisi_eksemplar ENUM('baik','rusak','hilang') NOT NULL DEFAULT 'baik',
  status_eksemplar  ENUM('tersedia','dipinjam')   NOT NULL DEFAULT 'tersedia',  -- AB-05 [PERIKSA kode AB]
  CONSTRAINT pk_eksemplar PRIMARY KEY (id_eksemplar),
  CONSTRAINT uq_eksemplar_no UNIQUE (no_eksemplar),   -- AB-08 [PERIKSA kode AB]
  CONSTRAINT fk_eksemplar_judul FOREIGN KEY (id_judul)
    REFERENCES judul_buku (id_judul)                  -- satu judul banyak eksemplar (AB-08)
) ENGINE=InnoDB;

CREATE TABLE peminjaman (
  id_peminjaman         INT      NOT NULL AUTO_INCREMENT,
  no_slip_peminjaman    CHAR(12) NOT NULL,            -- format PJ-YYMM-nnnn [PERIKSA]
  tanggal_pinjam        DATE     NOT NULL,
  tanggal_harus_kembali DATE     NOT NULL,            -- disimpan pada slip (AB-03) [PERIKSA sesuai keputusan normalisasi]
  id_anggota            INT      NOT NULL,
  id_petugas            SMALLINT NOT NULL,
  CONSTRAINT pk_peminjaman PRIMARY KEY (id_peminjaman),
  CONSTRAINT uq_peminjaman_slip UNIQUE (no_slip_peminjaman),          -- AB-01
  CONSTRAINT ck_peminjaman_tanggal
    CHECK (tanggal_harus_kembali >= tanggal_pinjam),                  -- AB-03
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota),
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  id_peminjaman  INT  NOT NULL,
  id_eksemplar   INT  NOT NULL,
  tanggal_kembali DATE NULL,                          -- NULL sampai buku dikembalikan
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE CASCADE,         -- rincian ikut terhapus bila slip dibatalkan
  CONSTRAINT fk_detail_eksemplar FOREIGN KEY (id_eksemplar)
    REFERENCES eksemplar (id_eksemplar)               -- eksemplar tidak boleh dihapus bila sudah pernah dipinjam
) ENGINE=InnoDB;

CREATE TABLE denda (
  id_denda           INT         NOT NULL AUTO_INCREMENT,
  id_peminjaman      INT         NOT NULL,
  id_eksemplar       INT         NOT NULL,
  no_kuitansi_denda  VARCHAR(15) NOT NULL,
  status_bayar_denda ENUM('belum','lunas') NOT NULL DEFAULT 'belum',
  -- [PUTUSKAN sesuai keputusan nilai turunan di normalisasi:]
  -- bila nominal_denda DISIMPAN, tambahkan baris berikut dan constraint ck_denda_nominal:
  --   nominal_denda DECIMAL(12,2) NOT NULL,
  --   CONSTRAINT ck_denda_nominal CHECK (nominal_denda >= 0),
  -- bila DIHITUNG (hari terlambat x Rp4.000, AB-06), kolom ini tidak dibuat.
  CONSTRAINT pk_denda PRIMARY KEY (id_denda),
  CONSTRAINT uq_denda_kuitansi UNIQUE (no_kuitansi_denda),
  CONSTRAINT uq_denda_detail UNIQUE (id_peminjaman, id_eksemplar),    -- satu detail paling banyak satu denda (0..1)
  CONSTRAINT fk_denda_detail FOREIGN KEY (id_peminjaman, id_eksemplar)
    REFERENCES detail_peminjaman (id_peminjaman, id_eksemplar)
) ENGINE=InnoDB;

-- 4. Aturan bisnis yang TIDAK dapat dijaga constraint (diselesaikan di Modul 14)
--   AB-02: batas 6 buku per slip (P + 2). Menyangkut jumlah baris detail per peminjaman,
--          bukan satu baris, sehingga CHECK tidak dapat menjaganya.
--   AB-01: slip minimal berisi satu buku (nota dibuat lebih dulu, baru detailnya).
--   AB-05: eksemplar berstatus dipinjam tidak boleh dipinjamkan lagi (butuh pemeriksaan
--          dan pembaruan status dalam satu transaksi).
--   AB-06: denda Rp4.000 per hari (P = 4) adalah aturan perhitungan, bukan penolakan data.

-- 5. Pemeriksaan hasil
SHOW TABLES;
SHOW CREATE TABLE peminjaman;
SHOW CREATE TABLE denda;
