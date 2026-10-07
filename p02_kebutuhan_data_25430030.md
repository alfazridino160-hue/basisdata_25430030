# Dokumen Kebutuhan Data - Perpustakaan Cendekia AFR

## 1. Latar belakang dan aktivitas organisasi

Perpustakaan cendikia AFR melayani orang yang ingin baca buku gratis sepuasnya dari kalangan mahasiswa maupun dosen. Jika ingin minjam buku harus menjadi anggota dulu ya. Koleksinya sangat banyak ada yang berupa buku cetak dan jurnal pun ada. Setiap anggota maksimal dapat meminjam 6 buku selama 7 hari. Jika buku dikembalikan lebih dari batas waktu, setiap anggota akan dikenai denda sebesar rp4.000 per hari untuk setiap buku. Petugas mencatat pinjaman dan pengembalian dengan rata rata kurang lebih 60 transaksi per hari. Karena pencatatan masih manual menimbulkan beberapa masalah: petugas sulit memastikan siapa yang sedang meminjam suatu buku, dan sering salah dalam melakukan penghitungn denda.


## 2. Aktor dan proses bisnis| Kode | Proses bisnis | Aktor | Pemicu |
| kode | proses bisnis | Aktor | pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | kasir | Mahasiswa atau dosen ingin menjadi anggota |
| PB-02 | Mencatat peminjaman buku | kasir | Anggota membawa buku ke meja layanan |
| PB-03 | Mencatat pengembalian dan menghitung denda | kasir | Anggota mengembalikan buku |
| PB-04 | Mengelola koleksi buku | petugaa gudang | Ada buku baru atau buku rusak/hilang |
| PB-05 | Menyusun laporan bulanan | ketua | Awal bulan |

## 3. Dokumen sumber yang dianalisis

 `PJ-2610-0007`tanggal 07-10-2026, dibuat oleh petugas kasir.

| Isian slip | Contoh | Disimpan / dihitung |
|---|---|---|
| Nomor slip, tanggal pinjam | PJ-2610-0007, 07-10-2026 | Disimpan |
| Anggota | 1010, Dono | Disimpan (relasi) |
| Petugas | Yanto | Disimpan (relasi) |
| Judul buku, nomor eksemplar | bangun pagi | Disimpan |
| Tanggal harus kembali | 14-10-2026 | Disimpan |
| Jumlah buku dalam slip | 4 | Dihitung |

Tanggal harus kembali disimpan pada slip karena masa pinjam bisa berubah di kemudian hari. Dengan disimpan, slip lama tetap menunjukkan tanggal kembali yang berlaku saat peminjaman dan denda dihitung dengan benar.

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, nama, jenis anggota (mahasiswa/dosen), nomor HP, status aktif | Formulir anggota |
| Petugas | kode petugas, nama | Wawancara |
| Judul buku | kode judul, judul, pengarang, penerbit, kategori | Katalog |
| Eksemplar | nomor eksemplar, judul buku, kondisi, status (tersedia/dipinjam) | Katalog, slip |
| Peminjaman | nomor slip, tanggal pinjam, anggota, petugas | Slip peminjaman |
| Detail peminjaman | nomor slip, eksemplar, tanggal harus kembali, tanggal kembali | Slip peminjaman |
| Denda | nomor kuitansi, detail peminjaman, jumlah hari terlambat, nominal denda, status bayar | Kuitansi denda |

## 5. Aturan bisnis

| Kode | Aturan bisnis | Terkait |
|---|---|---|
| AB-01 | Setiap slip peminjaman memiliki nomor unik dan memuat minimal satu buku. | PB-02 |
| AB-02 | Satu slip memuat paling banyak 6 buku (batas P). | PB-02 |
| AB-03 | Masa pinjam 7 hari sejak tanggal pinjam; tanggal harus kembali disimpan pada slip. | PB-02 |
| AB-04 | Hanya anggota berstatus aktif yang boleh meminjam. | PB-01, PB-02 |
| AB-05 | Eksemplar berstatus dipinjam tidak boleh dipinjamkan lagi sebelum dikembalikan. | PB-02, PB-03 |
| AB-06 | Denda Rp4.000 per hari untuk setiap buku yang dikembalikan lewat dari tanggal harus kembali (batas P). | PB-03 |
| AB-07 | Nomor anggota unik; setiap anggota memiliki jenis (mahasiswa atau dosen). | PB-01 |
| AB-08 | Satu judul buku dapat memiliki banyak eksemplar, dan setiap eksemplar memiliki nomor unik. | PB-04 |
| AB-09 | Batas perpanjangan masa pinjam buku maksimal 2 hari | PB-02 |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Jumlah transaksi peminjaman per hari dan per bulan | Peminjaman |
| KI-02 | Lima judul buku paling sering dipinjam per bulan | Detail peminjaman, eksemplar, judul buku |
| KI-03 | Daftar buku yang sedang dipinjam dan sudah lewat batas kembali | Detail peminjaman, eksemplar, anggota |
| KI-04 | Total denda yang terkumpul per bulan | Denda |
| KI-05 | Sepuluh anggota paling aktif meminjam per bulan | Peminjaman, anggota |

