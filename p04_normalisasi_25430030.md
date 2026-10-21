# Normalisasi - Perpustakaan Cendekia AFR

## 1. Dokumen sumber dan UNF

Dokumen sumber: slip peminjaman (contoh `PJ-2610-0007`) dari dokumen kebutuhan data Pertemuan 2.

**UNF** (satu slip dalam satu baris, grup buku berulang dalam `{ }`):

```text
SLIP_UNF (no_slip_peminjaman, tanggal_pinjam, kode_petugas, nama_petugas,
          no_anggota, nama_anggota, jenis_anggota,
          { no_eksemplar, kode_judul, judul_buku, pengarang,
            tanggal_harus_kembali, tanggal_kembali,
            jumlah_hari_terlambat, nominal_denda },
          jumlah_buku_slip)
```


## 2. Dependensi fungsional

Setiap FD diturunkan dari aturan bisnis, bukan dari isi contoh data.

| FD | Dependensi | Dasar |
|---|---|---|
| FD1 | no_slip_peminjaman -> tanggal_pinjam, kode_petugas, no_anggota | AB-01 [periksa kode AB] |
| FD2 | kode_petugas -> nama_petugas | satu kode petugas, satu nama |
| FD3 | no_anggota -> nama_anggota, jenis_anggota | AB-07 [periksa kode AB] |
| FD4 | no_eksemplar -> kode_judul, kondisi_eksemplar | AB-08 [periksa kode AB] |
| FD5 | kode_judul -> judul_buku, pengarang, penerbit, kategori_buku | satu kode judul, satu data judul |
| FD6 | (no_slip_peminjaman, no_eksemplar) -> tanggal_kembali | tiap buku dikembalikan pada waktunya sendiri |
| FD7 | tanggal_kembali, tanggal_harus_kembali -> jumlah_hari_terlambat | nilai turunan |
| FD8 | jumlah_hari_terlambat -> nominal_denda | AB-06, nilai turunan (hari x Rp4.000) |



**Keputusan yang harus kamu ambil: letak `tanggal_harus_kembali`.**


Keputusan: `tanggal_harus_kembali` ditempatkan di `peminjaman`, bukan di `detail_peminjaman`. Sesuai AB-03, masa pinjam 7 hari berlaku untuk seluruh buku dalam satu slip, sehingga atributnya hanya bergantung pada `no_slip_peminjaman` (FD1). Bila tetap di detail, atribut itu bergantung pada sebagian kunci gabungan dan melanggar 2NF. Atribut ini tetap disimpan, bukan dihitung dari tanggal pinjam, karena masa pinjam dapat berubah dan slip lama harus mempertahankan batas yang berlaku saat peminjaman. Perubahan ini dicatat pada ERD di bagian 9.

## 3. Menuju 1NF

Grup buku berulang dihilangkan: satu baris untuk setiap buku pada setiap slip. Kunci primer menjadi gabungan `(no_slip_peminjaman, no_eksemplar)`.

```text
SLIP_1NF (no_slip_peminjaman, no_eksemplar, tanggal_pinjam, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, jenis_anggota,
          kode_judul, judul_buku, pengarang, tanggal_harus_kembali,
          tanggal_kembali, jumlah_hari_terlambat, nominal_denda,
          jumlah_buku_slip)
```

Contoh slip `PJ-2610-0007` (4 buku menjadi 4 baris; kolom slip, petugas, dan anggota ikut berulang):

| no_slip_peminjaman | no_eksemplar | judul_buku | tanggal_harus_kembali |
|---|---|---|---|
| PJ-2610-0007 | 2 | nasi yang berbicara | 2026-10-14 |
| PJ-2610-0007 | 1 | gunung basi | 2026-10-14 |

 [TULIS 1-2 kalimat: hasil pemeriksaan 1NF, yaitu tidak ada sel berisi daftar dan tidak ada kolom buku1, buku2.]

## 4. Menuju 2NF

Kunci `SLIP_1NF` adalah gabungan. 2NF melarang atribut yang bergantung pada sebagian kunci.

| FD | Bergantung pada | Sebagian kunci? | Tindakan |
|---|---|---|---|
| FD1 | no_slip_peminjaman saja | ya | pisahkan menjadi PEMINJAMAN |
| FD4, FD5 | no_eksemplar saja | ya | pisahkan menjadi EKSEMPLAR |
| FD6 | seluruh kunci gabungan | tidak | tetap di DETAIL_PEMINJAMAN |

```text
PEMINJAMAN_2NF        (no_slip_peminjaman, tanggal_pinjam, kode_petugas, nama_petugas,
                       no_anggota, nama_anggota, jenis_anggota
                       [, tanggal_harus_kembali, bergantung keputusan bagian 2])
EKSEMPLAR_2NF         (no_eksemplar, kode_judul, judul_buku, pengarang, penerbit,
                       kategori_buku, kondisi_eksemplar, status_eksemplar)
DETAIL_PEMINJAMAN_2NF (no_slip_peminjaman, no_eksemplar, tanggal_kembali
                       [, tanggal_harus_kembali, bergantung keputusan bagian 2])
```

