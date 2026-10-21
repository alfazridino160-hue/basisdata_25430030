# Normalisasi Kopma

## 1. Anomali pada spreadsheet lama

Spreadsheet lama Kopma menyimpan satu baris untuk setiap barang di setiap nota, dengan nama anggota, petugas, dan barang ikut tertulis di setiap baris.

| Anomali | Artinya | Contoh di Kopma |
|---|---|---|
| Ubah | Satu fakta tertulis di banyak baris dan bisa tidak sama | ada pena di baris satu dan dua  |
| Sisip | Fakta tidak bisa dicatat sebelum fakta lain ada | tidak mencatat jumlah pena karena tidak ada baris pena |
| Hapus | Menghapus satu fakta ikut menghilangkan fakta lain | hanya ingin menghapus baris pertama pada nota ehtapi malah kehapus semua |

ketiga anomali tersebut memerlukan normalisasi 

## 2. UNF dan 1NF

**UNF** (belum dinormalisasi): satu nota disimpan dalam satu baris, dengan grup barang berulang di dalam kurung `{ }`.

```text
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

**1NF**: grup berulang dihilangkan, yaitu satu baris untuk setiap barang di setiap nota. Kunci primer menjadi gabungan `(no_nota_penjualan, kode_barang)`.

```text
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan)
```

Contoh dari nota `PJ-2609-0142` (3 barang menjadi 3 baris). Kolom lain (tanggal, petugas, anggota, jumlah, diskon, total) ikut berulang di tiap baris.

| no_nota_penjualan | kode_barang | nama_barang | qty_detail_penjualan | harga_satuan_detail_penjualan |
|---|---|---|---|---|
| PJ-2609-0142 | PG-05 | Pulpen Gel 0.5 | 3 | 4000 |
| PJ-2609-0142 | BT-58 | Buku Tulis 58 | 2 | 6500 |
| PJ-2609-0142 | AM-60 | Air Mineral 600 | 1 | 4000 |

Pemeriksaan 1NF: [TULIS jawaban atas "adakah sel berisi daftar atau kolom barang1, barang2?" pada NOTA_1NF.]

## 3. Dependensi fungsional

Dependensi fungsional (FD) diturunkan dari **aturan bisnis**, bukan dari isi contoh data. Notasi `A -> B` berarti setiap nilai A menentukan tepat satu nilai B.

| FD | Dependensi | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota | AB-01 (satu nota, satu tanggal, satu petugas) |
| FD2 | kode_petugas -> nama_petugas | satu kode petugas, satu nama |
| FD3 | no_anggota -> nama_anggota | AB-05 (nomor anggota unik) |
| FD4 | kode_barang -> nama_barang | satu kode barang, satu nama |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 (harga disimpan per baris nota) |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | nilai turunan |

Dependensi yang **sengaja tidak ditulis**: `kode_barang -> harga_satuan_detail_penjualan`, karena AB-04 menyatakan harga pada nota bisa berbeda dari harga barang saat ini.

Kode AB di atas mengikuti penomoran dokumen Kopma-mu. Sesuaikan jika berbeda.

harga satuan di tempatkan di kunci gabungan karena harga bisa saja berbeda beda pada satu barang yan sama pada nota yang berbeda.

## 4. 2NF dan 3NF

### 4.1 Menuju 2NF

2NF melarang atribut yang bergantung pada **sebagian** kunci gabungan. Kunci NOTA_1NF adalah `(no_nota_penjualan, kode_barang)`.

| FD | Bergantung pada | Sebagian kunci? | Tindakan |
|---|---|---|---|
| FD1 | no_nota_penjualan saja | ya | pisahkan menjadi relasi PENJUALAN |
| FD4 | kode_barang saja | ya | pisahkan menjadi relasi BARANG |
| FD5 | seluruh kunci gabungan | tidak | tetap di DETAIL_PENJUALAN |

```text
PENJUALAN_2NF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
               no_anggota, nama_anggota, jumlah_penjualan, diskon_penjualan,
               total_penjualan)
DETAIL_2NF    (no_nota_penjualan, kode_barang, qty_detail_penjualan,
               harga_satuan_detail_penjualan, subtotal_detail_penjualan)
BARANG_2NF    (kode_barang, nama_barang, kategori_barang, harga_jual_barang,
               stok_barang, stok_min_barang)