## 7. Matriks CRUD

| Proses | Anggota | Petugas | Judul buku | Eksemplar | Peminjaman | Detail | Denda |
|---|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | | |
| PB-02 Catat peminjaman | R | R | R | R, U | C | C | |
| PB-03 Catat pengembalian | | R | | U | R | U | C |
| PB-04 Kelola koleksi | | | C, U | C, U | | | |
| PB-05 Laporan bulanan | R | | R | R | R | R | R |
| PB-06 Kelola data petugas | | C, U | | | | | |

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota perpustakaan | 1010 | Unik (AB-07) | Petugas |
| nama_anggota | Nama lengkap anggota | Dono | Wajib diisi | Petugas |
| jenis_anggota | Mahasiswa atau dosen | mahasiswa | Hanya mahasiswa/dosen (AB-07) | Petugas |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Kepala perpustakaan |
| status_aktif | Status keanggotaan | aktif | Hanya aktif/nonaktif (AB-04) | Petugas |
| kode_petugas | Kode petugas layanan | P-01 | Unik | Kepala perpustakaan |
| nama_petugas | Nama petugas | Yanto | Wajib diisi | Kepala perpustakaan |
| kode_judul | Kode judul buku | JD-0101 | Unik | Petugas |
| judul_buku | Judul buku | Bangun Pagi | Wajib diisi | Petugas |
| pengarang | Nama pengarang | Siti | Wajib diisi | Petugas |
| penerbit | Nama penerbit | Terbitiria | Boleh kosong | Petugas |
| kategori_buku | Kategori koleksi | fiksi | Salah satu dari daftar kategori | Petugas |
| no_eksemplar | Nomor eksemplar fisik | JD-0101-02 | Unik per eksemplar (AB-08) | Petugas |
| kondisi_eksemplar | Kondisi fisik buku | baik | baik/rusak/hilang | Petugas |
| status_eksemplar | Ketersediaan | dipinjam | tersedia/dipinjam (AB-05) | Petugas |
| no_slip_peminjaman | Nomor slip peminjaman | PJ-2610-0007 | Unik per slip (AB-01) | Petugas |
| tanggal_pinjam | Tanggal buku dipinjam | 2026-10-07 | Tanggal valid | Petugas |
| tanggal_harus_kembali | Batas pengembalian | 2026-10-14 | Tanggal pinjam + 7 hari (AB-03) | Petugas |
| tanggal_kembali | Tanggal buku benar-benar kembali | 2026-10-16 | Kosong sebelum dikembalikan | Petugas |
| jumlah_hari_terlambat | Selisih hari lewat batas | 2 | Bilangan bulat ≥ 0 | Petugas |
| nominal_denda | Denda satu buku | 8000 | Hari terlambat × 4000 (AB-06) | Petugas |
| status_bayar_denda | Status pembayaran denda | lunas | lunas/belum | Petugas |

## 9. Kebutuhan non-fungsional data

Sekitar 60 transaksi peminjaman terjadi setiap hari, data peminjaman minimal di simpan selama 5 tahun, terkait privasi nomor hp dan lain lain hsnys bisa di buka oleh ketua. pencarian nomor anggota menampilkan hasil dalam 2 detik

## 10. Isu kualitas data yang diantisipasi

- Satu eksemplar tercatat dipinjam dua orang, dicegah AB-05.
- Denda salah hitung karena tanggal dicek manual, dicegah AB-06 dan AB-03.
- Anggota nonaktif meminjam, dicegah AB-04.