## 5. Menuju 3NF

3NF melarang rantai `A -> B -> C` dalam satu tabel. Rantai yang ditemukan:

- `no_slip_peminjaman -> kode_petugas -> nama_petugas`
- `no_slip_peminjaman -> no_anggota -> nama_anggota, jenis_anggota`
- `no_eksemplar -> kode_judul -> judul_buku, pengarang, penerbit, kategori_buku`

Hasil 3NF (`*` = kunci tamu):

```text
PEMINJAMAN        (no_slip_peminjaman, tanggal_pinjam, kode_petugas*, no_anggota*)
DETAIL_PEMINJAMAN (no_slip_peminjaman*, no_eksemplar*, tanggal_kembali)
EKSEMPLAR         (no_eksemplar, kode_judul*, kondisi_eksemplar, status_eksemplar)
JUDUL_BUKU        (kode_judul, judul_buku, pengarang, penerbit, kategori_buku)
PETUGAS           (kode_petugas, nama_petugas)
ANGGOTA           (no_anggota, nama_anggota, jenis_anggota, no_hp_anggota, status_aktif)
DENDA             (no_kuitansi_denda, no_slip_peminjaman*, no_eksemplar*, status_bayar_denda)
```

### Ringkasan tahapan UNF sampai 3NF

| Tahap | Relasi | Masalah yang dihilangkan |
|---|---|---|
| UNF | SLIP_UNF | (belum dinormalisasi) grup buku berulang |
| 1NF | SLIP_1NF | grup berulang; kunci menjadi gabungan |
| 2NF | PEMINJAMAN, EKSEMPLAR, DETAIL_PEMINJAMAN | ketergantungan pada sebagian kunci |
| 3NF | PEMINJAMAN, DETAIL_PEMINJAMAN, EKSEMPLAR, JUDUL_BUKU, PETUGAS, ANGGOTA, DENDA | rantai FD1-FD2, FD1-FD3, FD4-FD5 |

mengapa judul buku di pisah dari eksemplar? karena jika tidak di pisah maka akan terjadi slip atau bisa juga terjadi anomali. 

## 6. Nilai turunan

| Nilai turunan | Dihitung dari | Keputusan | Alasan |
|---|---|---|---|
| jumlah_buku_slip | banyak baris detail dalam satu slip | disimpan | agar tidak terjadi anomali |
| jumlah_hari_terlambat | tanggal kembali dikurangi tanggal harus kembali | di hitung |  |
| nominal_denda | jumlah hari terlambat x Rp4.000 | di hitung |  |

Petunjuk untuk `nominal_denda`: pikirkan dua keadaan. Pada data yang masih berjalan, tarif denda bisa berubah. Pada kuitansi denda yang sudah dibayar, jumlahnya adalah catatan kejadian yang tidak boleh berubah. Bandingkan dengan keputusan "total" pada nota Kopma.

## 7. Pemeriksaan BCNF

BCNF mensyaratkan setiap penentu adalah kunci kandidat.

| Tabel | Penentu (sisi kiri FD) | Kunci kandidat? | Hasil BCNF |
|---|---|---|---|
| PETUGAS | kode_petugas | ya | memenuhi |
| ANGGOTA | no_anggota | ya | mmenuhi |
| JUDUL_BUKU | kode_judul | ya | memenuhi |
| EKSEMPLAR | no_eksemplar | ya | memenuhi |
| PEMINJAMAN | no_slip_peminjaman | ya | memenuhi |
| DETAIL_PEMINJAMAN | (no_slip_peminjaman, no_eksemplar) | ya | tidak |
| DENDA | no_kuitansi_denda | ya | memenuhi |

tidak ada penentu yang bukan kunci kandidat, dan kunci pengganti `id_*` pada ERD tidak menghapus dependensi di atas.

## 8. Pemetaan ke skema kanonik

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota | - |
| judul_buku | id_judul | kode_judul | - |
| eksemplar | id_eksemplar | no_eksemplar | id_judul |
| peminjaman | id_peminjaman | no_slip_peminjaman | id_petugas, id_anggota |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | - | id_peminjaman, id_eksemplar |
| denda | id_denda | no_kuitansi_denda | id_peminjaman, id_eksemplar |


## 9. Perubahan pada ERD proyek

Setelah normalisasi, atribut `tanggal_harus_kembali` dipindahkan dari entitas `detail_peminjaman` ke entitas `peminjaman`. Alasannya, sesuai AB-03, masa pinjam 7 hari berlaku untuk seluruh buku dalam satu slip, sehingga atribut tersebut hanya bergantung pada `no_slip_peminjaman` (FD1), bukan pada kunci gabungan `(no_slip_peminjaman, no_eksemplar)`. Atribut tetap disimpan karena masa pinjam dapat berubah dan slip lama harus mempertahankan batas yang berlaku saat peminjaman. Entitas lain dan seluruh relasi pada ERD Pertemuan 3 tidak berubah.
