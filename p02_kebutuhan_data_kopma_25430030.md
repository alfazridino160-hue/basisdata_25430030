# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera

## 1. Latar belakang dan aktivitas organisasi

kopma menjual berbagai alat tulis, makanan ringan, dan minuman di lungkungan kampus. pembelinya merupakan anggota ataupun orang umum. pekerja kasir yang pekerjaanya mencatat penjualan dan membuat nota, petugas gudang, dan ketua koperasi. pada saat wawancara:ketua: harga barang sering naik, jadi kami bingung saat melihat nota lama, petugas gudang: kadang di buku catatan stoknya malah minus ,kasir: anggota sering lupa membawa kartu, jadi kami mencarinya lewat NIM.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang | Ada pemasok baru atau data pemasok berubah |
| PB-07 | Mengelola status keanggotaan | Kasir | Anggota diaktifkan atau dinonaktifkan |
| PB-08 | Menukar poin loyalitas | Kasir | Anggota ingin menukar 50 poin |

## 3. Dokumen sumber yang dianalisis

sumber dokumen pj-2609-0142
| Isian nota | Disimpan / dihitung |
|---|---|
| Nomor nota, tanggal-jam | Disimpan |
| Kasir, anggota | Disimpan (relasi) |
| Barang, qty, harga saat transaksi | Disimpan |
| Subtotal, jumlah, diskon, total | Dihitung |
| Bayar tunai | Disimpan |
| Kembali | Dihitung |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Anggota aktif memperoleh 1 poin untuk setiap kelipatan Rp10.000 total belanja, dibulatkan ke bawah. |
| AB-08 | 50 poin dapat ditukar potongan Rp5.000, dan saldo poin tidak boleh negatif. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Saldo poin tiap anggota dan jumlah poin yang ditukar per bulan | Anggota, penjualan, penukaran poin |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian | Penukaran poin |
|---|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | | |
| PB-02 Catat penjualan | R, U | R, U | C | C | | | |
| PB-03 Pesan ke pemasok | | R | | | R | C | |
| PB-04 Terima barang | | U | | | R | U | |
| PB-05 Laporan bulanan | R | R | R | R | | R | R |
| PB-06 Kelola data pemasok | | | | | C, U | | |
| PB-07 Kelola status anggota | U | | | | | | |
| PB-08 Tukar poin | R, U | | R | | | | C |

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| status_aktif | Status keanggotaan | aktif | Hanya aktif/nonaktif | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 (rupiah) | Kasir |
| qty_detail_penjualan | Jumlah barang dalam satu baris nota | 3 | Bilangan bulat > 0 | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 (AB-03) | Petugas gudang |
| batas_minimum_stok | Batas stok untuk memesan ulang | 10 | Bilangan bulat ≥ 0 (AB-06) | Petugas gudang |
| no_faktur_pembelian | Nomor faktur dari pemasok | FK-2609-0031 | Unik per faktur | Petugas gudang |
| saldo_poin_anggota | Jumlah poin yang dimiliki anggota | 12 | Bilangan bulat ≥ 0 (AB-08) | Ketua |
| poin_diperoleh_penjualan | Poin dari satu nota | 2 | Bilangan bulat ≥ 0 (AB-07) | Kasir |
| poin_ditukar | Poin yang dipakai dalam satu penukaran | 50 | Kelipatan 50 (AB-08) | Kasir |

## 9. Kebutuhan non-fungsional data

data nota yang tercatat sekitar 150 nota per hari, data transaksi minimal disimpan 5 tahun, dan untuk menajaga privasi nomor HP anggota hanya ketua saja yang boleh lihat. 

### Pernyataan kebutuhan yang diperbaiki

- (a) Nomor HP dan NIM anggota hanya dapat dilihat oleh ketua; kasir hanya dapat melihat nama dan nomor anggota.
- (b) pencarian barang menampilkan hasil dalam beberapa detik untuk memunculkan beberapa barang
- (c) seslisih laporan stok tidak boleh minus

## 10. Isu kualitas data yang diantisipasi
salah satu isu nya adalah, stok minus dengan penjualan ditolak bila qty melebihi stok tersedia, harga di nota lama berubah Harga jual pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.