```

### 4.2 Menuju 3NF

3NF melarang rantai `A -> B -> C` di dalam satu tabel. Pada PENJUALAN_2NF ada dua rantai:

- `no_nota_penjualan -> kode_petugas -> nama_petugas`
- `no_nota_penjualan -> no_anggota -> nama_anggota`

Maka PETUGAS dan ANGGOTA dipisah menjadi relasi sendiri.

### 4.3 Ringkasan tahapan UNF sampai 3NF

| Tahap | Relasi | Masalah yang dihilangkan |
|---|---|---|
| UNF | NOTA_UNF | (belum dinormalisasi) grup barang berulang dalam satu baris |
| 1NF | NOTA_1NF | grup berulang; kunci menjadi gabungan |
| 2NF | PENJUALAN, DETAIL_PENJUALAN, BARANG | ketergantungan pada sebagian kunci (FD1, FD4) |
| 3NF | PENJUALAN, DETAIL_PENJUALAN, BARANG, PETUGAS, ANGGOTA | rantai FD1-FD2 dan FD1-FD3 |

## 5. Nilai turunan

Nilai turunan adalah nilai yang bisa dihitung dari atribut lain.

| Nilai turunan | Dihitung dari | Keputusan |
|---|---|---|---|
| subtotal_detail_penjualan | qty x harga satuan | tidak disimpan |
| jumlah_penjualan | jumlah semua subtotal dalam satu nota | tidak disimpan |
| diskon_penjualan | 5% x jumlah, jika anggota berstatus aktif | tidak disimpan |
| total_penjualan | jumlah dikurangi diskon | tidak disimpan |

Hasil 3NF Kopma (`*` = kunci tamu, kunci primer dicetak tebal):

```text
PENJUALAN         (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
DETAIL_PENJUALAN  (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG            (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS           (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA           (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
```

## 6. Pemeriksaan BCNF dan skema akhir

BCNF mensyaratkan **setiap penentu adalah kunci kandidat**. Pemeriksaan untuk tiap tabel:

| Tabel | Penentu (sisi kiri FD) | Kunci kandidat? | Hasil BCNF |
|---|---|---|---|
| PETUGAS | kode_petugas | ya | memenuhi |
| ANGGOTA | no_anggota, nim_anggota | ya, keduanya unik | memenuhi |
| BARANG | kode_barang | ya | memenuhi |
| PENJUALAN | no_nota_penjualan | ya | memenuhi |
| DETAIL_PENJUALAN | (no_nota_penjualan, kode_barang) | ya | memenuhi |



### Skema kanonik Kopma

Perbedaan utama dengan hasil normalisasi di atas: kunci primer memakai **kunci pengganti** `id_*`, sedangkan kode alami seperti `no_nota_penjualan` menjadi kunci unik.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

Catatan: kunci pengganti tidak menghapus dependensi fungsional. Normalisasi tetap diperiksa dengan kunci alami, misalnya `nim_anggota` pada anggota.

informasi pemasok di simpan pada nota pembelian dan detail_pembelian yang terhubung ke tabel pemasok.

## 7. Latihan E

### 7.1 Beberapa nomor telepon untuk setiap pemasok

```text
Sebelum (melanggar 1NF):
PEMASOK (id_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok)
  -> telepon_pemasok berisi lebih dari satu nomor dalam satu sel

Sesudah:
PEMASOK         (id_pemasok, nama_pemasok, alamat_pemasok)
TELEPON_PEMASOK ([TULIS kolom dan kuncinya])
```

[TULIS 2-3 kalimat: aturan normal form yang dilanggar, alasan nomor dipindah ke tabel sendiri, dan alasan pilihan kuncimu.]

### 7.2 Contoh pelanggaran 3NF dan anomali ubah

Rantai yang melanggar 3NF: (no_nota_penjualan, tgl_penjualan, no_anggota, nama_anggota)

Contoh data:

```text
penjualan_buruk (no_nota_penjualan, tgl_penjualan, no_anggota, nama_anggota)


PJ-0001 | 2026-09-24 | K03 | Rina
PJ-0002 | 2026-09-24 | K03 | Rina
PJ-0003 | 2026-09-25 | K03 | Rina
```

Kueri ubah:

```sql
UPDATE penjualan_buruk
SET nama_petugas = 'Rina Putri'
WHERE no_nota_penjualan = 'PJ-0001';
```
